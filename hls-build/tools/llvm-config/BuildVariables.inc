//===-- BuildVariables.inc.in - llvm-config build variables -*- C++ -*-----===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file is configured by the build system to define the variables
// llvm-config wants to report to the user, but which can only be determined at
// build time.
//
// The variant of this file not ending with .in has been autogenerated by the
// LLVM build. Do not edit!
//
//===----------------------------------------------------------------------===//

#define LLVM_SRC_ROOT "/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm"
#define LLVM_OBJ_ROOT "/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build"
#define LLVM_CPPFLAGS "  -D_GNU_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS"
#define LLVM_CFLAGS "-march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -ffunction-sections -pipe -isystem /export/hdd/scratch/jkim3998/.conda/dst_jiho/hlsllvm/include -fPIC -Werror=date-time -Wall -W -Wno-unused-parameter -Wwrite-strings -Wno-missing-field-initializers -pedantic -Wno-long-long -Wno-comment -ffunction-sections -fdata-sections -O3 -DNDEBUG -D_GNU_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS"
#define LLVM_LDFLAGS ""
#define LLVM_CXXFLAGS "-fvisibility-inlines-hidden -fmessage-length=0 -march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -ffunction-sections -pipe -isystem /export/hdd/scratch/jkim3998/.conda/dst_jiho/hlsllvm/include -fPIC -fvisibility-inlines-hidden -Werror=date-time -std=c++11 -Wall -W -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wno-missing-field-initializers -pedantic -Wno-long-long -Wno-maybe-uninitialized -Wdelete-non-virtual-dtor -Wno-comment -ffunction-sections -fdata-sections -O3 -DNDEBUG  -fno-exceptions -fno-rtti -D_GNU_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS"
#define LLVM_BUILDMODE "Release"
#define LLVM_LIBDIR_SUFFIX ""
#define LLVM_TARGETS_BUILT "X86"
#define LLVM_SYSTEM_LIBS "-lz -lrt -ldl -ltinfo -lpthread -lm"
#define LLVM_BUILD_SYSTEM "cmake"
#define LLVM_HAS_RTTI 0
#define LLVM_ENABLE_DYLIB 1
#define LLVM_LINK_DYLIB 1
#define LLVM_ENABLE_SHARED 0
#define LLVM_DYLIB_COMPONENTS "all"
#define LLVM_DYLIB_VERSION "7.0svn"
#define LLVM_HAS_GLOBAL_ISEL 1
#define LLVM_TOOLS_INSTALL_DIR "bin"