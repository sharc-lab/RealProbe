# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.26

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
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build

# Include any dependencies generated for this target.
include tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/compiler_depend.make

# Include the progress variables for this target.
include tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/progress.make

# Include the compile flags for this target's objects.
include tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/flags.make

tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.o: tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/flags.make
tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/include-fixer/tool/ClangIncludeFixer.cpp
tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.o: tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/include-fixer/tool && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.o -MF CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.o.d -o CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/include-fixer/tool/ClangIncludeFixer.cpp

tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/include-fixer/tool && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/include-fixer/tool/ClangIncludeFixer.cpp > CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.i

tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/include-fixer/tool && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/include-fixer/tool/ClangIncludeFixer.cpp -o CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.s

# Object files for target clang-include-fixer
clang__include__fixer_OBJECTS = \
"CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.o"

# External object files for target clang-include-fixer
clang__include__fixer_EXTERNAL_OBJECTS =

bin/clang-include-fixer: tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/ClangIncludeFixer.cpp.o
bin/clang-include-fixer: tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/build.make
bin/clang-include-fixer: lib/libclangBasic.a
bin/clang-include-fixer: lib/libclangFormat.a
bin/clang-include-fixer: lib/libclangFrontend.a
bin/clang-include-fixer: lib/libclangIncludeFixer.a
bin/clang-include-fixer: lib/libclangRewrite.a
bin/clang-include-fixer: lib/libclangTooling.a
bin/clang-include-fixer: lib/libclangToolingCore.a
bin/clang-include-fixer: lib/libfindAllSymbols.a
bin/clang-include-fixer: lib/libclangTooling.a
bin/clang-include-fixer: lib/libclangFormat.a
bin/clang-include-fixer: lib/libclangFrontend.a
bin/clang-include-fixer: lib/libclangSerialization.a
bin/clang-include-fixer: lib/libclangToolingCore.a
bin/clang-include-fixer: lib/libclangRewrite.a
bin/clang-include-fixer: lib/libclangDriver.a
bin/clang-include-fixer: lib/libclangASTMatchers.a
bin/clang-include-fixer: lib/libclangParse.a
bin/clang-include-fixer: lib/libclangSema.a
bin/clang-include-fixer: lib/libclangEdit.a
bin/clang-include-fixer: lib/libclangAnalysis.a
bin/clang-include-fixer: lib/libclangAST.a
bin/clang-include-fixer: lib/libclangLex.a
bin/clang-include-fixer: lib/libclangBasic.a
bin/clang-include-fixer: lib/libLLVM-7.0svn.so
bin/clang-include-fixer: tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../../../../../../bin/clang-include-fixer"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/include-fixer/tool && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/clang-include-fixer.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/build: bin/clang-include-fixer
.PHONY : tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/build

tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/clean:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/include-fixer/tool && $(CMAKE_COMMAND) -P CMakeFiles/clang-include-fixer.dir/cmake_clean.cmake
.PHONY : tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/clean

tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/depend:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/include-fixer/tool /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/include-fixer/tool /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tools/clang/tools/extra/include-fixer/tool/CMakeFiles/clang-include-fixer.dir/depend

