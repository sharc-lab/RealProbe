add_llvm_library(LLVMTransformUtils
  ASanStackFrameLayout.cpp
  AddDiscriminators.cpp
  BasicBlockUtils.cpp
  BreakCriticalEdges.cpp
  BuildLibCalls.cpp
  BypassSlowDivision.cpp
  CallPromotionUtils.cpp
  CloneFunction.cpp
  CloneModule.cpp
  CodeExtractor.cpp
  CodeMoverUtils.cpp
  CtorUtils.cpp
  DemoteRegToStack.cpp
  EntryExitInstrumenter.cpp
  EscapeEnumerator.cpp
  Evaluator.cpp
  FlattenCFG.cpp
  FunctionComparator.cpp
  FunctionImportUtils.cpp
  GlobalStatus.cpp
  InlineFunction.cpp
  ImportedFunctionsInliningStatistics.cpp
  InstructionNamer.cpp
  IntegerDivision.cpp
  LCSSA.cpp
  LibCallsShrinkWrap.cpp
  Local.cpp
  LoopSimplify.cpp
  LoopUnroll.cpp
  LoopUnrollPeel.cpp
  LoopUnrollRuntime.cpp
  LoopUtils.cpp
  LoopVersioning.cpp
  LowerInvoke.cpp
  LowerMemIntrinsics.cpp
  LowerSwitch.cpp
  Mem2Reg.cpp
  MetaRenamer.cpp
  ModuleUtils.cpp
  NameAnonGlobals.cpp
  OrderedInstructions.cpp
  PredicateInfo.cpp
  PromoteMemoryToRegister.cpp
  StripGCRelocates.cpp
  SSAUpdater.cpp
  SanitizerStats.cpp
  SimplifyCFG.cpp
  SimplifyIndVar.cpp
  SimplifyInstructions.cpp
  SimplifyLibCalls.cpp
  SplitModule.cpp
  StripNonLineTableDebugInfo.cpp
  SymbolRewriter.cpp
  UnifyFunctionExitNodes.cpp
  Utils.cpp
  ValueMapper.cpp
  VNCoercion.cpp
  XILINXFunctionUtils.cpp
  XILINXLoopUtils.cpp

  ADDITIONAL_HEADER_DIRS
  ${LLVM_MAIN_INCLUDE_DIR}/llvm/Transforms
  ${LLVM_MAIN_INCLUDE_DIR}/llvm/Transforms/Utils

  DEPENDS
  intrinsics_gen
  )
