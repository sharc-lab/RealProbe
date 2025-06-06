//===-- LoopUtils.cpp - Loop Utility functions -------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines common loop utility functions.
//
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/Utils/LoopUtils.h"
#include "llvm/ADT/ScopeExit.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/BasicAliasAnalysis.h"
#include "llvm/Analysis/GlobalsModRef.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionAliasAnalysis.h"
#include "llvm/Analysis/ScalarEvolutionExpander.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PatternMatch.h"
#include "llvm/IR/ValueHandle.h"
#include "llvm/Pass.h"
#include "llvm/Support/Debug.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

using namespace llvm;
using namespace llvm::PatternMatch;

#define DEBUG_TYPE "loop-utils"

bool llvm::formDedicatedExitBlocks(Loop *L, DominatorTree *DT, LoopInfo *LI,
                                   bool PreserveLCSSA) {
  bool Changed = false;

  // We re-use a vector for the in-loop predecesosrs.
  SmallVector<BasicBlock *, 4> InLoopPredecessors;

  auto RewriteExit = [&](BasicBlock *BB) {
    assert(InLoopPredecessors.empty() &&
           "Must start with an empty predecessors list!");
    auto Cleanup = make_scope_exit([&] { InLoopPredecessors.clear(); });

    // See if there are any non-loop predecessors of this exit block and
    // keep track of the in-loop predecessors.
    bool IsDedicatedExit = true;
    for (auto *PredBB : predecessors(BB))
      if (L->contains(PredBB)) {
        if (isa<IndirectBrInst>(PredBB->getTerminator()))
          // We cannot rewrite exiting edges from an indirectbr.
          return false;

        InLoopPredecessors.push_back(PredBB);
      } else {
        IsDedicatedExit = false;
      }

    assert(!InLoopPredecessors.empty() && "Must have *some* loop predecessor!");

    // Nothing to do if this is already a dedicated exit.
    if (IsDedicatedExit)
      return false;

    auto *NewExitBB = SplitBlockPredecessors(
        BB, InLoopPredecessors, ".loopexit", DT, LI, PreserveLCSSA);

    if (!NewExitBB)
      DEBUG(dbgs() << "WARNING: Can't create a dedicated exit block for loop: "
                   << *L << "\n");
    else
      DEBUG(dbgs() << "LoopSimplify: Creating dedicated exit block "
                   << NewExitBB->getName() << "\n");
    return true;
  };

  // Walk the exit blocks directly rather than building up a data structure for
  // them, but only visit each one once.
  SmallPtrSet<BasicBlock *, 4> Visited;
  for (auto *BB : L->blocks())
    for (auto *SuccBB : successors(BB)) {
      // We're looking for exit blocks so skip in-loop successors.
      if (L->contains(SuccBB))
        continue;

      // Visit each exit block exactly once.
      if (!Visited.insert(SuccBB).second)
        continue;

      Changed |= RewriteExit(SuccBB);
    }

  return Changed;
}

/// \brief Returns the instructions that use values defined in the loop.
SmallVector<Instruction *, 8> llvm::findDefsUsedOutsideOfLoop(Loop *L) {
  SmallVector<Instruction *, 8> UsedOutside;

  for (auto *Block : L->getBlocks())
    // FIXME: I believe that this could use copy_if if the Inst reference could
    // be adapted into a pointer.
    for (auto &Inst : *Block) {
      auto Users = Inst.users();
      if (any_of(Users, [&](User *U) {
            auto *Use = cast<Instruction>(U);
            return !L->contains(Use->getParent());
          }))
        UsedOutside.push_back(&Inst);
    }

  return UsedOutside;
}

void llvm::getLoopAnalysisUsage(AnalysisUsage &AU) {
  // By definition, all loop passes need the LoopInfo analysis and the
  // Dominator tree it depends on. Because they all participate in the loop
  // pass manager, they must also preserve these.
  AU.addRequired<DominatorTreeWrapperPass>();
  AU.addPreserved<DominatorTreeWrapperPass>();
  AU.addRequired<LoopInfoWrapperPass>();
  AU.addPreserved<LoopInfoWrapperPass>();

  // We must also preserve LoopSimplify and LCSSA. We locally access their IDs
  // here because users shouldn't directly get them from this header.
  extern char &LoopSimplifyID;
  extern char &LCSSAID;
  AU.addRequiredID(LoopSimplifyID);
  AU.addPreservedID(LoopSimplifyID);
  AU.addRequiredID(LCSSAID);
  AU.addPreservedID(LCSSAID);
  // This is used in the LPPassManager to perform LCSSA verification on passes
  // which preserve lcssa form
  AU.addRequired<LCSSAVerificationPass>();
  AU.addPreserved<LCSSAVerificationPass>();

  // Loop passes are designed to run inside of a loop pass manager which means
  // that any function analyses they require must be required by the first loop
  // pass in the manager (so that it is computed before the loop pass manager
  // runs) and preserved by all loop pasess in the manager. To make this
  // reasonably robust, the set needed for most loop passes is maintained here.
  // If your loop pass requires an analysis not listed here, you will need to
  // carefully audit the loop pass manager nesting structure that results.
  AU.addRequired<AAResultsWrapperPass>();
  AU.addPreserved<AAResultsWrapperPass>();
  AU.addPreserved<BasicAAWrapperPass>();
  AU.addPreserved<GlobalsAAWrapperPass>();
  AU.addPreserved<SCEVAAWrapperPass>();
  AU.addRequired<ScalarEvolutionWrapperPass>();
  AU.addPreserved<ScalarEvolutionWrapperPass>();
}

/// Manually defined generic "LoopPass" dependency initialization. This is used
/// to initialize the exact set of passes from above in \c
/// getLoopAnalysisUsage. It can be used within a loop pass's initialization
/// with:
///
///   INITIALIZE_PASS_DEPENDENCY(LoopPass)
///
/// As-if "LoopPass" were a pass.
void llvm::initializeLoopPassPass(PassRegistry &Registry) {
  INITIALIZE_PASS_DEPENDENCY(DominatorTreeWrapperPass)
  INITIALIZE_PASS_DEPENDENCY(LoopInfoWrapperPass)
  INITIALIZE_PASS_DEPENDENCY(LoopSimplify)
  INITIALIZE_PASS_DEPENDENCY(LCSSAWrapperPass)
  INITIALIZE_PASS_DEPENDENCY(AAResultsWrapperPass)
  INITIALIZE_PASS_DEPENDENCY(BasicAAWrapperPass)
  INITIALIZE_PASS_DEPENDENCY(GlobalsAAWrapperPass)
  INITIALIZE_PASS_DEPENDENCY(SCEVAAWrapperPass)
  INITIALIZE_PASS_DEPENDENCY(ScalarEvolutionWrapperPass)
}

/// \brief Find string metadata for loop
///
/// If it has a value (e.g. {"llvm.distribute", 1} return the value as an
/// operand or null otherwise.  If the string metadata is not found return
/// Optional's not-a-value.
Optional<const MDOperand *> llvm::findStringMetadataForLoop(Loop *TheLoop,
                                                            StringRef Name) {
  MDNode *LoopID = TheLoop->getLoopID();
  // Return none if LoopID is false.
  if (!LoopID)
    return None;

  // First operand should refer to the loop id itself.
  assert(LoopID->getNumOperands() > 0 && "requires at least one operand");
  assert(LoopID->getOperand(0) == LoopID && "invalid loop id");

  // Iterate over LoopID operands and look for MDString Metadata
  for (unsigned i = 1, e = LoopID->getNumOperands(); i < e; ++i) {
    MDNode *MD = dyn_cast<MDNode>(LoopID->getOperand(i));
    if (!MD)
      continue;
    MDString *S = dyn_cast<MDString>(MD->getOperand(0));
    if (!S)
      continue;
    // Return true if MDString holds expected MetaData.
    if (Name.equals(S->getString()))
      switch (MD->getNumOperands()) {
      case 1:
        return nullptr;
      case 2:
        return &MD->getOperand(1);
      default:
        llvm_unreachable("loop metadata has 0 or 1 operand");
      }
  }
  return None;
}

/// Does a BFS from a given node to all of its children inside a given loop.
/// The returned vector of nodes includes the starting point.
SmallVector<DomTreeNode *, 16>
llvm::collectChildrenInLoop(DomTreeNode *N, const Loop *CurLoop) {
  SmallVector<DomTreeNode *, 16> Worklist;
  auto AddRegionToWorklist = [&](DomTreeNode *DTN) {
    // Only include subregions in the top level loop.
    BasicBlock *BB = DTN->getBlock();
    if (CurLoop->contains(BB))
      Worklist.push_back(DTN);
  };

  AddRegionToWorklist(N);

  for (size_t I = 0; I < Worklist.size(); I++)
    for (DomTreeNode *Child : Worklist[I]->getChildren())
      AddRegionToWorklist(Child);

  return Worklist;
}

void llvm::deleteDeadLoop(Loop *L, DominatorTree *DT = nullptr,
                          ScalarEvolution *SE = nullptr,
                          LoopInfo *LI = nullptr) {
  assert((!DT || L->isLCSSAForm(*DT)) && "Expected LCSSA!");
  auto *Preheader = L->getLoopPreheader();
  assert(Preheader && "Preheader should exist!");

  // Now that we know the removal is safe, remove the loop by changing the
  // branch from the preheader to go to the single exit block.
  //
  // Because we're deleting a large chunk of code at once, the sequence in which
  // we remove things is very important to avoid invalidation issues.

  // Tell ScalarEvolution that the loop is deleted. Do this before
  // deleting the loop so that ScalarEvolution can look at the loop
  // to determine what it needs to clean up.
  if (SE)
    SE->forgetLoop(L);

  auto *ExitBlock = L->getUniqueExitBlock();
  assert(ExitBlock && "Should have a unique exit block!");
  assert(L->hasDedicatedExits() && "Loop should have dedicated exits!");

  auto *OldBr = dyn_cast<BranchInst>(Preheader->getTerminator());
  assert(OldBr && "Preheader must end with a branch");
  assert(OldBr->isUnconditional() && "Preheader must have a single successor");
  // Connect the preheader to the exit block. Keep the old edge to the header
  // around to perform the dominator tree update in two separate steps
  // -- #1 insertion of the edge preheader -> exit and #2 deletion of the edge
  // preheader -> header.
  //
  //
  // 0.  Preheader          1.  Preheader           2.  Preheader
  //        |                    |   |                   |
  //        V                    |   V                   |
  //      Header <--\            | Header <--\           | Header <--\
  //       |  |     |            |  |  |     |           |  |  |     |
  //       |  V     |            |  |  V     |           |  |  V     |
  //       | Body --/            |  | Body --/           |  | Body --/
  //       V                     V  V                    V  V
  //      Exit                   Exit                    Exit
  //
  // By doing this is two separate steps we can perform the dominator tree
  // update without using the batch update API.
  //
  // Even when the loop is never executed, we cannot remove the edge from the
  // source block to the exit block. Consider the case where the unexecuted loop
  // branches back to an outer loop. If we deleted the loop and removed the edge
  // coming to this inner loop, this will break the outer loop structure (by
  // deleting the backedge of the outer loop). If the outer loop is indeed a
  // non-loop, it will be deleted in a future iteration of loop deletion pass.
  IRBuilder<> Builder(OldBr);
  Builder.CreateCondBr(Builder.getFalse(), L->getHeader(), ExitBlock);
  // Remove the old branch. The conditional branch becomes a new terminator.
  OldBr->eraseFromParent();

  // Rewrite phis in the exit block to get their inputs from the Preheader
  // instead of the exiting block.
  for (PHINode &P : ExitBlock->phis()) {
    // Set the zero'th element of Phi to be from the preheader and remove all
    // other incoming values. Given the loop has dedicated exits, all other
    // incoming values must be from the exiting blocks.
    int PredIndex = 0;
    P.setIncomingBlock(PredIndex, Preheader);
    // Removes all incoming values from all other exiting blocks (including
    // duplicate values from an exiting block).
    // Nuke all entries except the zero'th entry which is the preheader entry.
    // NOTE! We need to remove Incoming Values in the reverse order as done
    // below, to keep the indices valid for deletion (removeIncomingValues
    // updates getNumIncomingValues and shifts all values down into the operand
    // being deleted).
    for (unsigned i = 0, e = P.getNumIncomingValues() - 1; i != e; ++i)
      P.removeIncomingValue(e - i, false);

    assert((P.getNumIncomingValues() == 1 &&
            P.getIncomingBlock(PredIndex) == Preheader) &&
           "Should have exactly one value and that's from the preheader!");
  }

  // Disconnect the loop body by branching directly to its exit.
  Builder.SetInsertPoint(Preheader->getTerminator());
  Builder.CreateBr(ExitBlock);
  // Remove the old branch.
  Preheader->getTerminator()->eraseFromParent();

  if (DT) {
    // Update the dominator tree by informing it about the new edge from the
    // preheader to the exit.
    DT->insertEdge(Preheader, ExitBlock);
    // Inform the dominator tree about the removed edge.
    DT->deleteEdge(Preheader, L->getHeader());
  }

  // Given LCSSA form is satisfied, we should not have users of instructions
  // within the dead loop outside of the loop. However, LCSSA doesn't take
  // unreachable uses into account. We handle them here.
  // We could do it after drop all references (in this case all users in the
  // loop will be already eliminated and we have less work to do but according
  // to API doc of User::dropAllReferences only valid operation after dropping
  // references, is deletion. So let's substitute all usages of
  // instruction from the loop with undef value of corresponding type first.
  for (auto *Block : L->blocks())
    for (Instruction &I : *Block) {
      auto *Undef = UndefValue::get(I.getType());
      for (Value::use_iterator UI = I.use_begin(), E = I.use_end(); UI != E;) {
        Use &U = *UI;
        ++UI;
        if (auto *Usr = dyn_cast<Instruction>(U.getUser()))
          if (L->contains(Usr->getParent()))
            continue;
        // If we have a DT then we can check that uses outside a loop only in
        // unreachable block.
        if (DT)
          assert(!DT->isReachableFromEntry(U) &&
                 "Unexpected user in reachable block");
        U.set(Undef);
      }
    }

  // Remove the block from the reference counting scheme, so that we can
  // delete it freely later.
  for (auto *Block : L->blocks())
    Block->dropAllReferences();

  if (LI) {
    // Erase the instructions and the blocks without having to worry
    // about ordering because we already dropped the references.
    // NOTE: This iteration is safe because erasing the block does not remove
    // its entry from the loop's block list.  We do that in the next section.
    for (Loop::block_iterator LpI = L->block_begin(), LpE = L->block_end();
         LpI != LpE; ++LpI)
      (*LpI)->eraseFromParent();

    // Finally, the blocks from loopinfo.  This has to happen late because
    // otherwise our loop iterators won't work.

    SmallPtrSet<BasicBlock *, 8> blocks;
    blocks.insert(L->block_begin(), L->block_end());
    for (BasicBlock *BB : blocks)
      LI->removeBlock(BB);

    // The last step is to update LoopInfo now that we've eliminated this loop.
    LI->erase(L);
  }
}

/// Returns true if the instruction in a loop is guaranteed to execute at least
/// once.
bool llvm::isGuaranteedToExecute(const Instruction &Inst,
                                 const DominatorTree *DT, const Loop *CurLoop,
                                 const LoopSafetyInfo *SafetyInfo) {
  // We have to check to make sure that the instruction dominates all
  // of the exit blocks.  If it doesn't, then there is a path out of the loop
  // which does not execute this instruction, so we can't hoist it.

  // If the instruction is in the header block for the loop (which is very
  // common), it is always guaranteed to dominate the exit blocks.  Since this
  // is a common case, and can save some work, check it now.
  if (Inst.getParent() == CurLoop->getHeader())
    // If there's a throw in the header block, we can't guarantee we'll reach
    // Inst.
    return !SafetyInfo->HeaderMayThrow;

  // Somewhere in this loop there is an instruction which may throw and make us
  // exit the loop.
  if (SafetyInfo->MayThrow)
    return false;

  // Get the exit blocks for the current loop.
  SmallVector<BasicBlock *, 8> ExitBlocks;
  CurLoop->getExitBlocks(ExitBlocks);

  // Verify that the block dominates each of the exit blocks of the loop.
  for (BasicBlock *ExitBlock : ExitBlocks)
    if (!DT->dominates(Inst.getParent(), ExitBlock))
      return false;

  // As a degenerate case, if the loop is statically infinite then we haven't
  // proven anything since there are no exit blocks.
  if (ExitBlocks.empty())
    return false;

  // FIXME: In general, we have to prove that the loop isn't an infinite loop.
  // See http::llvm.org/PR24078 .  (The "ExitBlocks.empty()" check above is
  // just a special case of this.)
  return true;
}

Optional<unsigned> llvm::getLoopEstimatedTripCount(Loop *L) {
  // Only support loops with a unique exiting block, and a latch.
  if (!L->getExitingBlock())
    return None;

  // Get the branch weights for the loop's backedge.
  BranchInst *LatchBR =
      dyn_cast<BranchInst>(L->getLoopLatch()->getTerminator());
  if (!LatchBR || LatchBR->getNumSuccessors() != 2)
    return None;

  assert((LatchBR->getSuccessor(0) == L->getHeader() ||
          LatchBR->getSuccessor(1) == L->getHeader()) &&
         "At least one edge out of the latch must go to the header");

  // To estimate the number of times the loop body was executed, we want to
  // know the number of times the backedge was taken, vs. the number of times
  // we exited the loop.
  uint64_t TrueVal, FalseVal;
  if (!LatchBR->extractProfMetadata(TrueVal, FalseVal))
    return None;

  if (!TrueVal || !FalseVal)
    return 0;

  // Divide the count of the backedge by the count of the edge exiting the loop,
  // rounding to nearest.
  if (LatchBR->getSuccessor(0) == L->getHeader())
    return (TrueVal + (FalseVal / 2)) / FalseVal;
  else
    return (FalseVal + (TrueVal / 2)) / TrueVal;
}

/// \brief Adds a 'fast' flag to floating point operations.
static Value *addFastMathFlag(Value *V) {
  if (isa<FPMathOperator>(V)) {
    FastMathFlags Flags;
    Flags.setFast();
    cast<Instruction>(V)->setFastMathFlags(Flags);
  }
  return V;
}

// Helper to generate a log2 shuffle reduction.
Value *
llvm::getShuffleReduction(IRBuilder<> &Builder, Value *Src, unsigned Op,
                          RecurrenceDescriptor::MinMaxRecurrenceKind MinMaxKind,
                          ArrayRef<Value *> RedOps) {
  unsigned VF = Src->getType()->getVectorNumElements();
  // VF is a power of 2 so we can emit the reduction using log2(VF) shuffles
  // and vector ops, reducing the set of values being computed by half each
  // round.
  assert(isPowerOf2_32(VF) &&
         "Reduction emission only supported for pow2 vectors!");
  Value *TmpVec = Src;
  SmallVector<Constant *, 32> ShuffleMask(VF, nullptr);
  for (unsigned i = VF; i != 1; i >>= 1) {
    // Move the upper half of the vector to the lower half.
    for (unsigned j = 0; j != i / 2; ++j)
      ShuffleMask[j] = Builder.getInt32(i / 2 + j);

    // Fill the rest of the mask with undef.
    std::fill(&ShuffleMask[i / 2], ShuffleMask.end(),
              UndefValue::get(Builder.getInt32Ty()));

    Value *Shuf = Builder.CreateShuffleVector(
        TmpVec, UndefValue::get(TmpVec->getType()),
        ConstantVector::get(ShuffleMask), "rdx.shuf");

    if (Op != Instruction::ICmp && Op != Instruction::FCmp) {
      // Floating point operations had to be 'fast' to enable the reduction.
      TmpVec = addFastMathFlag(Builder.CreateBinOp((Instruction::BinaryOps)Op,
                                                   TmpVec, Shuf, "bin.rdx"));
    } else {
      assert(MinMaxKind != RecurrenceDescriptor::MRK_Invalid &&
             "Invalid min/max");
      TmpVec = RecurrenceDescriptor::createMinMaxOp(Builder, MinMaxKind, TmpVec,
                                                    Shuf);
    }
    if (!RedOps.empty())
      propagateIRFlags(TmpVec, RedOps);
  }
  // The result is in the first element of the vector.
  return Builder.CreateExtractElement(TmpVec, Builder.getInt32(0));
}

/// Create a simple vector reduction specified by an opcode and some
/// flags (if generating min/max reductions).
Value *llvm::createSimpleTargetReduction(
    IRBuilder<> &Builder, const TargetTransformInfo *TTI, unsigned Opcode,
    Value *Src, TargetTransformInfo::ReductionFlags Flags,
    ArrayRef<Value *> RedOps) {
  assert(isa<VectorType>(Src->getType()) && "Type must be a vector");

  Value *ScalarUdf = UndefValue::get(Src->getType()->getVectorElementType());
  std::function<Value *()> BuildFunc;
  using RD = RecurrenceDescriptor;
  RD::MinMaxRecurrenceKind MinMaxKind = RD::MRK_Invalid;
  // TODO: Support creating ordered reductions.
  FastMathFlags FMFFast;
  FMFFast.setFast();

  switch (Opcode) {
  case Instruction::Add:
    BuildFunc = [&]() { return Builder.CreateAddReduce(Src); };
    break;
  case Instruction::Mul:
    BuildFunc = [&]() { return Builder.CreateMulReduce(Src); };
    break;
  case Instruction::And:
    BuildFunc = [&]() { return Builder.CreateAndReduce(Src); };
    break;
  case Instruction::Or:
    BuildFunc = [&]() { return Builder.CreateOrReduce(Src); };
    break;
  case Instruction::Xor:
    BuildFunc = [&]() { return Builder.CreateXorReduce(Src); };
    break;
  case Instruction::FAdd:
    BuildFunc = [&]() {
      auto Rdx = Builder.CreateFAddReduce(ScalarUdf, Src);
      cast<CallInst>(Rdx)->setFastMathFlags(FMFFast);
      return Rdx;
    };
    break;
  case Instruction::FMul:
    BuildFunc = [&]() {
      auto Rdx = Builder.CreateFMulReduce(ScalarUdf, Src);
      cast<CallInst>(Rdx)->setFastMathFlags(FMFFast);
      return Rdx;
    };
    break;
  case Instruction::ICmp:
    if (Flags.IsMaxOp) {
      MinMaxKind = Flags.IsSigned ? RD::MRK_SIntMax : RD::MRK_UIntMax;
      BuildFunc = [&]() {
        return Builder.CreateIntMaxReduce(Src, Flags.IsSigned);
      };
    } else {
      MinMaxKind = Flags.IsSigned ? RD::MRK_SIntMin : RD::MRK_UIntMin;
      BuildFunc = [&]() {
        return Builder.CreateIntMinReduce(Src, Flags.IsSigned);
      };
    }
    break;
  case Instruction::FCmp:
    if (Flags.IsMaxOp) {
      MinMaxKind = RD::MRK_FloatMax;
      BuildFunc = [&]() { return Builder.CreateFPMaxReduce(Src, Flags.NoNaN); };
    } else {
      MinMaxKind = RD::MRK_FloatMin;
      BuildFunc = [&]() { return Builder.CreateFPMinReduce(Src, Flags.NoNaN); };
    }
    break;
  default:
    llvm_unreachable("Unhandled opcode");
    break;
  }
  if (TTI->useReductionIntrinsic(Opcode, Src->getType(), Flags))
    return BuildFunc();
  return getShuffleReduction(Builder, Src, Opcode, MinMaxKind, RedOps);
}

/// Create a vector reduction using a given recurrence descriptor.
Value *llvm::createTargetReduction(IRBuilder<> &B,
                                   const TargetTransformInfo *TTI,
                                   RecurrenceDescriptor &Desc, Value *Src,
                                   bool NoNaN) {
  // TODO: Support in-order reductions based on the recurrence descriptor.
  using RD = RecurrenceDescriptor;
  RD::RecurrenceKind RecKind = Desc.getRecurrenceKind();
  TargetTransformInfo::ReductionFlags Flags;
  Flags.NoNaN = NoNaN;
  switch (RecKind) {
  case RD::RK_FloatAdd:
    return createSimpleTargetReduction(B, TTI, Instruction::FAdd, Src, Flags);
  case RD::RK_FloatMult:
    return createSimpleTargetReduction(B, TTI, Instruction::FMul, Src, Flags);
  case RD::RK_IntegerAdd:
    return createSimpleTargetReduction(B, TTI, Instruction::Add, Src, Flags);
  case RD::RK_IntegerMult:
    return createSimpleTargetReduction(B, TTI, Instruction::Mul, Src, Flags);
  case RD::RK_IntegerAnd:
    return createSimpleTargetReduction(B, TTI, Instruction::And, Src, Flags);
  case RD::RK_IntegerOr:
    return createSimpleTargetReduction(B, TTI, Instruction::Or, Src, Flags);
  case RD::RK_IntegerXor:
    return createSimpleTargetReduction(B, TTI, Instruction::Xor, Src, Flags);
  case RD::RK_IntegerMinMax: {
    RD::MinMaxRecurrenceKind MMKind = Desc.getMinMaxRecurrenceKind();
    Flags.IsMaxOp = (MMKind == RD::MRK_SIntMax || MMKind == RD::MRK_UIntMax);
    Flags.IsSigned = (MMKind == RD::MRK_SIntMax || MMKind == RD::MRK_SIntMin);
    return createSimpleTargetReduction(B, TTI, Instruction::ICmp, Src, Flags);
  }
  case RD::RK_FloatMinMax: {
    Flags.IsMaxOp = Desc.getMinMaxRecurrenceKind() == RD::MRK_FloatMax;
    return createSimpleTargetReduction(B, TTI, Instruction::FCmp, Src, Flags);
  }
  default:
    llvm_unreachable("Unhandled RecKind");
  }
}

void llvm::propagateIRFlags(Value *I, ArrayRef<Value *> VL, Value *OpValue) {
  auto *VecOp = dyn_cast<Instruction>(I);
  if (!VecOp)
    return;
  auto *Intersection = (OpValue == nullptr) ? dyn_cast<Instruction>(VL[0])
                                            : dyn_cast<Instruction>(OpValue);
  if (!Intersection)
    return;
  const unsigned Opcode = Intersection->getOpcode();
  VecOp->copyIRFlags(Intersection);
  for (auto *V : VL) {
    auto *Instr = dyn_cast<Instruction>(V);
    if (!Instr)
      continue;
    if (OpValue == nullptr || Opcode == Instr->getOpcode())
      VecOp->andIRFlags(V);
  }
}
