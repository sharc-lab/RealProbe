# This file provides information and services to the final user.


# LLVM_BUILD_* values available only from LLVM build tree.
set(LLVM_BUILD_BINARY_DIR "/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build")
set(LLVM_BUILD_LIBRARY_DIR "/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/./lib")
set(LLVM_BUILD_MAIN_INCLUDE_DIR "/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/include")
set(LLVM_BUILD_MAIN_SRC_DIR "/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm")


set(LLVM_VERSION_MAJOR 7)
set(LLVM_VERSION_MINOR 0)
set(LLVM_VERSION_PATCH 0)
set(LLVM_PACKAGE_VERSION 7.0.0svn)

set(LLVM_BUILD_TYPE Release)

set(LLVM_COMMON_DEPENDS )

set(LLVM_AVAILABLE_LIBS LLVMDemangle;LLVMSupport;LLVMTableGen;LLVMCore;LLVMFuzzMutate;LLVMIRReader;LLVMCodeGen;LLVMSelectionDAG;LLVMAsmPrinter;LLVMMIRParser;LLVMGlobalISel;LLVMBinaryFormat;LLVMBitReader;LLVMBitWriter;LLVMTransformUtils;LLVMInstrumentation;LLVMInstCombine;LLVMScalarOpts;LLVMipo;LLVMVectorize;LLVMObjCARCOpts;LLVMCoroutines;LLVMLinker;LLVMAnalysis;LLVMLTO;LLVMMC;LLVMMCParser;LLVMMCDisassembler;LLVMObject;LLVMObjectYAML;LLVMOption;LLVMDebugInfoDWARF;LLVMDebugInfoMSF;LLVMDebugInfoCodeView;LLVMDebugInfoPDB;LLVMSymbolize;LLVMExecutionEngine;LLVMInterpreter;LLVMMCJIT;LLVMOrcJIT;LLVMRuntimeDyld;LLVMTarget;LLVMX86CodeGen;LLVMX86AsmParser;LLVMX86Disassembler;LLVMX86AsmPrinter;LLVMX86Desc;LLVMX86Info;LLVMX86Utils;LLVMAsmParser;LLVMLineEditor;LLVMProfileData;LLVMCoverage;LLVMPasses;LLVMDlltoolDriver;LLVMLibDriver;LLVMXRay;LLVMWindowsManifest;LLVMDebugHelpers;LTO;LLVM)

set(LLVM_ALL_TARGETS AArch64;AMDGPU;ARM;BPF;FPGA;Hexagon;Lanai;Mips;MSP430;NVPTX;PowerPC;Sparc;SystemZ;X86;XCore)

set(LLVM_TARGETS_TO_BUILD X86)

set(LLVM_TARGETS_WITH_JIT X86;PowerPC;AArch64;ARM;Mips;SystemZ)


set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMDemangle )
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMSupport LLVMDemangle)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMTableGen LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMCore LLVMBinaryFormat;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMFuzzMutate LLVMAnalysis;LLVMBitReader;LLVMBitWriter;LLVMCore;LLVMScalarOpts;LLVMSupport;LLVMTarget)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMIRReader LLVMAsmParser;LLVMBitReader;LLVMCore;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMCodeGen LLVMAnalysis;LLVMBitReader;LLVMBitWriter;LLVMCore;LLVMMC;LLVMProfileData;LLVMScalarOpts;LLVMSupport;LLVMTarget;LLVMTransformUtils)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMSelectionDAG LLVMAnalysis;LLVMCodeGen;LLVMCore;LLVMMC;LLVMSupport;LLVMTarget;LLVMTransformUtils)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMAsmPrinter LLVMAnalysis;LLVMBinaryFormat;LLVMCodeGen;LLVMCore;LLVMDebugInfoCodeView;LLVMDebugInfoMSF;LLVMMC;LLVMMCParser;LLVMSupport;LLVMTarget)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMMIRParser LLVMAsmParser;LLVMBinaryFormat;LLVMCodeGen;LLVMCore;LLVMMC;LLVMSupport;LLVMTarget)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMGlobalISel LLVMAnalysis;LLVMCodeGen;LLVMCore;LLVMMC;LLVMSupport;LLVMTarget;LLVMTransformUtils)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMBinaryFormat LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMBitReader LLVMCore;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMBitWriter LLVMAnalysis;LLVMCore;LLVMMC;LLVMObject;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMTransformUtils LLVMAnalysis;LLVMCore;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMInstrumentation LLVMAnalysis;LLVMCore;LLVMMC;LLVMProfileData;LLVMSupport;LLVMTransformUtils)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMInstCombine LLVMAnalysis;LLVMCore;LLVMSupport;LLVMTransformUtils)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMScalarOpts LLVMAnalysis;LLVMCore;LLVMInstCombine;LLVMSupport;LLVMTransformUtils)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMipo LLVMAnalysis;LLVMBitReader;LLVMBitWriter;LLVMCore;LLVMIRReader;LLVMInstCombine;LLVMInstrumentation;LLVMLinker;LLVMObject;LLVMProfileData;LLVMScalarOpts;LLVMSupport;LLVMTransformUtils;LLVMVectorize)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMVectorize LLVMAnalysis;LLVMCore;LLVMSupport;LLVMTransformUtils)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMObjCARCOpts LLVMAnalysis;LLVMCore;LLVMSupport;LLVMTransformUtils)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMCoroutines LLVMAnalysis;LLVMCore;LLVMScalarOpts;LLVMSupport;LLVMTransformUtils;LLVMipo)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMLinker LLVMCore;LLVMSupport;LLVMTransformUtils)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMAnalysis LLVMBinaryFormat;LLVMCore;LLVMObject;LLVMProfileData;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMLTO LLVMAnalysis;LLVMBitReader;LLVMBitWriter;LLVMCodeGen;LLVMCore;LLVMInstCombine;LLVMLinker;LLVMMC;LLVMObjCARCOpts;LLVMObject;LLVMPasses;LLVMScalarOpts;LLVMSupport;LLVMTarget;LLVMTransformUtils;LLVMipo)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMMC LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMMCParser LLVMMC;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMMCDisassembler LLVMMC;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMObject LLVMBinaryFormat;LLVMBitReader;LLVMCore;LLVMMC;LLVMMCParser;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMObjectYAML LLVMDebugInfoCodeView;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMOption LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMDebugInfoDWARF LLVMBinaryFormat;LLVMMC;LLVMObject;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMDebugInfoMSF LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMDebugInfoCodeView LLVMDebugInfoMSF;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMDebugInfoPDB LLVMDebugInfoCodeView;LLVMDebugInfoMSF;LLVMObject;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMSymbolize LLVMDebugInfoDWARF;LLVMDebugInfoPDB;LLVMObject;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMExecutionEngine LLVMCore;LLVMMC;LLVMObject;LLVMRuntimeDyld;LLVMSupport;LLVMTarget)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMInterpreter LLVMCodeGen;LLVMCore;LLVMExecutionEngine;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMMCJIT LLVMCore;LLVMExecutionEngine;LLVMObject;LLVMRuntimeDyld;LLVMSupport;LLVMTarget)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMOrcJIT LLVMCore;LLVMExecutionEngine;LLVMObject;LLVMRuntimeDyld;LLVMSupport;LLVMTransformUtils)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMRuntimeDyld LLVMMC;LLVMObject;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMTarget LLVMAnalysis;LLVMCore;LLVMMC;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMX86CodeGen LLVMAnalysis;LLVMAsmPrinter;LLVMCodeGen;LLVMCore;LLVMGlobalISel;LLVMMC;LLVMSelectionDAG;LLVMSupport;LLVMTarget;LLVMX86AsmPrinter;LLVMX86Desc;LLVMX86Info;LLVMX86Utils)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMX86AsmParser LLVMMC;LLVMMCParser;LLVMSupport;LLVMX86AsmPrinter;LLVMX86Desc;LLVMX86Info)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMX86Disassembler LLVMMCDisassembler;LLVMSupport;LLVMX86Info)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMX86AsmPrinter LLVMMC;LLVMSupport;LLVMX86Utils)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMX86Desc LLVMMC;LLVMMCDisassembler;LLVMObject;LLVMSupport;LLVMX86AsmPrinter;LLVMX86Info)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMX86Info LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMX86Utils LLVMCore;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMAsmParser LLVMBinaryFormat;LLVMCore;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMLineEditor LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMProfileData LLVMCore;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMCoverage LLVMCore;LLVMObject;LLVMProfileData;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMPasses LLVMAnalysis;LLVMCodeGen;LLVMCore;LLVMInstCombine;LLVMInstrumentation;LLVMScalarOpts;LLVMSupport;LLVMTarget;LLVMTransformUtils;LLVMVectorize;LLVMipo)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMDlltoolDriver LLVMObject;LLVMOption;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMLibDriver LLVMBinaryFormat;LLVMObject;LLVMOption;LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMXRay )
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMWindowsManifest LLVMSupport)
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVMDebugHelpers )
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LTO )
set_property(GLOBAL PROPERTY LLVMBUILD_LIB_DEPS_LLVM )

set(TARGET_TRIPLE "x86_64-unknown-linux-gnu")

set(LLVM_ABI_BREAKING_CHECKS WITH_ASSERTS)

set(LLVM_ENABLE_ASSERTIONS OFF)

set(LLVM_ENABLE_EH OFF)

set(LLVM_ENABLE_RTTI OFF)

set(LLVM_ENABLE_TERMINFO ON)

set(LLVM_ENABLE_THREADS ON)

set(LLVM_ENABLE_ZLIB ON)

set(LLVM_LIBXML2_ENABLED 1)

set(LLVM_ENABLE_DIA_SDK 0)

set(LLVM_NATIVE_ARCH X86)

set(LLVM_ENABLE_PIC ON)

set(LLVM_BUILD_32_BITS OFF)

if (NOT "-lpthread" STREQUAL "")
  set(LLVM_PTHREAD_LIB "-lpthread")
endif()

set(LLVM_ENABLE_PLUGINS ON)
set(LLVM_EXPORT_SYMBOLS_FOR_PLUGINS OFF)
set(LLVM_PLUGIN_EXT .so)

set(LLVM_ON_UNIX 1)
set(LLVM_ON_WIN32 0)

set(LLVM_LIBDIR_SUFFIX )

set(LLVM_INCLUDE_DIRS "/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/include;/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/include")
set(LLVM_LIBRARY_DIRS "/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/./lib")

# These variables are duplicated, but they must match the LLVM variables of the
# same name. The variables ending in "S" could some day become lists, and are
# preserved for convention and compatibility.
set(LLVM_INCLUDE_DIR "/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/include;/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/include")
set(LLVM_LIBRARY_DIR "/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/./lib")

set(LLVM_DEFINITIONS "-D_GNU_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS")
set(LLVM_CMAKE_DIR "/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/cmake/modules")
set(LLVM_BINARY_DIR "/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build")
set(LLVM_TOOLS_BINARY_DIR "/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/./bin")
set(LLVM_TOOLS_INSTALL_DIR "bin")
set(LLVM_HAVE_OPT_VIEWER_MODULES 0)

if(NOT TARGET LLVMSupport)
  set(LLVM_EXPORTED_TARGETS "LLVMDemangle;LLVMSupport;LLVMTableGen;llvm-tblgen;LLVMCore;LLVMFuzzMutate;LLVMIRReader;LLVMCodeGen;LLVMSelectionDAG;LLVMAsmPrinter;LLVMMIRParser;LLVMGlobalISel;LLVMBinaryFormat;LLVMBitReader;LLVMBitWriter;LLVMTransformUtils;LLVMInstrumentation;LLVMInstCombine;LLVMScalarOpts;LLVMipo;LLVMVectorize;LLVMHello;LLVMObjCARCOpts;LLVMCoroutines;LLVMLinker;LLVMAnalysis;LLVMLTO;LLVMMC;LLVMMCParser;LLVMMCDisassembler;LLVMObject;LLVMObjectYAML;LLVMOption;LLVMDebugInfoDWARF;LLVMDebugInfoMSF;LLVMDebugInfoCodeView;LLVMDebugInfoPDB;LLVMSymbolize;LLVMExecutionEngine;LLVMInterpreter;LLVMMCJIT;LLVMOrcJIT;LLVMRuntimeDyld;LLVMTarget;LLVMX86CodeGen;LLVMX86AsmParser;LLVMX86Disassembler;LLVMX86AsmPrinter;LLVMX86Desc;LLVMX86Info;LLVMX86Utils;LLVMAsmParser;LLVMLineEditor;LLVMProfileData;LLVMCoverage;LLVMPasses;LLVMDlltoolDriver;LLVMLibDriver;LLVMXRay;LLVMWindowsManifest;LLVMDebugHelpers;LTO;llvm-ar;llvm-config;llvm-lto;llvm-profdata;clang-tblgen;bugpoint;BugpointPasses;llvm-dsymutil;llc;lli;llvm-as;llvm-bcanalyzer;llvm-c-test;llvm-cat;llvm-cfi-verify;llvm-cov;llvm-cvtres;llvm-cxxdump;llvm-cxxfilt;llvm-diff;llvm-dis;llvm-dwarfdump;llvm-dwp;llvm-extract;llvm-link;llvm-lto2;llvm-mc;llvm-mcmarkup;llvm-modextract;llvm-mt;llvm-nm;llvm-objcopy;llvm-objdump;llvm-opt-report;llvm-pdbutil;llvm-rc;llvm-readobj;llvm-rtdyld;LLVM;llvm-size;llvm-split;llvm-stress;llvm-strings;llvm-symbolizer;llvm-xray;obj2yaml;opt;sancov;sanstats;verify-uselistorder;yaml2obj;LLVMTestingSupport;gtest;gtest_main")
  include("/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/lib/cmake/llvm/LLVMExports.cmake")
  include("/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/lib/cmake/llvm/LLVMBuildTreeOnlyTargets.cmake")
endif()

# By creating intrinsics_gen here, subprojects that depend on LLVM's
# tablegen-generated headers can always depend on this target whether building
# in-tree with LLVM or not.
if(NOT TARGET intrinsics_gen)
  add_custom_target(intrinsics_gen)
endif()

set_property(GLOBAL PROPERTY LLVM_TARGETS_CONFIGURED On)
include(${LLVM_CMAKE_DIR}/LLVM-Config.cmake)
