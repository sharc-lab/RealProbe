# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.29

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /export/hdd/scratch/jkim3998/.conda/dst_jiho/hlsllvm/lib/python3.12/site-packages/cmake/data/bin/cmake

# The command to remove a file.
RM = /export/hdd/scratch/jkim3998/.conda/dst_jiho/hlsllvm/lib/python3.12/site-packages/cmake/data/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build

# Include any dependencies generated for this target.
include tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/compiler_depend.make

# Include the progress variables for this target.
include tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/progress.make

# Include the compile flags for this target's objects.
include tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/flags.make

tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/ClangQuery.cpp.o: tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/flags.make
tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/ClangQuery.cpp.o: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang-tools-extra/clang-query/tool/ClangQuery.cpp
tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/ClangQuery.cpp.o: tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/ClangQuery.cpp.o"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/extra/clang-query/tool && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/ClangQuery.cpp.o -MF CMakeFiles/clang-query.dir/ClangQuery.cpp.o.d -o CMakeFiles/clang-query.dir/ClangQuery.cpp.o -c /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang-tools-extra/clang-query/tool/ClangQuery.cpp

tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/ClangQuery.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/clang-query.dir/ClangQuery.cpp.i"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/extra/clang-query/tool && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang-tools-extra/clang-query/tool/ClangQuery.cpp > CMakeFiles/clang-query.dir/ClangQuery.cpp.i

tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/ClangQuery.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/clang-query.dir/ClangQuery.cpp.s"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/extra/clang-query/tool && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang-tools-extra/clang-query/tool/ClangQuery.cpp -o CMakeFiles/clang-query.dir/ClangQuery.cpp.s

# Object files for target clang-query
clang__query_OBJECTS = \
"CMakeFiles/clang-query.dir/ClangQuery.cpp.o"

# External object files for target clang-query
clang__query_EXTERNAL_OBJECTS =

bin/clang-query: tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/ClangQuery.cpp.o
bin/clang-query: tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/build.make
bin/clang-query: lib/libclangAST.a
bin/clang-query: lib/libclangASTMatchers.a
bin/clang-query: lib/libclangBasic.a
bin/clang-query: lib/libclangDynamicASTMatchers.a
bin/clang-query: lib/libclangFrontend.a
bin/clang-query: lib/libclangQuery.a
bin/clang-query: lib/libclangTooling.a
bin/clang-query: lib/libclangDynamicASTMatchers.a
bin/clang-query: lib/libclangASTMatchers.a
bin/clang-query: lib/libclangFrontend.a
bin/clang-query: lib/libclangParse.a
bin/clang-query: lib/libclangSerialization.a
bin/clang-query: lib/libclangSema.a
bin/clang-query: lib/libclangEdit.a
bin/clang-query: lib/libclangAnalysis.a
bin/clang-query: lib/libclangDriver.a
bin/clang-query: lib/libclangFormat.a
bin/clang-query: lib/libclangToolingCore.a
bin/clang-query: lib/libclangAST.a
bin/clang-query: lib/libclangRewrite.a
bin/clang-query: lib/libclangLex.a
bin/clang-query: lib/libclangBasic.a
bin/clang-query: lib/libLLVM-7.0svn.so
bin/clang-query: tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../../../../../../bin/clang-query"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/extra/clang-query/tool && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/clang-query.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/build: bin/clang-query
.PHONY : tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/build

tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/clean:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/extra/clang-query/tool && $(CMAKE_COMMAND) -P CMakeFiles/clang-query.dir/cmake_clean.cmake
.PHONY : tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/clean

tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/depend:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang-tools-extra/clang-query/tool /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/extra/clang-query/tool /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : tools/clang/tools/extra/clang-query/tool/CMakeFiles/clang-query.dir/depend
