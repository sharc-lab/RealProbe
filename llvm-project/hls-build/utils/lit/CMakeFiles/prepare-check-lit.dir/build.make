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

# Utility rule file for prepare-check-lit.

# Include any custom commands dependencies for this target.
include utils/lit/CMakeFiles/prepare-check-lit.dir/compiler_depend.make

# Include the progress variables for this target.
include utils/lit/CMakeFiles/prepare-check-lit.dir/progress.make

utils/lit/CMakeFiles/prepare-check-lit:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Preparing lit tests"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/utils/lit && /usr/bin/cmake -E remove_directory /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/utils/lit/tests
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/utils/lit && /usr/bin/cmake -E copy_directory /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/utils/lit/tests /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/utils/lit/tests
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/utils/lit && /usr/bin/cmake -E copy /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/utils/lit/lit.site.cfg /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/utils/lit/tests

prepare-check-lit: utils/lit/CMakeFiles/prepare-check-lit
prepare-check-lit: utils/lit/CMakeFiles/prepare-check-lit.dir/build.make
.PHONY : prepare-check-lit

# Rule to build all files generated by this target.
utils/lit/CMakeFiles/prepare-check-lit.dir/build: prepare-check-lit
.PHONY : utils/lit/CMakeFiles/prepare-check-lit.dir/build

utils/lit/CMakeFiles/prepare-check-lit.dir/clean:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/utils/lit && $(CMAKE_COMMAND) -P CMakeFiles/prepare-check-lit.dir/cmake_clean.cmake
.PHONY : utils/lit/CMakeFiles/prepare-check-lit.dir/clean

utils/lit/CMakeFiles/prepare-check-lit.dir/depend:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/utils/lit /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/utils/lit /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/utils/lit/CMakeFiles/prepare-check-lit.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : utils/lit/CMakeFiles/prepare-check-lit.dir/depend

