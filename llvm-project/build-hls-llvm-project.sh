#!/usr/bin/env bash

set -x

# Get absolute paths to output and src directories
srcroot=`pwd`
builddir=`pwd`/hls-build
llvm_srcroot=$srcroot

# create build output directory
mkdir -p $builddir
cd $builddir

sqlitever=3.28.0
sqlitedir=$srcroot/ext/sqlite-$sqlitever
sqlitelibname=libsqlite${sqlitever}.so
sqlitelib=`find $sqlitedir -type f -name $sqlitelibname`
sqliteheader=`find $sqlitedir -type f -name sqlite3.h`

[ -z "$sqlitelib" ] && echo "ERROR: could not find $sqlitelibname in $sqlitedir" && exit 2
[ -z "$sqliteheader" ] && echo "ERROR: could not find sqlite3.h in $sqlitedir" && exit 2
[ ! -d "$llvm_srcroot" ] && echo "ERROR: could not find hls-llvm-project directory" && exit 2

export LD_LIBRARY_PATH=`dirname $sqlitelib`:${LD_LIBRARY_PATH}

# build llvm, clang & clang-tools-extra
INSTALL_PREFIX="hls-install"
#NOTE: CMake 3.4.3 or higher is required
#NOTE: Can replace with 'ninja' if it's install with "cmake -G Ninja"
#NOTE: -DLLVM_ENABLE_DOXYGEN and -DLLVM_BUILD_DOCS are for doxygen documentation.
cmake3 "$llvm_srcroot/llvm" \
	-DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
	-DLLVM_EXTERNAL_CLANG_SOURCE_DIR=$llvm_srcroot/clang \
        -DLLVM_TARGETS_TO_BUILD=X86 \
        -DLLVM_ENABLE_PROJECTS=clang \
        -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON \
        -DLLVM_BUILD_LLVM_DYLIB=ON \
        -DLLVM_LINK_LLVM_DYLIB=ON \
        -DOPEN_SQLITE_LIB_FILE=$sqlitelib \
        -DOPEN_SQLITE_INCLUDE_DIR=`dirname $sqliteheader`  \
        -DCMAKE_BUILD_TYPE=Release

#NOTE: Use 'ninja' if you have it!:-)
make -j $(nproc)

#Build documentation
#make doxygen


