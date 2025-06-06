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

# Utility rule file for check-llvm.

# Include any custom commands dependencies for this target.
include test/CMakeFiles/check-llvm.dir/compiler_depend.make

# Include the progress variables for this target.
include test/CMakeFiles/check-llvm.dir/progress.make

test/CMakeFiles/check-llvm:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Running the LLVM regression tests"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/test && /usr/bin/python2.7 /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/./bin/llvm-lit -sv /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/test

check-llvm: test/CMakeFiles/check-llvm
check-llvm: test/CMakeFiles/check-llvm.dir/build.make
.PHONY : check-llvm

# Rule to build all files generated by this target.
test/CMakeFiles/check-llvm.dir/build: check-llvm
.PHONY : test/CMakeFiles/check-llvm.dir/build

test/CMakeFiles/check-llvm.dir/clean:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/test && $(CMAKE_COMMAND) -P CMakeFiles/check-llvm.dir/cmake_clean.cmake
.PHONY : test/CMakeFiles/check-llvm.dir/clean

test/CMakeFiles/check-llvm.dir/depend:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/test /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/test /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/test/CMakeFiles/check-llvm.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : test/CMakeFiles/check-llvm.dir/depend

