add_llvm_library(LLVMScalarOpts
  ADCE.cpp
  AlignmentFromAssumptions.cpp
  BDCE.cpp
  CallSiteSplitting.cpp
  ConstantHoisting.cpp
  ConstantProp.cpp
  CorrelatedValuePropagation.cpp
  DCE.cpp
  DeadStoreElimination.cpp
  DivRemPairs.cpp
  EarlyCSE.cpp
  FlattenCFGPass.cpp
  Float2Int.cpp
  GuardWidening.cpp
  GVN.cpp
  GVNHoist.cpp
  GVNSink.cpp
  IVUsersPrinter.cpp
  InductiveRangeCheckElimination.cpp
  IndVarSimplify.cpp
  InferAddressSpaces.cpp
  JumpThreading.cpp
  LICM.cpp
  LoopAccessAnalysisPrinter.cpp
  LoopSink.cpp
  LoopDeletion.cpp
  LoopDataPrefetch.cpp
  LoopDistribute.cpp
  LoopIdiomRecognize.cpp
  LoopInstSimplify.cpp
  LoopInterchange.cpp
  LoopLoadElimination.cpp
  LoopPassManager.cpp
  LoopPredication.cpp
  LoopRerollPass.cpp
  LoopRotation.cpp
  LoopSimplifyCFG.cpp
  LoopStrengthReduce.cpp
  LoopUnrollPass.cpp
  LoopUnswitch.cpp
  LoopVersioningLICM.cpp
  LowerAtomic.cpp
  LowerExpectIntrinsic.cpp
  LowerGuardIntrinsic.cpp
  MemCpyOptimizer.cpp
  MergeICmps.cpp
  MergedLoadStoreMotion.cpp
  NaryReassociate.cpp
  NewGVN.cpp
  PartiallyInlineLibCalls.cpp
  PlaceSafepoints.cpp
  Reassociate.cpp
  Reg2Mem.cpp
  RewriteStatepointsForGC.cpp
  SCCP.cpp
  SROA.cpp
  Scalar.cpp
  Scalarizer.cpp
  SeparateConstOffsetFromGEP.cpp
  SimpleLoopUnswitch.cpp
  SimplifyCFGPass.cpp
  Sink.cpp
  SpeculativeExecution.cpp
  SpeculateAroundPHIs.cpp
  StraightLineStrengthReduce.cpp
  StructurizeCFG.cpp
  TailRecursionElimination.cpp
  TreeHeightReduction.cpp
  ADDITIONAL_HEADER_DIRS
  ${LLVM_MAIN_INCLUDE_DIR}/llvm/Transforms
  ${LLVM_MAIN_INCLUDE_DIR}/llvm/Transforms/Scalar

  DEPENDS
  intrinsics_gen
  )
