//===- InductiveRangeCheckElimination.cpp - -------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// The InductiveRangeCheckElimination pass splits a loop's iteration space into
// three disjoint ranges.  It does that in a way such that the loop running in
// the middle loop provably does not need range checks. As an example, it will
// convert
//
//   len = < known positive >
//   for (i = 0; i < n; i++) {
//     if (0 <= i && i < len) {
//       do_something();
//     } else {
//       throw_out_of_bounds();
//     }
//   }
//
// to
//
//   len = < known positive >
//   limit = smin(n, len)
//   // no first segment
//   for (i = 0; i < limit; i++) {
//     if (0 <= i && i < len) { // this check is fully redundant
//       do_something();
//     } else {
//       throw_out_of_bounds();
//     }
//   }
//   for (i = limit; i < n; i++) {
//     if (0 <= i && i < len) {
//       do_something();
//     } else {
//       throw_out_of_bounds();
//     }
//   }
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/APInt.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/None.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Twine.h"
#include "llvm/Analysis/BranchProbabilityInfo.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpander.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PatternMatch.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Use.h"
#include "llvm/IR/User.h"
#include "llvm/IR/Value.h"
#include "llvm/Pass.h"
#include "llvm/Support/BranchProbability.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Transforms/Utils/LoopSimplify.h"
#include "llvm/Transforms/Utils/LoopUtils.h"
#include "llvm/Transforms/Utils/ValueMapper.h"
#include <algorithm>
#include <cassert>
#include <iterator>
#include <limits>
#include <utility>
#include <vector>

using namespace llvm;
using namespace llvm::PatternMatch;

static cl::opt<unsigned> LoopSizeCutoff("irce-loop-size-cutoff", cl::Hidden,
                                        cl::init(64));

static cl::opt<bool> PrintChangedLoops("irce-print-changed-loops", cl::Hidden,
                                       cl::init(false));

static cl::opt<bool> PrintRangeChecks("irce-print-range-checks", cl::Hidden,
                                      cl::init(false));

static cl::opt<int> MaxExitProbReciprocal("irce-max-exit-prob-reciprocal",
                                          cl::Hidden, cl::init(10));

static cl::opt<bool> SkipProfitabilityChecks("irce-skip-profitability-checks",
                                             cl::Hidden, cl::init(false));

static cl::opt<bool> AllowUnsignedLatchCondition("irce-allow-unsigned-latch",
                                                 cl::Hidden, cl::init(true));

static const char *ClonedLoopTag = "irce.loop.clone";

#define DEBUG_TYPE "irce"

namespace {

/// An inductive range check is conditional branch in a loop with
///
///  1. a very cold successor (i.e. the branch jumps to that successor very
///     rarely)
///
///  and
///
///  2. a condition that is provably true for some contiguous range of values
///     taken by the containing loop's induction variable.
///
class InductiveRangeCheck {
  // Classifies a range check
  enum RangeCheckKind : unsigned {
    // Range check of the form "0 <= I".
    RANGE_CHECK_LOWER = 1,

    // Range check of the form "I < L" where L is known positive.
    RANGE_CHECK_UPPER = 2,

    // The logical and of the RANGE_CHECK_LOWER and RANGE_CHECK_UPPER
    // conditions.
    RANGE_CHECK_BOTH = RANGE_CHECK_LOWER | RANGE_CHECK_UPPER,

    // Unrecognized range check condition.
    RANGE_CHECK_UNKNOWN = (unsigned)-1
  };

  static StringRef rangeCheckKindToStr(RangeCheckKind);

  const SCEV *Begin = nullptr;
  const SCEV *Step = nullptr;
  const SCEV *End = nullptr;
  Use *CheckUse = nullptr;
  RangeCheckKind Kind = RANGE_CHECK_UNKNOWN;
  bool IsSigned = true;

  static RangeCheckKind parseRangeCheckICmp(Loop *L, ICmpInst *ICI,
                                            ScalarEvolution &SE, Value *&Index,
                                            Value *&Length, bool &IsSigned);

  static void
  extractRangeChecksFromCond(Loop *L, ScalarEvolution &SE, Use &ConditionUse,
                             SmallVectorImpl<InductiveRangeCheck> &Checks,
                             SmallPtrSetImpl<Value *> &Visited);

public:
  const SCEV *getBegin() const { return Begin; }
  const SCEV *getStep() const { return Step; }
  const SCEV *getEnd() const { return End; }
  bool isSigned() const { return IsSigned; }

  void print(raw_ostream &OS) const {
    OS << "InductiveRangeCheck:\n";
    OS << "  Kind: " << rangeCheckKindToStr(Kind) << "\n";
    OS << "  Begin: ";
    Begin->print(OS);
    OS << "  Step: ";
    Step->print(OS);
    OS << "  End: ";
    End->print(OS);
    OS << "\n  CheckUse: ";
    getCheckUse()->getUser()->print(OS);
    OS << " Operand: " << getCheckUse()->getOperandNo() << "\n";
  }

  LLVM_DUMP_METHOD
  void dump() {
    print(dbgs());
  }

  Use *getCheckUse() const { return CheckUse; }

  /// Represents an signed integer range [Range.getBegin(), Range.getEnd()).  If
  /// R.getEnd() le R.getBegin(), then R denotes the empty range.

  class Range {
    const SCEV *Begin;
    const SCEV *End;

  public:
    Range(const SCEV *Begin, const SCEV *End) : Begin(Begin), End(End) {
      assert(Begin->getType() == End->getType() && "ill-typed range!");
    }

    Type *getType() const { return Begin->getType(); }
    const SCEV *getBegin() const { return Begin; }
    const SCEV *getEnd() const { return End; }
    bool isEmpty(ScalarEvolution &SE, bool IsSigned) const {
      if (Begin == End)
        return true;
      if (IsSigned)
        return SE.isKnownPredicate(ICmpInst::ICMP_SGE, Begin, End);
      else
        return SE.isKnownPredicate(ICmpInst::ICMP_UGE, Begin, End);
    }
  };

  /// This is the value the condition of the branch needs to evaluate to for the
  /// branch to take the hot successor (see (1) above).
  bool getPassingDirection() { return true; }

  /// Computes a range for the induction variable (IndVar) in which the range
  /// check is redundant and can be constant-folded away.  The induction
  /// variable is not required to be the canonical {0,+,1} induction variable.
  Optional<Range> computeSafeIterationSpace(ScalarEvolution &SE,
                                            const SCEVAddRecExpr *IndVar,
                                            bool IsLatchSigned) const;

  /// Parse out a set of inductive range checks from \p BI and append them to \p
  /// Checks.
  ///
  /// NB! There may be conditions feeding into \p BI that aren't inductive range
  /// checks, and hence don't end up in \p Checks.
  static void
  extractRangeChecksFromBranch(BranchInst *BI, Loop *L, ScalarEvolution &SE,
                               BranchProbabilityInfo &BPI,
                               SmallVectorImpl<InductiveRangeCheck> &Checks);
};

class InductiveRangeCheckElimination : public LoopPass {
public:
  static char ID;

  InductiveRangeCheckElimination() : LoopPass(ID) {
    initializeInductiveRangeCheckEliminationPass(
        *PassRegistry::getPassRegistry());
  }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<BranchProbabilityInfoWrapperPass>();
    getLoopAnalysisUsage(AU);
  }

  bool runOnLoop(Loop *L, LPPassManager &LPM) override;
};

} // end anonymous namespace

char InductiveRangeCheckElimination::ID = 0;

INITIALIZE_PASS_BEGIN(InductiveRangeCheckElimination, "irce",
                      "Inductive range check elimination", false, false)
INITIALIZE_PASS_DEPENDENCY(BranchProbabilityInfoWrapperPass)
INITIALIZE_PASS_DEPENDENCY(LoopPass)
INITIALIZE_PASS_END(InductiveRangeCheckElimination, "irce",
                    "Inductive range check elimination", false, false)

StringRef InductiveRangeCheck::rangeCheckKindToStr(
    InductiveRangeCheck::RangeCheckKind RCK) {
  switch (RCK) {
  case InductiveRangeCheck::RANGE_CHECK_UNKNOWN:
    return "RANGE_CHECK_UNKNOWN";

  case InductiveRangeCheck::RANGE_CHECK_UPPER:
    return "RANGE_CHECK_UPPER";

  case InductiveRangeCheck::RANGE_CHECK_LOWER:
    return "RANGE_CHECK_LOWER";

  case InductiveRangeCheck::RANGE_CHECK_BOTH:
    return "RANGE_CHECK_BOTH";
  }

  llvm_unreachable("unknown range check type!");
}

/// Parse a single ICmp instruction, `ICI`, into a range check.  If `ICI` cannot
/// be interpreted as a range check, return `RANGE_CHECK_UNKNOWN` and set
/// `Index` and `Length` to `nullptr`.  Otherwise set `Index` to the value being
/// range checked, and set `Length` to the upper limit `Index` is being range
/// checked with if (and only if) the range check type is stronger or equal to
/// RANGE_CHECK_UPPER.
InductiveRangeCheck::RangeCheckKind
InductiveRangeCheck::parseRangeCheckICmp(Loop *L, ICmpInst *ICI,
                                         ScalarEvolution &SE, Value *&Index,
                                         Value *&Length, bool &IsSigned) {
  auto IsNonNegativeAndNotLoopVarying = [&SE, L](Value *V) {
    const SCEV *S = SE.getSCEV(V);
    if (isa<SCEVCouldNotCompute>(S))
      return false;

    return SE.getLoopDisposition(S, L) == ScalarEvolution::LoopInvariant &&
           SE.isKnownNonNegative(S);
  };

  ICmpInst::Predicate Pred = ICI->getPredicate();
  Value *LHS = ICI->getOperand(0);
  Value *RHS = ICI->getOperand(1);

  switch (Pred) {
  default:
    return RANGE_CHECK_UNKNOWN;

  case ICmpInst::ICMP_SLE:
    std::swap(LHS, RHS);
    LLVM_FALLTHROUGH;
  case ICmpInst::ICMP_SGE:
    IsSigned = true;
    if (match(RHS, m_ConstantInt<0>())) {
      Index = LHS;
      return RANGE_CHECK_LOWER;
    }
    return RANGE_CHECK_UNKNOWN;

  case ICmpInst::ICMP_SLT:
    std::swap(LHS, RHS);
    LLVM_FALLTHROUGH;
  case ICmpInst::ICMP_SGT:
    IsSigned = true;
    if (match(RHS, m_ConstantInt<-1>())) {
      Index = LHS;
      return RANGE_CHECK_LOWER;
    }

    if (IsNonNegativeAndNotLoopVarying(LHS)) {
      Index = RHS;
      Length = LHS;
      return RANGE_CHECK_UPPER;
    }
    return RANGE_CHECK_UNKNOWN;

  case ICmpInst::ICMP_ULT:
    std::swap(LHS, RHS);
    LLVM_FALLTHROUGH;
  case ICmpInst::ICMP_UGT:
    IsSigned = false;
    if (IsNonNegativeAndNotLoopVarying(LHS)) {
      Index = RHS;
      Length = LHS;
      return RANGE_CHECK_BOTH;
    }
    return RANGE_CHECK_UNKNOWN;
  }

  llvm_unreachable("default clause returns!");
}

void InductiveRangeCheck::extractRangeChecksFromCond(
    Loop *L, ScalarEvolution &SE, Use &ConditionUse,
    SmallVectorImpl<InductiveRangeCheck> &Checks,
    SmallPtrSetImpl<Value *> &Visited) {
  Value *Condition = ConditionUse.get();
  if (!Visited.insert(Condition).second)
    return;

  // TODO: Do the same for OR, XOR, NOT etc?
  if (match(Condition, m_And(m_Value(), m_Value()))) {
    extractRangeChecksFromCond(L, SE, cast<User>(Condition)->getOperandUse(0),
                               Checks, Visited);
    extractRangeChecksFromCond(L, SE, cast<User>(Condition)->getOperandUse(1),
                               Checks, Visited);
    return;
  }

  ICmpInst *ICI = dyn_cast<ICmpInst>(Condition);
  if (!ICI)
    return;

  Value *Length = nullptr, *Index;
  bool IsSigned;
  auto RCKind = parseRangeCheckICmp(L, ICI, SE, Index, Length, IsSigned);
  if (RCKind == InductiveRangeCheck::RANGE_CHECK_UNKNOWN)
    return;

  const auto *IndexAddRec = dyn_cast<SCEVAddRecExpr>(SE.getSCEV(Index));
  bool IsAffineIndex =
      IndexAddRec && (IndexAddRec->getLoop() == L) && IndexAddRec->isAffine();

  if (!IsAffineIndex)
    return;

  const SCEV *End = nullptr;
  // We strengthen "0 <= I" to "0 <= I < INT_SMAX" and "I < L" to "0 <= I < L".
  // We can potentially do much better here.
  if (Length)
    End = SE.getSCEV(Length);
  else {
    assert(RCKind == InductiveRangeCheck::RANGE_CHECK_LOWER && "invariant!");
    // So far we can only reach this point for Signed range check. This may
    // change in future. In this case we will need to pick Unsigned max for the
    // unsigned range check.
    unsigned BitWidth = cast<IntegerType>(IndexAddRec->getType())->getBitWidth();
    const SCEV *SIntMax = SE.getConstant(APInt::getSignedMaxValue(BitWidth));
    End = SIntMax;
  }

  InductiveRangeCheck IRC;
  IRC.End = End;
  IRC.Begin = IndexAddRec->getStart();
  IRC.Step = IndexAddRec->getStepRecurrence(SE);
  IRC.CheckUse = &ConditionUse;
  IRC.Kind = RCKind;
  IRC.IsSigned = IsSigned;
  Checks.push_back(IRC);
}

void InductiveRangeCheck::extractRangeChecksFromBranch(
    BranchInst *BI, Loop *L, ScalarEvolution &SE, BranchProbabilityInfo &BPI,
    SmallVectorImpl<InductiveRangeCheck> &Checks) {
  if (BI->isUnconditional() || BI->getParent() == L->getLoopLatch())
    return;

  BranchProbability LikelyTaken(15, 16);

  if (!SkipProfitabilityChecks &&
      BPI.getEdgeProbability(BI->getParent(), (unsigned)0) < LikelyTaken)
    return;

  SmallPtrSet<Value *, 8> Visited;
  InductiveRangeCheck::extractRangeChecksFromCond(L, SE, BI->getOperandUse(0),
                                                  Checks, Visited);
}

// Add metadata to the loop L to disable loop optimizations. Callers need to
// confirm that optimizing loop L is not beneficial.
static void DisableAllLoopOptsOnLoop(Loop &L) {
  // We do not care about any existing loopID related metadata for L, since we
  // are setting all loop metadata to false.
  LLVMContext &Context = L.getHeader()->getContext();
  // Reserve first location for self reference to the LoopID metadata node.
  MDNode *Dummy = MDNode::get(Context, {});
  MDNode *DisableUnroll = MDNode::get(
      Context, {MDString::get(Context, "llvm.loop.unroll.disable"), MDString::get(Context, "infer-from-design")});
  Metadata *FalseVal =
      ConstantAsMetadata::get(ConstantInt::get(Type::getInt1Ty(Context), 0));
  MDNode *DisableVectorize = MDNode::get(
      Context,
      {MDString::get(Context, "llvm.loop.vectorize.enable"), FalseVal});
  MDNode *DisableLICMVersioning = MDNode::get(
      Context, {MDString::get(Context, "llvm.loop.licm_versioning.disable")});
  MDNode *DisableDistribution= MDNode::get(
      Context,
      {MDString::get(Context, "llvm.loop.distribute.enable"), FalseVal});
  MDNode *NewLoopID =
      MDNode::get(Context, {Dummy, DisableUnroll, DisableVectorize,
                            DisableLICMVersioning, DisableDistribution});
  // Set operand 0 to refer to the loop id itself.
  NewLoopID->replaceOperandWith(0, NewLoopID);
  L.setLoopID(NewLoopID);
}

namespace {

// Keeps track of the structure of a loop.  This is similar to llvm::Loop,
// except that it is more lightweight and can track the state of a loop through
// changing and potentially invalid IR.  This structure also formalizes the
// kinds of loops we can deal with -- ones that have a single latch that is also
// an exiting block *and* have a canonical induction variable.
struct LoopStructure {
  const char *Tag = "";

  BasicBlock *Header = nullptr;
  BasicBlock *Latch = nullptr;

  // `Latch's terminator instruction is `LatchBr', and it's `LatchBrExitIdx'th
  // successor is `LatchExit', the exit block of the loop.
  BranchInst *LatchBr = nullptr;
  BasicBlock *LatchExit = nullptr;
  unsigned LatchBrExitIdx = std::numeric_limits<unsigned>::max();

  // The loop represented by this instance of LoopStructure is semantically
  // equivalent to:
  //
  // intN_ty inc = IndVarIncreasing ? 1 : -1;
  // pred_ty predicate = IndVarIncreasing ? ICMP_SLT : ICMP_SGT;
  //
  // for (intN_ty iv = IndVarStart; predicate(iv, LoopExitAt); iv = IndVarBase)
  //   ... body ...

  Value *IndVarBase = nullptr;
  Value *IndVarStart = nullptr;
  Value *IndVarStep = nullptr;
  Value *LoopExitAt = nullptr;
  bool IndVarIncreasing = false;
  bool IsSignedPredicate = true;

  LoopStructure() = default;

  template <typename M> LoopStructure map(M Map) const {
    LoopStructure Result;
    Result.Tag = Tag;
    Result.Header = cast<BasicBlock>(Map(Header));
    Result.Latch = cast<BasicBlock>(Map(Latch));
    Result.LatchBr = cast<BranchInst>(Map(LatchBr));
    Result.LatchExit = cast<BasicBlock>(Map(LatchExit));
    Result.LatchBrExitIdx = LatchBrExitIdx;
    Result.IndVarBase = Map(IndVarBase);
    Result.IndVarStart = Map(IndVarStart);
    Result.IndVarStep = Map(IndVarStep);
    Result.LoopExitAt = Map(LoopExitAt);
    Result.IndVarIncreasing = IndVarIncreasing;
    Result.IsSignedPredicate = IsSignedPredicate;
    return Result;
  }

  static Optional<LoopStructure> parseLoopStructure(ScalarEvolution &,
                                                    BranchProbabilityInfo &BPI,
                                                    Loop &,
                                                    const char *&);
};

/// This class is used to constrain loops to run within a given iteration space.
/// The algorithm this class implements is given a Loop and a range [Begin,
/// End).  The algorithm then tries to break out a "main loop" out of the loop
/// it is given in a way that the "main loop" runs with the induction variable
/// in a subset of [Begin, End).  The algorithm emits appropriate pre and post
/// loops to run any remaining iterations.  The pre loop runs any iterations in
/// which the induction variable is < Begin, and the post loop runs any
/// iterations in which the induction variable is >= End.
class LoopConstrainer {
  // The representation of a clone of the original loop we started out with.
  struct ClonedLoop {
    // The cloned blocks
    std::vector<BasicBlock *> Blocks;

    // `Map` maps values in the clonee into values in the cloned version
    ValueToValueMapTy Map;

    // An instance of `LoopStructure` for the cloned loop
    LoopStructure Structure;
  };

  // Result of rewriting the range of a loop.  See changeIterationSpaceEnd for
  // more details on what these fields mean.
  struct RewrittenRangeInfo {
    BasicBlock *PseudoExit = nullptr;
    BasicBlock *ExitSelector = nullptr;
    std::vector<PHINode *> PHIValuesAtPseudoExit;
    PHINode *IndVarEnd = nullptr;

    RewrittenRangeInfo() = default;
  };

  // Calculated subranges we restrict the iteration space of the main loop to.
  // See the implementation of `calculateSubRanges' for more details on how
  // these fields are computed.  `LowLimit` is None if there is no restriction
  // on low end of the restricted iteration space of the main loop.  `HighLimit`
  // is None if there is no restriction on high end of the restricted iteration
  // space of the main loop.

  struct SubRanges {
    Optional<const SCEV *> LowLimit;
    Optional<const SCEV *> HighLimit;
  };

  // A utility function that does a `replaceUsesOfWith' on the incoming block
  // set of a `PHINode' -- replaces instances of `Block' in the `PHINode's
  // incoming block list with `ReplaceBy'.
  static void replacePHIBlock(PHINode *PN, BasicBlock *Block,
                              BasicBlock *ReplaceBy);

  // Compute a safe set of limits for the main loop to run in -- effectively the
  // intersection of `Range' and the iteration space of the original loop.
  // Return None if unable to compute the set of subranges.
  Optional<SubRanges> calculateSubRanges(bool IsSignedPredicate) const;

  // Clone `OriginalLoop' and return the result in CLResult.  The IR after
  // running `cloneLoop' is well formed except for the PHI nodes in CLResult --
  // the PHI nodes say that there is an incoming edge from `OriginalPreheader`
  // but there is no such edge.
  void cloneLoop(ClonedLoop &CLResult, const char *Tag) const;

  // Create the appropriate loop structure needed to describe a cloned copy of
  // `Original`.  The clone is described by `VM`.
  Loop *createClonedLoopStructure(Loop *Original, Loop *Parent,
                                  ValueToValueMapTy &VM);

  // Rewrite the iteration space of the loop denoted by (LS, Preheader). The
  // iteration space of the rewritten loop ends at ExitLoopAt.  The start of the
  // iteration space is not changed.  `ExitLoopAt' is assumed to be slt
  // `OriginalHeaderCount'.
  //
  // If there are iterations left to execute, control is made to jump to
  // `ContinuationBlock', otherwise they take the normal loop exit.  The
  // returned `RewrittenRangeInfo' object is populated as follows:
  //
  //  .PseudoExit is a basic block that unconditionally branches to
  //      `ContinuationBlock'.
  //
  //  .ExitSelector is a basic block that decides, on exit from the loop,
  //      whether to branch to the "true" exit or to `PseudoExit'.
  //
  //  .PHIValuesAtPseudoExit are PHINodes in `PseudoExit' that compute the value
  //      for each PHINode in the loop header on taking the pseudo exit.
  //
  // After changeIterationSpaceEnd, `Preheader' is no longer a legitimate
  // preheader because it is made to branch to the loop header only
  // conditionally.
  RewrittenRangeInfo
  changeIterationSpaceEnd(const LoopStructure &LS, BasicBlock *Preheader,
                          Value *ExitLoopAt,
                          BasicBlock *ContinuationBlock) const;

  // The loop denoted by `LS' has `OldPreheader' as its preheader.  This
  // function creates a new preheader for `LS' and returns it.
  BasicBlock *createPreheader(const LoopStructure &LS, BasicBlock *OldPreheader,
                              const char *Tag) const;

  // `ContinuationBlockAndPreheader' was the continuation block for some call to
  // `changeIterationSpaceEnd' and is the preheader to the loop denoted by `LS'.
  // This function rewrites the PHI nodes in `LS.Header' to start with the
  // correct value.
  void rewriteIncomingValuesForPHIs(
      LoopStructure &LS, BasicBlock *ContinuationBlockAndPreheader,
      const LoopConstrainer::RewrittenRangeInfo &RRI) const;

  // Even though we do not preserve any passes at this time, we at least need to
  // keep the parent loop structure consistent.  The `LPPassManager' seems to
  // verify this after running a loop pass.  This function adds the list of
  // blocks denoted by BBs to this loops parent loop if required.
  void addToParentLoopIfNeeded(ArrayRef<BasicBlock *> BBs);

  // Some global state.
  Function &F;
  LLVMContext &Ctx;
  ScalarEvolution &SE;
  DominatorTree &DT;
  LPPassManager &LPM;
  LoopInfo &LI;

  // Information about the original loop we started out with.
  Loop &OriginalLoop;

  const SCEV *LatchTakenCount = nullptr;
  BasicBlock *OriginalPreheader = nullptr;

  // The preheader of the main loop.  This may or may not be different from
  // `OriginalPreheader'.
  BasicBlock *MainLoopPreheader = nullptr;

  // The range we need to run the main loop in.
  InductiveRangeCheck::Range Range;

  // The structure of the main loop (see comment at the beginning of this class
  // for a definition)
  LoopStructure MainLoopStructure;

public:
  LoopConstrainer(Loop &L, LoopInfo &LI, LPPassManager &LPM,
                  const LoopStructure &LS, ScalarEvolution &SE,
                  DominatorTree &DT, InductiveRangeCheck::Range R)
      : F(*L.getHeader()->getParent()), Ctx(L.getHeader()->getContext()),
        SE(SE), DT(DT), LPM(LPM), LI(LI), OriginalLoop(L), Range(R),
        MainLoopStructure(LS) {}

  // Entry point for the algorithm.  Returns true on success.
  bool run();
};

} // end anonymous namespace

void LoopConstrainer::replacePHIBlock(PHINode *PN, BasicBlock *Block,
                                      BasicBlock *ReplaceBy) {
  for (unsigned i = 0, e = PN->getNumIncomingValues(); i != e; ++i)
    if (PN->getIncomingBlock(i) == Block)
      PN->setIncomingBlock(i, ReplaceBy);
}

static bool CanBeMax(ScalarEvolution &SE, const SCEV *S, bool Signed) {
  APInt Max = Signed ?
      APInt::getSignedMaxValue(cast<IntegerType>(S->getType())->getBitWidth()) :
      APInt::getMaxValue(cast<IntegerType>(S->getType())->getBitWidth());
  return SE.getSignedRange(S).contains(Max) &&
         SE.getUnsignedRange(S).contains(Max);
}

static bool SumCanReachMax(ScalarEvolution &SE, const SCEV *S1, const SCEV *S2,
                           bool Signed) {
  // S1 < INT_MAX - S2 ===> S1 + S2 < INT_MAX.
  assert(SE.isKnownNonNegative(S2) &&
         "We expected the 2nd arg to be non-negative!");
  const SCEV *Max = SE.getConstant(
      Signed ? APInt::getSignedMaxValue(
                   cast<IntegerType>(S1->getType())->getBitWidth())
             : APInt::getMaxValue(
                   cast<IntegerType>(S1->getType())->getBitWidth()));
  const SCEV *CapForS1 = SE.getMinusSCEV(Max, S2);
  return !SE.isKnownPredicate(Signed ? ICmpInst::ICMP_SLT : ICmpInst::ICMP_ULT,
                              S1, CapForS1);
}

static bool CanBeMin(ScalarEvolution &SE, const SCEV *S, bool Signed) {
  APInt Min = Signed ?
      APInt::getSignedMinValue(cast<IntegerType>(S->getType())->getBitWidth()) :
      APInt::getMinValue(cast<IntegerType>(S->getType())->getBitWidth());
  return SE.getSignedRange(S).contains(Min) &&
         SE.getUnsignedRange(S).contains(Min);
}

static bool SumCanReachMin(ScalarEvolution &SE, const SCEV *S1, const SCEV *S2,
                           bool Signed) {
  // S1 > INT_MIN - S2 ===> S1 + S2 > INT_MIN.
  assert(SE.isKnownNonPositive(S2) &&
         "We expected the 2nd arg to be non-positive!");
  const SCEV *Max = SE.getConstant(
      Signed ? APInt::getSignedMinValue(
                   cast<IntegerType>(S1->getType())->getBitWidth())
             : APInt::getMinValue(
                   cast<IntegerType>(S1->getType())->getBitWidth()));
  const SCEV *CapForS1 = SE.getMinusSCEV(Max, S2);
  return !SE.isKnownPredicate(Signed ? ICmpInst::ICMP_SGT : ICmpInst::ICMP_UGT,
                              S1, CapForS1);
}

Optional<LoopStructure>
LoopStructure::parseLoopStructure(ScalarEvolution &SE,
                                  BranchProbabilityInfo &BPI,
                                  Loop &L, const char *&FailureReason) {
  if (!L.isLoopSimplifyForm()) {
    FailureReason = "loop not in LoopSimplify form";
    return None;
  }

  BasicBlock *Latch = L.getLoopLatch();
  assert(Latch && "Simplified loops only have one latch!");

  if (Latch->getTerminator()->getMetadata(ClonedLoopTag)) {
    FailureReason = "loop has already been cloned";
    return None;
  }

  if (!L.isLoopExiting(Latch)) {
    FailureReason = "no loop latch";
    return None;
  }

  BasicBlock *Header = L.getHeader();
  BasicBlock *Preheader = L.getLoopPreheader();
  if (!Preheader) {
    FailureReason = "no preheader";
    return None;
  }

  BranchInst *LatchBr = dyn_cast<BranchInst>(Latch->getTerminator());
  if (!LatchBr || LatchBr->isUnconditional()) {
    FailureReason = "latch terminator not conditional branch";
    return None;
  }

  unsigned LatchBrExitIdx = LatchBr->getSuccessor(0) == Header ? 1 : 0;

  BranchProbability ExitProbability =
    BPI.getEdgeProbability(LatchBr->getParent(), LatchBrExitIdx);

  if (!SkipProfitabilityChecks &&
      ExitProbability > BranchProbability(1, MaxExitProbReciprocal)) {
    FailureReason = "short running loop, not profitable";
    return None;
  }

  ICmpInst *ICI = dyn_cast<ICmpInst>(LatchBr->getCondition());
  if (!ICI || !isa<IntegerType>(ICI->getOperand(0)->getType())) {
    FailureReason = "latch terminator branch not conditional on integral icmp";
    return None;
  }

  const SCEV *LatchCount = SE.getExitCount(&L, Latch);
  if (isa<SCEVCouldNotCompute>(LatchCount)) {
    FailureReason = "could not compute latch count";
    return None;
  }

  ICmpInst::Predicate Pred = ICI->getPredicate();
  Value *LeftValue = ICI->getOperand(0);
  const SCEV *LeftSCEV = SE.getSCEV(LeftValue);
  IntegerType *IndVarTy = cast<IntegerType>(LeftValue->getType());

  Value *RightValue = ICI->getOperand(1);
  const SCEV *RightSCEV = SE.getSCEV(RightValue);

  // We canonicalize `ICI` such that `LeftSCEV` is an add recurrence.
  if (!isa<SCEVAddRecExpr>(LeftSCEV)) {
    if (isa<SCEVAddRecExpr>(RightSCEV)) {
      std::swap(LeftSCEV, RightSCEV);
      std::swap(LeftValue, RightValue);
      Pred = ICmpInst::getSwappedPredicate(Pred);
    } else {
      FailureReason = "no add recurrences in the icmp";
      return None;
    }
  }

  auto HasNoSignedWrap = [&](const SCEVAddRecExpr *AR) {
    if (AR->getNoWrapFlags(SCEV::FlagNSW))
      return true;

    IntegerType *Ty = cast<IntegerType>(AR->getType());
    IntegerType *WideTy =
        IntegerType::get(Ty->getContext(), Ty->getBitWidth() * 2);

    const SCEVAddRecExpr *ExtendAfterOp =
        dyn_cast<SCEVAddRecExpr>(SE.getSignExtendExpr(AR, WideTy));
    if (ExtendAfterOp) {
      const SCEV *ExtendedStart = SE.getSignExtendExpr(AR->getStart(), WideTy);
      const SCEV *ExtendedStep =
          SE.getSignExtendExpr(AR->getStepRecurrence(SE), WideTy);

      bool NoSignedWrap = ExtendAfterOp->getStart() == ExtendedStart &&
                          ExtendAfterOp->getStepRecurrence(SE) == ExtendedStep;

      if (NoSignedWrap)
        return true;
    }

    // We may have proved this when computing the sign extension above.
    return AR->getNoWrapFlags(SCEV::FlagNSW) != SCEV::FlagAnyWrap;
  };

  // Here we check whether the suggested AddRec is an induction variable that
  // can be handled (i.e. with known constant step), and if yes, calculate its
  // step and identify whether it is increasing or decreasing.
  auto IsInductionVar = [&](const SCEVAddRecExpr *AR, bool &IsIncreasing,
                            ConstantInt *&StepCI) {
    if (!AR->isAffine())
      return false;

    // Currently we only work with induction variables that have been proved to
    // not wrap.  This restriction can potentially be lifted in the future.

    if (!HasNoSignedWrap(AR))
      return false;

    if (const SCEVConstant *StepExpr =
            dyn_cast<SCEVConstant>(AR->getStepRecurrence(SE))) {
      StepCI = StepExpr->getValue();
      assert(!StepCI->isZero() && "Zero step?");
      IsIncreasing = !StepCI->isNegative();
      return true;
    }

    return false;
  };

  // `ICI` is interpreted as taking the backedge if the *next* value of the
  // induction variable satisfies some constraint.

  const SCEVAddRecExpr *IndVarBase = cast<SCEVAddRecExpr>(LeftSCEV);
  bool IsIncreasing = false;
  bool IsSignedPredicate = true;
  ConstantInt *StepCI;
  if (!IsInductionVar(IndVarBase, IsIncreasing, StepCI)) {
    FailureReason = "LHS in icmp not induction variable";
    return None;
  }

  const SCEV *StartNext = IndVarBase->getStart();
  const SCEV *Addend = SE.getNegativeSCEV(IndVarBase->getStepRecurrence(SE));
  const SCEV *IndVarStart = SE.getAddExpr(StartNext, Addend);
  const SCEV *Step = SE.getSCEV(StepCI);

  ConstantInt *One = ConstantInt::get(IndVarTy, 1);
  if (IsIncreasing) {
    bool DecreasedRightValueByOne = false;
    if (StepCI->isOne()) {
      // Try to turn eq/ne predicates to those we can work with.
      if (Pred == ICmpInst::ICMP_NE && LatchBrExitIdx == 1)
        // while (++i != len) {         while (++i < len) {
        //   ...                 --->     ...
        // }                            }
        // If both parts are known non-negative, it is profitable to use
        // unsigned comparison in increasing loop. This allows us to make the
        // comparison check against "RightSCEV + 1" more optimistic.
        if (SE.isKnownNonNegative(IndVarStart) &&
            SE.isKnownNonNegative(RightSCEV))
          Pred = ICmpInst::ICMP_ULT;
        else
          Pred = ICmpInst::ICMP_SLT;
      else if (Pred == ICmpInst::ICMP_EQ && LatchBrExitIdx == 0 &&
               !CanBeMin(SE, RightSCEV, /* IsSignedPredicate */ true)) {
        // while (true) {               while (true) {
        //   if (++i == len)     --->     if (++i > len - 1)
        //     break;                       break;
        //   ...                          ...
        // }                            }
        // TODO: Insert ICMP_UGT if both are non-negative?
        Pred = ICmpInst::ICMP_SGT;
        RightSCEV = SE.getMinusSCEV(RightSCEV, SE.getOne(RightSCEV->getType()));
        DecreasedRightValueByOne = true;
      }
    }

    bool LTPred = (Pred == ICmpInst::ICMP_SLT || Pred == ICmpInst::ICMP_ULT);
    bool GTPred = (Pred == ICmpInst::ICMP_SGT || Pred == ICmpInst::ICMP_UGT);
    bool FoundExpectedPred =
        (LTPred && LatchBrExitIdx == 1) || (GTPred && LatchBrExitIdx == 0);

    if (!FoundExpectedPred) {
      FailureReason = "expected icmp slt semantically, found something else";
      return None;
    }

    IsSignedPredicate =
        Pred == ICmpInst::ICMP_SLT || Pred == ICmpInst::ICMP_SGT;

    if (!IsSignedPredicate && !AllowUnsignedLatchCondition) {
      FailureReason = "unsigned latch conditions are explicitly prohibited";
      return None;
    }

    // The predicate that we need to check that the induction variable lies
    // within bounds.
    ICmpInst::Predicate BoundPred =
        IsSignedPredicate ? CmpInst::ICMP_SLT : CmpInst::ICMP_ULT;

    if (LatchBrExitIdx == 0) {
      const SCEV *StepMinusOne = SE.getMinusSCEV(Step,
                                                 SE.getOne(Step->getType()));
      if (SumCanReachMax(SE, RightSCEV, StepMinusOne, IsSignedPredicate)) {
        // TODO: this restriction is easily removable -- we just have to
        // remember that the icmp was an slt and not an sle.
        FailureReason = "limit may overflow when coercing le to lt";
        return None;
      }

      if (!SE.isLoopEntryGuardedByCond(
              &L, BoundPred, IndVarStart,
              SE.getAddExpr(RightSCEV, Step))) {
        FailureReason = "Induction variable start not bounded by upper limit";
        return None;
      }

      // We need to increase the right value unless we have already decreased
      // it virtually when we replaced EQ with SGT.
      if (!DecreasedRightValueByOne) {
        IRBuilder<> B(Preheader->getTerminator());
        RightValue = B.CreateAdd(RightValue, One);
      }
    } else {
      if (!SE.isLoopEntryGuardedByCond(&L, BoundPred, IndVarStart, RightSCEV)) {
        FailureReason = "Induction variable start not bounded by upper limit";
        return None;
      }
      assert(!DecreasedRightValueByOne &&
             "Right value can be decreased only for LatchBrExitIdx == 0!");
    }
  } else {
    bool IncreasedRightValueByOne = false;
    if (StepCI->isMinusOne()) {
      // Try to turn eq/ne predicates to those we can work with.
      if (Pred == ICmpInst::ICMP_NE && LatchBrExitIdx == 1)
        // while (--i != len) {         while (--i > len) {
        //   ...                 --->     ...
        // }                            }
        // We intentionally don't turn the predicate into UGT even if we know
        // that both operands are non-negative, because it will only pessimize
        // our check against "RightSCEV - 1".
        Pred = ICmpInst::ICMP_SGT;
      else if (Pred == ICmpInst::ICMP_EQ && LatchBrExitIdx == 0 &&
               !CanBeMax(SE, RightSCEV, /* IsSignedPredicate */ true)) {
        // while (true) {               while (true) {
        //   if (--i == len)     --->     if (--i < len + 1)
        //     break;                       break;
        //   ...                          ...
        // }                            }
        // TODO: Insert ICMP_ULT if both are non-negative?
        Pred = ICmpInst::ICMP_SLT;
        RightSCEV = SE.getAddExpr(RightSCEV, SE.getOne(RightSCEV->getType()));
        IncreasedRightValueByOne = true;
      }
    }

    bool LTPred = (Pred == ICmpInst::ICMP_SLT || Pred == ICmpInst::ICMP_ULT);
    bool GTPred = (Pred == ICmpInst::ICMP_SGT || Pred == ICmpInst::ICMP_UGT);

    bool FoundExpectedPred =
        (GTPred && LatchBrExitIdx == 1) || (LTPred && LatchBrExitIdx == 0);

    if (!FoundExpectedPred) {
      FailureReason = "expected icmp sgt semantically, found something else";
      return None;
    }

    IsSignedPredicate =
        Pred == ICmpInst::ICMP_SLT || Pred == ICmpInst::ICMP_SGT;

    if (!IsSignedPredicate && !AllowUnsignedLatchCondition) {
      FailureReason = "unsigned latch conditions are explicitly prohibited";
      return None;
    }

    // The predicate that we need to check that the induction variable lies
    // within bounds.
    ICmpInst::Predicate BoundPred =
        IsSignedPredicate ? CmpInst::ICMP_SGT : CmpInst::ICMP_UGT;

    if (LatchBrExitIdx == 0) {
      const SCEV *StepPlusOne = SE.getAddExpr(Step, SE.getOne(Step->getType()));
      if (SumCanReachMin(SE, RightSCEV, StepPlusOne, IsSignedPredicate)) {
        // TODO: this restriction is easily removable -- we just have to
        // remember that the icmp was an sgt and not an sge.
        FailureReason = "limit may overflow when coercing ge to gt";
        return None;
      }

      if (!SE.isLoopEntryGuardedByCond(
              &L, BoundPred, IndVarStart,
              SE.getMinusSCEV(RightSCEV, SE.getOne(RightSCEV->getType())))) {
        FailureReason = "Induction variable start not bounded by lower limit";
        return None;
      }

      // We need to decrease the right value unless we have already increased
      // it virtually when we replaced EQ with SLT.
      if (!IncreasedRightValueByOne) {
        IRBuilder<> B(Preheader->getTerminator());
        RightValue = B.CreateSub(RightValue, One);
      }
    } else {
      if (!SE.isLoopEntryGuardedByCond(&L, BoundPred, IndVarStart, RightSCEV)) {
        FailureReason = "Induction variable start not bounded by lower limit";
        return None;
      }
      assert(!IncreasedRightValueByOne &&
             "Right value can be increased only for LatchBrExitIdx == 0!");
    }
  }
  BasicBlock *LatchExit = LatchBr->getSuccessor(LatchBrExitIdx);

  assert(SE.getLoopDisposition(LatchCount, &L) ==
             ScalarEvolution::LoopInvariant &&
         "loop variant exit count doesn't make sense!");

  assert(!L.contains(LatchExit) && "expected an exit block!");
  const DataLayout &DL = Preheader->getModule()->getDataLayout();
  Value *IndVarStartV =
      SCEVExpander(SE, DL, "irce")
          .expandCodeFor(IndVarStart, IndVarTy, Preheader->getTerminator());
  IndVarStartV->setName("indvar.start");

  LoopStructure Result;

  Result.Tag = "main";
  Result.Header = Header;
  Result.Latch = Latch;
  Result.LatchBr = LatchBr;
  Result.LatchExit = LatchExit;
  Result.LatchBrExitIdx = LatchBrExitIdx;
  Result.IndVarStart = IndVarStartV;
  Result.IndVarStep = StepCI;
  Result.IndVarBase = LeftValue;
  Result.IndVarIncreasing = IsIncreasing;
  Result.LoopExitAt = RightValue;
  Result.IsSignedPredicate = IsSignedPredicate;

  FailureReason = nullptr;

  return Result;
}

Optional<LoopConstrainer::SubRanges>
LoopConstrainer::calculateSubRanges(bool IsSignedPredicate) const {
  IntegerType *Ty = cast<IntegerType>(LatchTakenCount->getType());

  if (Range.getType() != Ty)
    return None;

  LoopConstrainer::SubRanges Result;

  // I think we can be more aggressive here and make this nuw / nsw if the
  // addition that feeds into the icmp for the latch's terminating branch is nuw
  // / nsw.  In any case, a wrapping 2's complement addition is safe.
  const SCEV *Start = SE.getSCEV(MainLoopStructure.IndVarStart);
  const SCEV *End = SE.getSCEV(MainLoopStructure.LoopExitAt);

  bool Increasing = MainLoopStructure.IndVarIncreasing;

  // We compute `Smallest` and `Greatest` such that [Smallest, Greatest), or
  // [Smallest, GreatestSeen] is the range of values the induction variable
  // takes.

  const SCEV *Smallest = nullptr, *Greatest = nullptr, *GreatestSeen = nullptr;

  const SCEV *One = SE.getOne(Ty);
  if (Increasing) {
    Smallest = Start;
    Greatest = End;
    // No overflow, because the range [Smallest, GreatestSeen] is not empty.
    GreatestSeen = SE.getMinusSCEV(End, One);
  } else {
    // These two computations may sign-overflow.  Here is why that is okay:
    //
    // We know that the induction variable does not sign-overflow on any
    // iteration except the last one, and it starts at `Start` and ends at
    // `End`, decrementing by one every time.
    //
    //  * if `Smallest` sign-overflows we know `End` is `INT_SMAX`. Since the
    //    induction variable is decreasing we know that that the smallest value
    //    the loop body is actually executed with is `INT_SMIN` == `Smallest`.
    //
    //  * if `Greatest` sign-overflows, we know it can only be `INT_SMIN`.  In
    //    that case, `Clamp` will always return `Smallest` and
    //    [`Result.LowLimit`, `Result.HighLimit`) = [`Smallest`, `Smallest`)
    //    will be an empty range.  Returning an empty range is always safe.

    Smallest = SE.getAddExpr(End, One);
    Greatest = SE.getAddExpr(Start, One);
    GreatestSeen = Start;
  }

  auto Clamp = [this, Smallest, Greatest, IsSignedPredicate](const SCEV *S) {
    return IsSignedPredicate
               ? SE.getSMaxExpr(Smallest, SE.getSMinExpr(Greatest, S))
               : SE.getUMaxExpr(Smallest, SE.getUMinExpr(Greatest, S));
  };

  // In some cases we can prove that we don't need a pre or post loop.
  ICmpInst::Predicate PredLE =
      IsSignedPredicate ? ICmpInst::ICMP_SLE : ICmpInst::ICMP_ULE;
  ICmpInst::Predicate PredLT =
      IsSignedPredicate ? ICmpInst::ICMP_SLT : ICmpInst::ICMP_ULT;

  bool ProvablyNoPreloop =
      SE.isKnownPredicate(PredLE, Range.getBegin(), Smallest);
  if (!ProvablyNoPreloop)
    Result.LowLimit = Clamp(Range.getBegin());

  bool ProvablyNoPostLoop =
      SE.isKnownPredicate(PredLT, GreatestSeen, Range.getEnd());
  if (!ProvablyNoPostLoop)
    Result.HighLimit = Clamp(Range.getEnd());

  return Result;
}

void LoopConstrainer::cloneLoop(LoopConstrainer::ClonedLoop &Result,
                                const char *Tag) const {
  for (BasicBlock *BB : OriginalLoop.getBlocks()) {
    BasicBlock *Clone = CloneBasicBlock(BB, Result.Map, Twine(".") + Tag, &F);
    Result.Blocks.push_back(Clone);
    Result.Map[BB] = Clone;
  }

  auto GetClonedValue = [&Result](Value *V) {
    assert(V && "null values not in domain!");
    auto It = Result.Map.find(V);
    if (It == Result.Map.end())
      return V;
    return static_cast<Value *>(It->second);
  };

  auto *ClonedLatch =
      cast<BasicBlock>(GetClonedValue(OriginalLoop.getLoopLatch()));
  ClonedLatch->getTerminator()->setMetadata(ClonedLoopTag,
                                            MDNode::get(Ctx, {}));

  Result.Structure = MainLoopStructure.map(GetClonedValue);
  Result.Structure.Tag = Tag;

  for (unsigned i = 0, e = Result.Blocks.size(); i != e; ++i) {
    BasicBlock *ClonedBB = Result.Blocks[i];
    BasicBlock *OriginalBB = OriginalLoop.getBlocks()[i];

    assert(Result.Map[OriginalBB] == ClonedBB && "invariant!");

    for (Instruction &I : *ClonedBB)
      RemapInstruction(&I, Result.Map,
                       RF_NoModuleLevelChanges | RF_IgnoreMissingLocals);

    // Exit blocks will now have one more predecessor and their PHI nodes need
    // to be edited to reflect that.  No phi nodes need to be introduced because
    // the loop is in LCSSA.

    for (auto *SBB : successors(OriginalBB)) {
      if (OriginalLoop.contains(SBB))
        continue; // not an exit block

      for (PHINode &PN : SBB->phis()) {
        Value *OldIncoming = PN.getIncomingValueForBlock(OriginalBB);
        PN.addIncoming(GetClonedValue(OldIncoming), ClonedBB);
      }
    }
  }
}

LoopConstrainer::RewrittenRangeInfo LoopConstrainer::changeIterationSpaceEnd(
    const LoopStructure &LS, BasicBlock *Preheader, Value *ExitSubloopAt,
    BasicBlock *ContinuationBlock) const {
  // We start with a loop with a single latch:
  //
  //    +--------------------+
  //    |                    |
  //    |     preheader      |
  //    |                    |
  //    +--------+-----------+
  //             |      ----------------\
  //             |     /                |
  //    +--------v----v------+          |
  //    |                    |          |
  //    |      header        |          |
  //    |                    |          |
  //    +--------------------+          |
  //                                    |
  //            .....                   |
  //                                    |
  //    +--------------------+          |
  //    |                    |          |
  //    |       latch        >----------/
  //    |                    |
  //    +-------v------------+
  //            |
  //            |
  //            |   +--------------------+
  //            |   |                    |
  //            +--->   original exit    |
  //                |                    |
  //                +--------------------+
  //
  // We change the control flow to look like
  //
  //
  //    +--------------------+
  //    |                    |
  //    |     preheader      >-------------------------+
  //    |                    |                         |
  //    +--------v-----------+                         |
  //             |    /-------------+                  |
  //             |   /              |                  |
  //    +--------v--v--------+      |                  |
  //    |                    |      |                  |
  //    |      header        |      |   +--------+     |
  //    |                    |      |   |        |     |
  //    +--------------------+      |   |  +-----v-----v-----------+
  //                                |   |  |                       |
  //                                |   |  |     .pseudo.exit      |
  //                                |   |  |                       |
  //                                |   |  +-----------v-----------+
  //                                |   |              |
  //            .....               |   |              |
  //                                |   |     +--------v-------------+
  //    +--------------------+      |   |     |                      |
  //    |                    |      |   |     |   ContinuationBlock  |
  //    |       latch        >------+   |     |                      |
  //    |                    |          |     +----------------------+
  //    +---------v----------+          |
  //              |                     |
  //              |                     |
  //              |     +---------------^-----+
  //              |     |                     |
  //              +----->    .exit.selector   |
  //                    |                     |
  //                    +----------v----------+
  //                               |
  //     +--------------------+    |
  //     |                    |    |
  //     |   original exit    <----+
  //     |                    |
  //     +--------------------+

  RewrittenRangeInfo RRI;

  BasicBlock *BBInsertLocation = LS.Latch->getNextNode();
  RRI.ExitSelector = BasicBlock::Create(Ctx, Twine(LS.Tag) + ".exit.selector",
                                        &F, BBInsertLocation);
  RRI.PseudoExit = BasicBlock::Create(Ctx, Twine(LS.Tag) + ".pseudo.exit", &F,
                                      BBInsertLocation);

  BranchInst *PreheaderJump = cast<BranchInst>(Preheader->getTerminator());
  bool Increasing = LS.IndVarIncreasing;
  bool IsSignedPredicate = LS.IsSignedPredicate;

  IRBuilder<> B(PreheaderJump);

  // EnterLoopCond - is it okay to start executing this `LS'?
  Value *EnterLoopCond = nullptr;
  if (Increasing)
    EnterLoopCond = IsSignedPredicate
                        ? B.CreateICmpSLT(LS.IndVarStart, ExitSubloopAt)
                        : B.CreateICmpULT(LS.IndVarStart, ExitSubloopAt);
  else
    EnterLoopCond = IsSignedPredicate
                        ? B.CreateICmpSGT(LS.IndVarStart, ExitSubloopAt)
                        : B.CreateICmpUGT(LS.IndVarStart, ExitSubloopAt);

  B.CreateCondBr(EnterLoopCond, LS.Header, RRI.PseudoExit);
  PreheaderJump->eraseFromParent();

  LS.LatchBr->setSuccessor(LS.LatchBrExitIdx, RRI.ExitSelector);
  B.SetInsertPoint(LS.LatchBr);
  Value *TakeBackedgeLoopCond = nullptr;
  if (Increasing)
    TakeBackedgeLoopCond = IsSignedPredicate
                        ? B.CreateICmpSLT(LS.IndVarBase, ExitSubloopAt)
                        : B.CreateICmpULT(LS.IndVarBase, ExitSubloopAt);
  else
    TakeBackedgeLoopCond = IsSignedPredicate
                        ? B.CreateICmpSGT(LS.IndVarBase, ExitSubloopAt)
                        : B.CreateICmpUGT(LS.IndVarBase, ExitSubloopAt);
  Value *CondForBranch = LS.LatchBrExitIdx == 1
                             ? TakeBackedgeLoopCond
                             : B.CreateNot(TakeBackedgeLoopCond);

  LS.LatchBr->setCondition(CondForBranch);

  B.SetInsertPoint(RRI.ExitSelector);

  // IterationsLeft - are there any more iterations left, given the original
  // upper bound on the induction variable?  If not, we branch to the "real"
  // exit.
  Value *IterationsLeft = nullptr;
  if (Increasing)
    IterationsLeft = IsSignedPredicate
                         ? B.CreateICmpSLT(LS.IndVarBase, LS.LoopExitAt)
                         : B.CreateICmpULT(LS.IndVarBase, LS.LoopExitAt);
  else
    IterationsLeft = IsSignedPredicate
                         ? B.CreateICmpSGT(LS.IndVarBase, LS.LoopExitAt)
                         : B.CreateICmpUGT(LS.IndVarBase, LS.LoopExitAt);
  B.CreateCondBr(IterationsLeft, RRI.PseudoExit, LS.LatchExit);

  BranchInst *BranchToContinuation =
      BranchInst::Create(ContinuationBlock, RRI.PseudoExit);

  // We emit PHI nodes into `RRI.PseudoExit' that compute the "latest" value of
  // each of the PHI nodes in the loop header.  This feeds into the initial
  // value of the same PHI nodes if/when we continue execution.
  for (PHINode &PN : LS.Header->phis()) {
    PHINode *NewPHI = PHINode::Create(PN.getType(), 2, PN.getName() + ".copy",
                                      BranchToContinuation);

    NewPHI->addIncoming(PN.getIncomingValueForBlock(Preheader), Preheader);
    NewPHI->addIncoming(PN.getIncomingValueForBlock(LS.Latch),
                        RRI.ExitSelector);
    RRI.PHIValuesAtPseudoExit.push_back(NewPHI);
  }

  RRI.IndVarEnd = PHINode::Create(LS.IndVarBase->getType(), 2, "indvar.end",
                                  BranchToContinuation);
  RRI.IndVarEnd->addIncoming(LS.IndVarStart, Preheader);
  RRI.IndVarEnd->addIncoming(LS.IndVarBase, RRI.ExitSelector);

  // The latch exit now has a branch from `RRI.ExitSelector' instead of
  // `LS.Latch'.  The PHI nodes need to be updated to reflect that.
  for (PHINode &PN : LS.LatchExit->phis())
    replacePHIBlock(&PN, LS.Latch, RRI.ExitSelector);

  return RRI;
}

void LoopConstrainer::rewriteIncomingValuesForPHIs(
    LoopStructure &LS, BasicBlock *ContinuationBlock,
    const LoopConstrainer::RewrittenRangeInfo &RRI) const {
  unsigned PHIIndex = 0;
  for (PHINode &PN : LS.Header->phis())
    for (unsigned i = 0, e = PN.getNumIncomingValues(); i < e; ++i)
      if (PN.getIncomingBlock(i) == ContinuationBlock)
        PN.setIncomingValue(i, RRI.PHIValuesAtPseudoExit[PHIIndex++]);

  LS.IndVarStart = RRI.IndVarEnd;
}

BasicBlock *LoopConstrainer::createPreheader(const LoopStructure &LS,
                                             BasicBlock *OldPreheader,
                                             const char *Tag) const {
  BasicBlock *Preheader = BasicBlock::Create(Ctx, Tag, &F, LS.Header);
  BranchInst::Create(LS.Header, Preheader);

  for (PHINode &PN : LS.Header->phis())
    for (unsigned i = 0, e = PN.getNumIncomingValues(); i < e; ++i)
      replacePHIBlock(&PN, OldPreheader, Preheader);

  return Preheader;
}

void LoopConstrainer::addToParentLoopIfNeeded(ArrayRef<BasicBlock *> BBs) {
  Loop *ParentLoop = OriginalLoop.getParentLoop();
  if (!ParentLoop)
    return;

  for (BasicBlock *BB : BBs)
    ParentLoop->addBasicBlockToLoop(BB, LI);
}

Loop *LoopConstrainer::createClonedLoopStructure(Loop *Original, Loop *Parent,
                                                 ValueToValueMapTy &VM) {
  Loop &New = *LI.AllocateLoop();
  if (Parent)
    Parent->addChildLoop(&New);
  else
    LI.addTopLevelLoop(&New);
  LPM.addLoop(New);

  // Add all of the blocks in Original to the new loop.
  for (auto *BB : Original->blocks())
    if (LI.getLoopFor(BB) == Original)
      New.addBasicBlockToLoop(cast<BasicBlock>(VM[BB]), LI);

  // Add all of the subloops to the new loop.
  for (Loop *SubLoop : *Original)
    createClonedLoopStructure(SubLoop, &New, VM);

  return &New;
}

bool LoopConstrainer::run() {
  BasicBlock *Preheader = nullptr;
  LatchTakenCount = SE.getExitCount(&OriginalLoop, MainLoopStructure.Latch);
  Preheader = OriginalLoop.getLoopPreheader();
  assert(!isa<SCEVCouldNotCompute>(LatchTakenCount) && Preheader != nullptr &&
         "preconditions!");

  OriginalPreheader = Preheader;
  MainLoopPreheader = Preheader;

  bool IsSignedPredicate = MainLoopStructure.IsSignedPredicate;
  Optional<SubRanges> MaybeSR = calculateSubRanges(IsSignedPredicate);
  if (!MaybeSR.hasValue()) {
    DEBUG(dbgs() << "irce: could not compute subranges\n");
    return false;
  }

  SubRanges SR = MaybeSR.getValue();
  bool Increasing = MainLoopStructure.IndVarIncreasing;
  IntegerType *IVTy =
      cast<IntegerType>(MainLoopStructure.IndVarBase->getType());

  SCEVExpander Expander(SE, F.getParent()->getDataLayout(), "irce");
  Instruction *InsertPt = OriginalPreheader->getTerminator();

  // It would have been better to make `PreLoop' and `PostLoop'
  // `Optional<ClonedLoop>'s, but `ValueToValueMapTy' does not have a copy
  // constructor.
  ClonedLoop PreLoop, PostLoop;
  bool NeedsPreLoop =
      Increasing ? SR.LowLimit.hasValue() : SR.HighLimit.hasValue();
  bool NeedsPostLoop =
      Increasing ? SR.HighLimit.hasValue() : SR.LowLimit.hasValue();

  Value *ExitPreLoopAt = nullptr;
  Value *ExitMainLoopAt = nullptr;
  const SCEVConstant *MinusOneS =
      cast<SCEVConstant>(SE.getConstant(IVTy, -1, true /* isSigned */));

  if (NeedsPreLoop) {
    const SCEV *ExitPreLoopAtSCEV = nullptr;

    if (Increasing)
      ExitPreLoopAtSCEV = *SR.LowLimit;
    else {
      if (CanBeMin(SE, *SR.HighLimit, IsSignedPredicate)) {
        DEBUG(dbgs() << "irce: could not prove no-overflow when computing "
                     << "preloop exit limit.  HighLimit = " << *(*SR.HighLimit)
                     << "\n");
        return false;
      }
      ExitPreLoopAtSCEV = SE.getAddExpr(*SR.HighLimit, MinusOneS);
    }

    if (!isSafeToExpandAt(ExitPreLoopAtSCEV, InsertPt, SE)) {
      DEBUG(dbgs() << "irce: could not prove that it is safe to expand the"
                   << " preloop exit limit " << *ExitPreLoopAtSCEV
                   << " at block " << InsertPt->getParent()->getName() << "\n");
      return false;
    }

    ExitPreLoopAt = Expander.expandCodeFor(ExitPreLoopAtSCEV, IVTy, InsertPt);
    ExitPreLoopAt->setName("exit.preloop.at");
  }

  if (NeedsPostLoop) {
    const SCEV *ExitMainLoopAtSCEV = nullptr;

    if (Increasing)
      ExitMainLoopAtSCEV = *SR.HighLimit;
    else {
      if (CanBeMin(SE, *SR.LowLimit, IsSignedPredicate)) {
        DEBUG(dbgs() << "irce: could not prove no-overflow when computing "
                     << "mainloop exit limit.  LowLimit = " << *(*SR.LowLimit)
                     << "\n");
        return false;
      }
      ExitMainLoopAtSCEV = SE.getAddExpr(*SR.LowLimit, MinusOneS);
    }

    if (!isSafeToExpandAt(ExitMainLoopAtSCEV, InsertPt, SE)) {
      DEBUG(dbgs() << "irce: could not prove that it is safe to expand the"
                   << " main loop exit limit " << *ExitMainLoopAtSCEV
                   << " at block " << InsertPt->getParent()->getName() << "\n");
      return false;
    }

    ExitMainLoopAt = Expander.expandCodeFor(ExitMainLoopAtSCEV, IVTy, InsertPt);
    ExitMainLoopAt->setName("exit.mainloop.at");
  }

  // We clone these ahead of time so that we don't have to deal with changing
  // and temporarily invalid IR as we transform the loops.
  if (NeedsPreLoop)
    cloneLoop(PreLoop, "preloop");
  if (NeedsPostLoop)
    cloneLoop(PostLoop, "postloop");

  RewrittenRangeInfo PreLoopRRI;

  if (NeedsPreLoop) {
    Preheader->getTerminator()->replaceUsesOfWith(MainLoopStructure.Header,
                                                  PreLoop.Structure.Header);

    MainLoopPreheader =
        createPreheader(MainLoopStructure, Preheader, "mainloop");
    PreLoopRRI = changeIterationSpaceEnd(PreLoop.Structure, Preheader,
                                         ExitPreLoopAt, MainLoopPreheader);
    rewriteIncomingValuesForPHIs(MainLoopStructure, MainLoopPreheader,
                                 PreLoopRRI);
  }

  BasicBlock *PostLoopPreheader = nullptr;
  RewrittenRangeInfo PostLoopRRI;

  if (NeedsPostLoop) {
    PostLoopPreheader =
        createPreheader(PostLoop.Structure, Preheader, "postloop");
    PostLoopRRI = changeIterationSpaceEnd(MainLoopStructure, MainLoopPreheader,
                                          ExitMainLoopAt, PostLoopPreheader);
    rewriteIncomingValuesForPHIs(PostLoop.Structure, PostLoopPreheader,
                                 PostLoopRRI);
  }

  BasicBlock *NewMainLoopPreheader =
      MainLoopPreheader != Preheader ? MainLoopPreheader : nullptr;
  BasicBlock *NewBlocks[] = {PostLoopPreheader,        PreLoopRRI.PseudoExit,
                             PreLoopRRI.ExitSelector,  PostLoopRRI.PseudoExit,
                             PostLoopRRI.ExitSelector, NewMainLoopPreheader};

  // Some of the above may be nullptr, filter them out before passing to
  // addToParentLoopIfNeeded.
  auto NewBlocksEnd =
      std::remove(std::begin(NewBlocks), std::end(NewBlocks), nullptr);

  addToParentLoopIfNeeded(makeArrayRef(std::begin(NewBlocks), NewBlocksEnd));

  DT.recalculate(F);

  // We need to first add all the pre and post loop blocks into the loop
  // structures (as part of createClonedLoopStructure), and then update the
  // LCSSA form and LoopSimplifyForm. This is necessary for correctly updating
  // LI when LoopSimplifyForm is generated.
  Loop *PreL = nullptr, *PostL = nullptr;
  if (!PreLoop.Blocks.empty()) {
    PreL = createClonedLoopStructure(
        &OriginalLoop, OriginalLoop.getParentLoop(), PreLoop.Map);
  }

  if (!PostLoop.Blocks.empty()) {
    PostL = createClonedLoopStructure(
        &OriginalLoop, OriginalLoop.getParentLoop(), PostLoop.Map);
  }

  // This function canonicalizes the loop into Loop-Simplify and LCSSA forms.
  auto CanonicalizeLoop = [&] (Loop *L, bool IsOriginalLoop) {
    formLCSSARecursively(*L, DT, &LI, &SE);
    simplifyLoop(L, &DT, &LI, &SE, nullptr, true);
    // Pre/post loops are slow paths, we do not need to perform any loop
    // optimizations on them.
    if (!IsOriginalLoop)
      DisableAllLoopOptsOnLoop(*L);
  };
  if (PreL)
    CanonicalizeLoop(PreL, false);
  if (PostL)
    CanonicalizeLoop(PostL, false);
  CanonicalizeLoop(&OriginalLoop, true);

  return true;
}

/// Computes and returns a range of values for the induction variable (IndVar)
/// in which the range check can be safely elided.  If it cannot compute such a
/// range, returns None.
Optional<InductiveRangeCheck::Range>
InductiveRangeCheck::computeSafeIterationSpace(
    ScalarEvolution &SE, const SCEVAddRecExpr *IndVar,
    bool IsLatchSigned) const {
  // IndVar is of the form "A + B * I" (where "I" is the canonical induction
  // variable, that may or may not exist as a real llvm::Value in the loop) and
  // this inductive range check is a range check on the "C + D * I" ("C" is
  // getBegin() and "D" is getStep()).  We rewrite the value being range
  // checked to "M + N * IndVar" where "N" = "D * B^(-1)" and "M" = "C - NA".
  //
  // The actual inequalities we solve are of the form
  //
  //   0 <= M + 1 * IndVar < L given L >= 0  (i.e. N == 1)
  //
  // Here L stands for upper limit of the safe iteration space.
  // The inequality is satisfied by (0 - M) <= IndVar < (L - M). To avoid
  // overflows when calculating (0 - M) and (L - M) we, depending on type of
  // IV's iteration space, limit the calculations by borders of the iteration
  // space. For example, if IndVar is unsigned, (0 - M) overflows for any M > 0.
  // If we figured out that "anything greater than (-M) is safe", we strengthen
  // this to "everything greater than 0 is safe", assuming that values between
  // -M and 0 just do not exist in unsigned iteration space, and we don't want
  // to deal with overflown values.

  if (!IndVar->isAffine())
    return None;

  const SCEV *A = IndVar->getStart();
  const SCEVConstant *B = dyn_cast<SCEVConstant>(IndVar->getStepRecurrence(SE));
  if (!B)
    return None;
  assert(!B->isZero() && "Recurrence with zero step?");

  const SCEV *C = getBegin();
  const SCEVConstant *D = dyn_cast<SCEVConstant>(getStep());
  if (D != B)
    return None;

  assert(!D->getValue()->isZero() && "Recurrence with zero step?");
  unsigned BitWidth = cast<IntegerType>(IndVar->getType())->getBitWidth();
  const SCEV *SIntMax = SE.getConstant(APInt::getSignedMaxValue(BitWidth));

  // Substract Y from X so that it does not go through border of the IV
  // iteration space. Mathematically, it is equivalent to:
  //
  //    ClampedSubstract(X, Y) = min(max(X - Y, INT_MIN), INT_MAX).        [1]
  //
  // In [1], 'X - Y' is a mathematical substraction (result is not bounded to
  // any width of bit grid). But after we take min/max, the result is
  // guaranteed to be within [INT_MIN, INT_MAX].
  //
  // In [1], INT_MAX and INT_MIN are respectively signed and unsigned max/min
  // values, depending on type of latch condition that defines IV iteration
  // space.
  auto ClampedSubstract = [&](const SCEV *X, const SCEV *Y) {
    assert(SE.isKnownNonNegative(X) &&
           "We can only substract from values in [0; SINT_MAX]!");
    if (IsLatchSigned) {
      // X is a number from signed range, Y is interpreted as signed.
      // Even if Y is SINT_MAX, (X - Y) does not reach SINT_MIN. So the only
      // thing we should care about is that we didn't cross SINT_MAX.
      // So, if Y is positive, we substract Y safely.
      //   Rule 1: Y > 0 ---> Y.
      // If 0 <= -Y <= (SINT_MAX - X), we substract Y safely.
      //   Rule 2: Y >=s (X - SINT_MAX) ---> Y.
      // If 0 <= (SINT_MAX - X) < -Y, we can only substract (X - SINT_MAX).
      //   Rule 3: Y <s (X - SINT_MAX) ---> (X - SINT_MAX).
      // It gives us smax(Y, X - SINT_MAX) to substract in all cases.
      const SCEV *XMinusSIntMax = SE.getMinusSCEV(X, SIntMax);
      return SE.getMinusSCEV(X, SE.getSMaxExpr(Y, XMinusSIntMax),
                             SCEV::FlagNSW);
    } else
      // X is a number from unsigned range, Y is interpreted as signed.
      // Even if Y is SINT_MIN, (X - Y) does not reach UINT_MAX. So the only
      // thing we should care about is that we didn't cross zero.
      // So, if Y is negative, we substract Y safely.
      //   Rule 1: Y <s 0 ---> Y.
      // If 0 <= Y <= X, we substract Y safely.
      //   Rule 2: Y <=s X ---> Y.
      // If 0 <= X < Y, we should stop at 0 and can only substract X.
      //   Rule 3: Y >s X ---> X.
      // It gives us smin(X, Y) to substract in all cases.
      return SE.getMinusSCEV(X, SE.getSMinExpr(X, Y), SCEV::FlagNUW);
  };
  const SCEV *M = SE.getMinusSCEV(C, A);
  const SCEV *Zero = SE.getZero(M->getType());
  const SCEV *Begin = ClampedSubstract(Zero, M);
  const SCEV *End = ClampedSubstract(getEnd(), M);
  return InductiveRangeCheck::Range(Begin, End);
}

static Optional<InductiveRangeCheck::Range>
IntersectSignedRange(ScalarEvolution &SE,
                     const Optional<InductiveRangeCheck::Range> &R1,
                     const InductiveRangeCheck::Range &R2) {
  if (R2.isEmpty(SE, /* IsSigned */ true))
    return None;
  if (!R1.hasValue())
    return R2;
  auto &R1Value = R1.getValue();
  // We never return empty ranges from this function, and R1 is supposed to be
  // a result of intersection. Thus, R1 is never empty.
  assert(!R1Value.isEmpty(SE, /* IsSigned */ true) &&
         "We should never have empty R1!");

  // TODO: we could widen the smaller range and have this work; but for now we
  // bail out to keep things simple.
  if (R1Value.getType() != R2.getType())
    return None;

  const SCEV *NewBegin = SE.getSMaxExpr(R1Value.getBegin(), R2.getBegin());
  const SCEV *NewEnd = SE.getSMinExpr(R1Value.getEnd(), R2.getEnd());

  // If the resulting range is empty, just return None.
  auto Ret = InductiveRangeCheck::Range(NewBegin, NewEnd);
  if (Ret.isEmpty(SE, /* IsSigned */ true))
    return None;
  return Ret;
}

static Optional<InductiveRangeCheck::Range>
IntersectUnsignedRange(ScalarEvolution &SE,
                       const Optional<InductiveRangeCheck::Range> &R1,
                       const InductiveRangeCheck::Range &R2) {
  if (R2.isEmpty(SE, /* IsSigned */ false))
    return None;
  if (!R1.hasValue())
    return R2;
  auto &R1Value = R1.getValue();
  // We never return empty ranges from this function, and R1 is supposed to be
  // a result of intersection. Thus, R1 is never empty.
  assert(!R1Value.isEmpty(SE, /* IsSigned */ false) &&
         "We should never have empty R1!");

  // TODO: we could widen the smaller range and have this work; but for now we
  // bail out to keep things simple.
  if (R1Value.getType() != R2.getType())
    return None;

  const SCEV *NewBegin = SE.getUMaxExpr(R1Value.getBegin(), R2.getBegin());
  const SCEV *NewEnd = SE.getUMinExpr(R1Value.getEnd(), R2.getEnd());

  // If the resulting range is empty, just return None.
  auto Ret = InductiveRangeCheck::Range(NewBegin, NewEnd);
  if (Ret.isEmpty(SE, /* IsSigned */ false))
    return None;
  return Ret;
}

bool InductiveRangeCheckElimination::runOnLoop(Loop *L, LPPassManager &LPM) {
  if (skipLoop(L))
    return false;

  if (L->getBlocks().size() >= LoopSizeCutoff) {
    DEBUG(dbgs() << "irce: giving up constraining loop, too large\n";);
    return false;
  }

  BasicBlock *Preheader = L->getLoopPreheader();
  if (!Preheader) {
    DEBUG(dbgs() << "irce: loop has no preheader, leaving\n");
    return false;
  }

  LLVMContext &Context = Preheader->getContext();
  SmallVector<InductiveRangeCheck, 16> RangeChecks;
  ScalarEvolution &SE = getAnalysis<ScalarEvolutionWrapperPass>().getSE();
  BranchProbabilityInfo &BPI =
      getAnalysis<BranchProbabilityInfoWrapperPass>().getBPI();

  for (auto BBI : L->getBlocks())
    if (BranchInst *TBI = dyn_cast<BranchInst>(BBI->getTerminator()))
      InductiveRangeCheck::extractRangeChecksFromBranch(TBI, L, SE, BPI,
                                                        RangeChecks);

  if (RangeChecks.empty())
    return false;

  auto PrintRecognizedRangeChecks = [&](raw_ostream &OS) {
    OS << "irce: looking at loop "; L->print(OS);
    OS << "irce: loop has " << RangeChecks.size()
       << " inductive range checks: \n";
    for (InductiveRangeCheck &IRC : RangeChecks)
      IRC.print(OS);
  };

  DEBUG(PrintRecognizedRangeChecks(dbgs()));

  if (PrintRangeChecks)
    PrintRecognizedRangeChecks(errs());

  const char *FailureReason = nullptr;
  Optional<LoopStructure> MaybeLoopStructure =
      LoopStructure::parseLoopStructure(SE, BPI, *L, FailureReason);
  if (!MaybeLoopStructure.hasValue()) {
    DEBUG(dbgs() << "irce: could not parse loop structure: " << FailureReason
                 << "\n";);
    return false;
  }
  LoopStructure LS = MaybeLoopStructure.getValue();
  const SCEVAddRecExpr *IndVar =
      cast<SCEVAddRecExpr>(SE.getMinusSCEV(SE.getSCEV(LS.IndVarBase), SE.getSCEV(LS.IndVarStep)));

  Optional<InductiveRangeCheck::Range> SafeIterRange;
  Instruction *ExprInsertPt = Preheader->getTerminator();

  SmallVector<InductiveRangeCheck, 4> RangeChecksToEliminate;
  // Basing on the type of latch predicate, we interpret the IV iteration range
  // as signed or unsigned range. We use different min/max functions (signed or
  // unsigned) when intersecting this range with safe iteration ranges implied
  // by range checks.
  auto IntersectRange =
      LS.IsSignedPredicate ? IntersectSignedRange : IntersectUnsignedRange;

  IRBuilder<> B(ExprInsertPt);
  for (InductiveRangeCheck &IRC : RangeChecks) {
    auto Result = IRC.computeSafeIterationSpace(SE, IndVar,
                                                LS.IsSignedPredicate);
    if (Result.hasValue()) {
      auto MaybeSafeIterRange =
          IntersectRange(SE, SafeIterRange, Result.getValue());
      if (MaybeSafeIterRange.hasValue()) {
        assert(
            !MaybeSafeIterRange.getValue().isEmpty(SE, LS.IsSignedPredicate) &&
            "We should never return empty ranges!");
        RangeChecksToEliminate.push_back(IRC);
        SafeIterRange = MaybeSafeIterRange.getValue();
      }
    }
  }

  if (!SafeIterRange.hasValue())
    return false;

  auto &DT = getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  LoopConstrainer LC(*L, getAnalysis<LoopInfoWrapperPass>().getLoopInfo(), LPM,
                     LS, SE, DT, SafeIterRange.getValue());
  bool Changed = LC.run();

  if (Changed) {
    auto PrintConstrainedLoopInfo = [L]() {
      dbgs() << "irce: in function ";
      dbgs() << L->getHeader()->getParent()->getName() << ": ";
      dbgs() << "constrained ";
      L->print(dbgs());
    };

    DEBUG(PrintConstrainedLoopInfo());

    if (PrintChangedLoops)
      PrintConstrainedLoopInfo();

    // Optimize away the now-redundant range checks.

    for (InductiveRangeCheck &IRC : RangeChecksToEliminate) {
      ConstantInt *FoldedRangeCheck = IRC.getPassingDirection()
                                          ? ConstantInt::getTrue(Context)
                                          : ConstantInt::getFalse(Context);
      IRC.getCheckUse()->set(FoldedRangeCheck);
    }
  }

  return Changed;
}

Pass *llvm::createInductiveRangeCheckEliminationPass() {
  return new InductiveRangeCheckElimination;
}
