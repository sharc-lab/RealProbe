//===- ADCE.cpp - Code to perform dead code elimination -------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the Aggressive Dead Code Elimination pass.  This pass
// optimistically assumes that all instructions are dead until proven otherwise,
// allowing it to eliminate dead computations that other DCE passes do not
// catch, particularly involving loop computations.
//
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/Scalar/ADCE.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DepthFirstIterator.h"
#include "llvm/ADT/GraphTraits.h"
#include "llvm/ADT/MapVector.h"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/GlobalsModRef.h"
#include "llvm/Analysis/IteratedDominanceFrontier.h"
#include "llvm/Analysis/PostDominators.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/IR/DebugLoc.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Use.h"
#include "llvm/IR/Value.h"
#include "llvm/Pass.h"
#include "llvm/ProfileData/InstrProf.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Scalar.h"
#include <cassert>
#include <cstddef>
#include <utility>

using namespace llvm;

#define DEBUG_TYPE "adce"

STATISTIC(NumRemoved, "Number of instructions removed");
STATISTIC(NumBranchesRemoved, "Number of branch instructions removed");

// This is a temporary option until we change the interface to this pass based
// on optimization level.
static cl::opt<bool> RemoveControlFlowFlag("adce-remove-control-flow",
                                           cl::init(true), cl::Hidden);

// This option enables removing of may-be-infinite loops which have no other
// effect.
static cl::opt<bool> RemoveLoops("adce-remove-loops", cl::init(false),
                                 cl::Hidden);

namespace {

/// Information about Instructions
struct InstInfoType {
  /// True if the associated instruction is live.
  bool Live = false;

  /// Quick access to information for block containing associated Instruction.
  struct BlockInfoType *Block = nullptr;
};

/// Information about basic blocks relevant to dead code elimination.
struct BlockInfoType {
  /// True when this block contains a live instructions.
  bool Live = false;

  /// True when this block ends in an unconditional branch.
  bool UnconditionalBranch = false;

  /// True when this block is known to have live PHI nodes.
  bool HasLivePhiNodes = false;

  /// Control dependence sources need to be live for this block.
  bool CFLive = false;

  /// Quick access to the LiveInfo for the terminator,
  /// holds the value &InstInfo[Terminator]
  InstInfoType *TerminatorLiveInfo = nullptr;

  /// Corresponding BasicBlock.
  BasicBlock *BB = nullptr;

  /// Cache of BB->getTerminator().
  TerminatorInst *Terminator = nullptr;

  /// Post-order numbering of reverse control flow graph.
  unsigned PostOrder;

  bool terminatorIsLive() const { return TerminatorLiveInfo->Live; }
};

class AggressiveDeadCodeElimination {
  Function &F;

  // ADCE does not use DominatorTree per se, but it updates it to preserve the
  // analysis.
  DominatorTree &DT;
  PostDominatorTree &PDT;

  /// Mapping of blocks to associated information, an element in BlockInfoVec.
  /// Use MapVector to get deterministic iteration order.
  MapVector<BasicBlock *, BlockInfoType> BlockInfo;
  bool isLive(BasicBlock *BB) { return BlockInfo[BB].Live; }

  /// Mapping of instructions to associated information.
  DenseMap<Instruction *, InstInfoType> InstInfo;
  bool isLive(Instruction *I) { return InstInfo[I].Live; }

  /// Instructions known to be live where we need to mark
  /// reaching definitions as live.
  SmallVector<Instruction *, 128> Worklist;

  /// Debug info scopes around a live instruction.
  SmallPtrSet<const Metadata *, 32> AliveScopes;

  /// Set of blocks with not known to have live terminators.
  SmallSetVector<BasicBlock *, 16> BlocksWithDeadTerminators;

  /// The set of blocks which we have determined whose control
  /// dependence sources must be live and which have not had
  /// those dependences analyzed.
  SmallPtrSet<BasicBlock *, 16> NewLiveBlocks;

  /// Set up auxiliary data structures for Instructions and BasicBlocks and
  /// initialize the Worklist to the set of must-be-live Instruscions.
  void initialize();

  /// Return true for operations which are always treated as live.
  bool isAlwaysLive(Instruction &I);

  /// Return true for instrumentation instructions for value profiling.
  bool isInstrumentsConstant(Instruction &I);

  /// Propagate liveness to reaching definitions.
  void markLiveInstructions();

  /// Mark an instruction as live.
  void markLive(Instruction *I);

  /// Mark a block as live.
  void markLive(BlockInfoType &BB);
  void markLive(BasicBlock *BB) { markLive(BlockInfo[BB]); }

  /// Mark terminators of control predecessors of a PHI node live.
  void markPhiLive(PHINode *PN);

  /// Record the Debug Scopes which surround live debug information.
  void collectLiveScopes(const DILocalScope &LS);
  void collectLiveScopes(const DILocation &DL);

  /// Analyze dead branches to find those whose branches are the sources
  /// of control dependences impacting a live block. Those branches are
  /// marked live.
  void markLiveBranchesFromControlDependences();

  /// Remove instructions not marked live, return if any any instruction
  /// was removed.
  bool removeDeadInstructions();

  /// Identify connected sections of the control flow graph which have
  /// dead terminators and rewrite the control flow graph to remove them.
  void updateDeadRegions();

  /// Set the BlockInfo::PostOrder field based on a post-order
  /// numbering of the reverse control flow graph.
  void computeReversePostOrder();

  /// Make the terminator of this block an unconditional branch to \p Target.
  void makeUnconditional(BasicBlock *BB, BasicBlock *Target);

public:
  AggressiveDeadCodeElimination(Function &F, DominatorTree &DT,
                                PostDominatorTree &PDT)
      : F(F), DT(DT), PDT(PDT) {}

  bool performDeadCodeElimination();
};

} // end anonymous namespace

bool AggressiveDeadCodeElimination::performDeadCodeElimination() {
  initialize();
  markLiveInstructions();
  return removeDeadInstructions();
}

static bool isUnconditionalBranch(TerminatorInst *Term) {
  auto *BR = dyn_cast<BranchInst>(Term);
  return BR && BR->isUnconditional();
}

void AggressiveDeadCodeElimination::initialize() {
  auto NumBlocks = F.size();

  // We will have an entry in the map for each block so we grow the
  // structure to twice that size to keep the load factor low in the hash table.
  BlockInfo.reserve(NumBlocks);
  size_t NumInsts = 0;

  // Iterate over blocks and initialize BlockInfoVec entries, count
  // instructions to size the InstInfo hash table.
  for (auto &BB : F) {
    NumInsts += BB.size();
    auto &Info = BlockInfo[&BB];
    Info.BB = &BB;
    Info.Terminator = BB.getTerminator();
    Info.UnconditionalBranch = isUnconditionalBranch(Info.Terminator);
  }

  // Initialize instruction map and set pointers to block info.
  InstInfo.reserve(NumInsts);
  for (auto &BBInfo : BlockInfo)
    for (Instruction &I : *BBInfo.second.BB)
      InstInfo[&I].Block = &BBInfo.second;

  // Since BlockInfoVec holds pointers into InstInfo and vice-versa, we may not
  // add any more elements to either after this point.
  for (auto &BBInfo : BlockInfo)
    BBInfo.second.TerminatorLiveInfo = &InstInfo[BBInfo.second.Terminator];

  // Collect the set of "root" instructions that are known live.
  for (Instruction &I : instructions(F))
    if (isAlwaysLive(I))
      markLive(&I);

  if (!RemoveControlFlowFlag)
    return;

  if (!RemoveLoops) {
    // This stores state for the depth-first iterator. In addition
    // to recording which nodes have been visited we also record whether
    // a node is currently on the "stack" of active ancestors of the current
    // node.
    using StatusMap = DenseMap<BasicBlock *, bool>;

    class DFState : public StatusMap {
    public:
      std::pair<StatusMap::iterator, bool> insert(BasicBlock *BB) {
        return StatusMap::insert(std::make_pair(BB, true));
      }

      // Invoked after we have visited all children of a node.
      void completed(BasicBlock *BB) { (*this)[BB] = false; }

      // Return true if \p BB is currently on the active stack
      // of ancestors.
      bool onStack(BasicBlock *BB) {
        auto Iter = find(BB);
        return Iter != end() && Iter->second;
      }
    } State;

    State.reserve(F.size());
    // Iterate over blocks in depth-first pre-order and
    // treat all edges to a block already seen as loop back edges
    // and mark the branch live it if there is a back edge.
    for (auto *BB: depth_first_ext(&F.getEntryBlock(), State)) {
      TerminatorInst *Term = BB->getTerminator();
      if (isLive(Term))
        continue;

      for (auto *Succ : successors(BB))
        if (State.onStack(Succ)) {
          // back edge....
          markLive(Term);
          break;
        }
    }
  }

  // Mark blocks live if there is no path from the block to a
  // return of the function.
  // We do this by seeing which of the postdomtree root children exit the
  // program, and for all others, mark the subtree live.
  for (auto &PDTChild : children<DomTreeNode *>(PDT.getRootNode())) {
    auto *BB = PDTChild->getBlock();
    auto &Info = BlockInfo[BB];
    // Real function return
    if (isa<ReturnInst>(Info.Terminator)) {
      DEBUG(dbgs() << "post-dom root child is a return: " << BB->getName()
                   << '\n';);
      continue;
    }

    // This child is something else, like an infinite loop.
    for (auto DFNode : depth_first(PDTChild))
      markLive(BlockInfo[DFNode->getBlock()].Terminator);
  }

  // Treat the entry block as always live
  auto *BB = &F.getEntryBlock();
  auto &EntryInfo = BlockInfo[BB];
  EntryInfo.Live = true;
  if (EntryInfo.UnconditionalBranch)
    markLive(EntryInfo.Terminator);

  // Build initial collection of blocks with dead terminators
  for (auto &BBInfo : BlockInfo)
    if (!BBInfo.second.terminatorIsLive())
      BlocksWithDeadTerminators.insert(BBInfo.second.BB);
}

bool AggressiveDeadCodeElimination::isAlwaysLive(Instruction &I) {
  // TODO -- use llvm::isInstructionTriviallyDead
  if (I.isEHPad() || I.mayHaveSideEffects()) {
    // Skip any value profile instrumentation calls if they are
    // instrumenting constants.
    if (isInstrumentsConstant(I))
      return false;
    return true;
  }
  if (!isa<TerminatorInst>(I))
    return false;
  if (RemoveControlFlowFlag && (isa<BranchInst>(I) || isa<SwitchInst>(I)))
    return false;
  return true;
}

// Check if this instruction is a runtime call for value profiling and
// if it's instrumenting a constant.
bool AggressiveDeadCodeElimination::isInstrumentsConstant(Instruction &I) {
  // TODO -- move this test into llvm::isInstructionTriviallyDead
  if (CallInst *CI = dyn_cast<CallInst>(&I))
    if (Function *Callee = CI->getCalledFunction())
      if (Callee->getName().equals(getInstrProfValueProfFuncName()))
        if (isa<Constant>(CI->getArgOperand(0)))
          return true;
  return false;
}

void AggressiveDeadCodeElimination::markLiveInstructions() {
  // Propagate liveness backwards to operands.
  do {
    // Worklist holds newly discovered live instructions
    // where we need to mark the inputs as live.
    while (!Worklist.empty()) {
      Instruction *LiveInst = Worklist.pop_back_val();
      DEBUG(dbgs() << "work live: "; LiveInst->dump(););

      for (Use &OI : LiveInst->operands())
        if (Instruction *Inst = dyn_cast<Instruction>(OI))
          markLive(Inst);

      if (auto *PN = dyn_cast<PHINode>(LiveInst))
        markPhiLive(PN);
    }

    // After data flow liveness has been identified, examine which branch
    // decisions are required to determine live instructions are executed.
    markLiveBranchesFromControlDependences();

  } while (!Worklist.empty());
}

void AggressiveDeadCodeElimination::markLive(Instruction *I) {
  auto &Info = InstInfo[I];
  if (Info.Live)
    return;

  DEBUG(dbgs() << "mark live: "; I->dump());
  Info.Live = true;
  Worklist.push_back(I);

  // Collect the live debug info scopes attached to this instruction.
  if (const DILocation *DL = I->getDebugLoc())
    collectLiveScopes(*DL);

  // Mark the containing block live
  auto &BBInfo = *Info.Block;
  if (BBInfo.Terminator == I) {
    BlocksWithDeadTerminators.remove(BBInfo.BB);
    // For live terminators, mark destination blocks
    // live to preserve this control flow edges.
    if (!BBInfo.UnconditionalBranch)
      for (auto *BB : successors(I->getParent()))
        markLive(BB);
  }
  markLive(BBInfo);
}

void AggressiveDeadCodeElimination::markLive(BlockInfoType &BBInfo) {
  if (BBInfo.Live)
    return;
  DEBUG(dbgs() << "mark block live: " << BBInfo.BB->getName() << '\n');
  BBInfo.Live = true;
  if (!BBInfo.CFLive) {
    BBInfo.CFLive = true;
    NewLiveBlocks.insert(BBInfo.BB);
  }

  // Mark unconditional branches at the end of live
  // blocks as live since there is no work to do for them later
  if (BBInfo.UnconditionalBranch)
    markLive(BBInfo.Terminator);
}

void AggressiveDeadCodeElimination::collectLiveScopes(const DILocalScope &LS) {
  if (!AliveScopes.insert(&LS).second)
    return;

  if (isa<DISubprogram>(LS))
    return;

  // Tail-recurse through the scope chain.
  collectLiveScopes(cast<DILocalScope>(*LS.getScope()));
}

void AggressiveDeadCodeElimination::collectLiveScopes(const DILocation &DL) {
  // Even though DILocations are not scopes, shove them into AliveScopes so we
  // don't revisit them.
  if (!AliveScopes.insert(&DL).second)
    return;

  // Collect live scopes from the scope chain.
  collectLiveScopes(*DL.getScope());

  // Tail-recurse through the inlined-at chain.
  if (const DILocation *IA = DL.getInlinedAt())
    collectLiveScopes(*IA);
}

void AggressiveDeadCodeElimination::markPhiLive(PHINode *PN) {
  auto &Info = BlockInfo[PN->getParent()];
  // Only need to check this once per block.
  if (Info.HasLivePhiNodes)
    return;
  Info.HasLivePhiNodes = true;

  // If a predecessor block is not live, mark it as control-flow live
  // which will trigger marking live branches upon which
  // that block is control dependent.
  for (auto *PredBB : predecessors(Info.BB)) {
    auto &Info = BlockInfo[PredBB];
    if (!Info.CFLive) {
      Info.CFLive = true;
      NewLiveBlocks.insert(PredBB);
    }
  }
}

void AggressiveDeadCodeElimination::markLiveBranchesFromControlDependences() {
  if (BlocksWithDeadTerminators.empty())
    return;

  DEBUG({
    dbgs() << "new live blocks:\n";
    for (auto *BB : NewLiveBlocks)
      dbgs() << "\t" << BB->getName() << '\n';
    dbgs() << "dead terminator blocks:\n";
    for (auto *BB : BlocksWithDeadTerminators)
      dbgs() << "\t" << BB->getName() << '\n';
  });

  // The dominance frontier of a live block X in the reverse
  // control graph is the set of blocks upon which X is control
  // dependent. The following sequence computes the set of blocks
  // which currently have dead terminators that are control
  // dependence sources of a block which is in NewLiveBlocks.

  const SmallPtrSet<BasicBlock *, 16> BWDT{
      BlocksWithDeadTerminators.begin(),
      BlocksWithDeadTerminators.end()
  };
  SmallVector<BasicBlock *, 32> IDFBlocks;
  ReverseIDFCalculator IDFs(PDT);
  IDFs.setDefiningBlocks(NewLiveBlocks);
  IDFs.setLiveInBlocks(BWDT);
  IDFs.calculate(IDFBlocks);
  NewLiveBlocks.clear();

  // Dead terminators which control live blocks are now marked live.
  for (auto *BB : IDFBlocks) {
    DEBUG(dbgs() << "live control in: " << BB->getName() << '\n');
    markLive(BB->getTerminator());
  }
}

//===----------------------------------------------------------------------===//
//
//  Routines to update the CFG and SSA information before removing dead code.
//
//===----------------------------------------------------------------------===//
bool AggressiveDeadCodeElimination::removeDeadInstructions() {
  // Updates control and dataflow around dead blocks
  updateDeadRegions();

  DEBUG({
    for (Instruction &I : instructions(F)) {
      // Check if the instruction is alive.
      if (isLive(&I))
        continue;

      if (auto *DII = dyn_cast<DbgInfoIntrinsic>(&I)) {
        // Check if the scope of this variable location is alive.
        if (AliveScopes.count(DII->getDebugLoc()->getScope()))
          continue;

        // If intrinsic is pointing at a live SSA value, there may be an
        // earlier optimization bug: if we know the location of the variable,
        // why isn't the scope of the location alive?
        if (Value *V = DII->getVariableLocation())
          if (Instruction *II = dyn_cast<Instruction>(V))
            if (isLive(II))
              dbgs() << "Dropping debug info for " << *DII << "\n";
      }
    }
  });

  // The inverse of the live set is the dead set.  These are those instructions
  // that have no side effects and do not influence the control flow or return
  // value of the function, and may therefore be deleted safely.
  // NOTE: We reuse the Worklist vector here for memory efficiency.
  for (Instruction &I : instructions(F)) {
    // Check if the instruction is alive.
    if (isLive(&I))
      continue;

    if (auto *DII = dyn_cast<DbgInfoIntrinsic>(&I)) {
      // Check if the scope of this variable location is alive.
      if (AliveScopes.count(DII->getDebugLoc()->getScope()))
        continue;

      // Fallthrough and drop the intrinsic.
    }

    // Prepare to delete.
    Worklist.push_back(&I);
    I.dropAllReferences();
  }

  for (Instruction *&I : Worklist) {
    ++NumRemoved;
    I->eraseFromParent();
  }

  return !Worklist.empty();
}

// A dead region is the set of dead blocks with a common live post-dominator.
void AggressiveDeadCodeElimination::updateDeadRegions() {
  DEBUG({
    dbgs() << "final dead terminator blocks: " << '\n';
    for (auto *BB : BlocksWithDeadTerminators)
      dbgs() << '\t' << BB->getName()
             << (BlockInfo[BB].Live ? " LIVE\n" : "\n");
  });

  // Don't compute the post ordering unless we needed it.
  bool HavePostOrder = false;

  for (auto *BB : BlocksWithDeadTerminators) {
    auto &Info = BlockInfo[BB];
    if (Info.UnconditionalBranch) {
      InstInfo[Info.Terminator].Live = true;
      continue;
    }

    if (!HavePostOrder) {
      computeReversePostOrder();
      HavePostOrder = true;
    }

    // Add an unconditional branch to the successor closest to the
    // end of the function which insures a path to the exit for each
    // live edge.
    BlockInfoType *PreferredSucc = nullptr;
    for (auto *Succ : successors(BB)) {
      auto *Info = &BlockInfo[Succ];
      if (!PreferredSucc || PreferredSucc->PostOrder < Info->PostOrder)
        PreferredSucc = Info;
    }
    assert((PreferredSucc && PreferredSucc->PostOrder > 0) &&
           "Failed to find safe successor for dead branch");

    // Collect removed successors to update the (Post)DominatorTrees.
    SmallPtrSet<BasicBlock *, 4> RemovedSuccessors;
    bool First = true;
    for (auto *Succ : successors(BB)) {
      if (!First || Succ != PreferredSucc->BB) {
        Succ->removePredecessor(BB);
        RemovedSuccessors.insert(Succ);
      } else
        First = false;
    }
    makeUnconditional(BB, PreferredSucc->BB);

    // Inform the dominators about the deleted CFG edges.
    SmallVector<DominatorTree::UpdateType, 4> DeletedEdges;
    for (auto *Succ : RemovedSuccessors) {
      // It might have happened that the same successor appeared multiple times
      // and the CFG edge wasn't really removed.
      if (Succ != PreferredSucc->BB) {
        DEBUG(dbgs() << "ADCE: (Post)DomTree edge enqueued for deletion"
                     << BB->getName() << " -> " << Succ->getName() << "\n");
        DeletedEdges.push_back({DominatorTree::Delete, BB, Succ});
      }
    }

    DT.applyUpdates(DeletedEdges);
    PDT.applyUpdates(DeletedEdges);

    NumBranchesRemoved += 1;
  }
}

// reverse top-sort order
void AggressiveDeadCodeElimination::computeReversePostOrder() {
  // This provides a post-order numbering of the reverse control flow graph
  // Note that it is incomplete in the presence of infinite loops but we don't
  // need numbers blocks which don't reach the end of the functions since
  // all branches in those blocks are forced live.

  // For each block without successors, extend the DFS from the block
  // backward through the graph
  SmallPtrSet<BasicBlock*, 16> Visited;
  unsigned PostOrder = 0;
  for (auto &BB : F) {
    if (succ_begin(&BB) != succ_end(&BB))
      continue;
    for (BasicBlock *Block : inverse_post_order_ext(&BB,Visited))
      BlockInfo[Block].PostOrder = PostOrder++;
  }
}

void AggressiveDeadCodeElimination::makeUnconditional(BasicBlock *BB,
                                                      BasicBlock *Target) {
  TerminatorInst *PredTerm = BB->getTerminator();
  // Collect the live debug info scopes attached to this instruction.
  if (const DILocation *DL = PredTerm->getDebugLoc())
    collectLiveScopes(*DL);

  // Just mark live an existing unconditional branch
  if (isUnconditionalBranch(PredTerm)) {
    PredTerm->setSuccessor(0, Target);
    InstInfo[PredTerm].Live = true;
    return;
  }
  DEBUG(dbgs() << "making unconditional " << BB->getName() << '\n');
  NumBranchesRemoved += 1;
  IRBuilder<> Builder(PredTerm);
  auto *NewTerm = Builder.CreateBr(Target);
  InstInfo[NewTerm].Live = true;
  if (const DILocation *DL = PredTerm->getDebugLoc())
    NewTerm->setDebugLoc(DL);

  InstInfo.erase(PredTerm);
  PredTerm->eraseFromParent();
}

//===----------------------------------------------------------------------===//
//
// Pass Manager integration code
//
//===----------------------------------------------------------------------===//
PreservedAnalyses ADCEPass::run(Function &F, FunctionAnalysisManager &FAM) {
  auto &DT = FAM.getResult<DominatorTreeAnalysis>(F);
  auto &PDT = FAM.getResult<PostDominatorTreeAnalysis>(F);
  if (!AggressiveDeadCodeElimination(F, DT, PDT).performDeadCodeElimination())
    return PreservedAnalyses::all();

  PreservedAnalyses PA;
  PA.preserveSet<CFGAnalyses>();
  PA.preserve<GlobalsAA>();
  PA.preserve<DominatorTreeAnalysis>();
  PA.preserve<PostDominatorTreeAnalysis>();
  return PA;
}

namespace {

struct ADCELegacyPass : public FunctionPass {
  static char ID; // Pass identification, replacement for typeid

  ADCELegacyPass() : FunctionPass(ID) {
    initializeADCELegacyPassPass(*PassRegistry::getPassRegistry());
  }

  bool runOnFunction(Function &F) override {
    if (skipFunction(F))
      return false;

    auto &DT = getAnalysis<DominatorTreeWrapperPass>().getDomTree();
    auto &PDT = getAnalysis<PostDominatorTreeWrapperPass>().getPostDomTree();
    return AggressiveDeadCodeElimination(F, DT, PDT)
        .performDeadCodeElimination();
  }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    // We require DominatorTree here only to update and thus preserve it.
    AU.addRequired<DominatorTreeWrapperPass>();
    AU.addRequired<PostDominatorTreeWrapperPass>();
    if (!RemoveControlFlowFlag)
      AU.setPreservesCFG();
    else {
      AU.addPreserved<DominatorTreeWrapperPass>();
      AU.addPreserved<PostDominatorTreeWrapperPass>();
    }
    AU.addPreserved<GlobalsAAWrapperPass>();
  }
};

} // end anonymous namespace

char ADCELegacyPass::ID = 0;

INITIALIZE_PASS_BEGIN(ADCELegacyPass, "adce",
                      "Aggressive Dead Code Elimination", false, false)
INITIALIZE_PASS_DEPENDENCY(DominatorTreeWrapperPass)
INITIALIZE_PASS_DEPENDENCY(PostDominatorTreeWrapperPass)
INITIALIZE_PASS_END(ADCELegacyPass, "adce", "Aggressive Dead Code Elimination",
                    false, false)

FunctionPass *llvm::createAggressiveDCEPass() { return new ADCELegacyPass(); }
