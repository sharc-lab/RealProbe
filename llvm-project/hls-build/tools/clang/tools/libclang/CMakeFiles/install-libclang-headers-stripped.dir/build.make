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

# Utility rule file for install-libclang-headers-stripped.

# Include any custom commands dependencies for this target.
include tools/clang/tools/libclang/CMakeFiles/install-libclang-headers-stripped.dir/compiler_depend.make

# Include the progress variables for this target.
include tools/clang/tools/libclang/CMakeFiles/install-libclang-headers-stripped.dir/progress.make

tools/clang/tools/libclang/CMakeFiles/install-libclang-headers-stripped:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/libclang && /usr/bin/cmake -DCMAKE_INSTALL_COMPONENT="libclang-headers" -DCMAKE_INSTALL_DO_STRIP=1 -P /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/cmake_install.cmake

install-libclang-headers-stripped: tools/clang/tools/libclang/CMakeFiles/install-libclang-headers-stripped
install-libclang-headers-stripped: tools/clang/tools/libclang/CMakeFiles/install-libclang-headers-stripped.dir/build.make
.PHONY : install-libclang-headers-stripped

# Rule to build all files generated by this target.
tools/clang/tools/libclang/CMakeFiles/install-libclang-headers-stripped.dir/build: install-libclang-headers-stripped
.PHONY : tools/clang/tools/libclang/CMakeFiles/install-libclang-headers-stripped.dir/build

tools/clang/tools/libclang/CMakeFiles/install-libclang-headers-stripped.dir/clean:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/libclang && $(CMAKE_COMMAND) -P CMakeFiles/install-libclang-headers-stripped.dir/cmake_clean.cmake
.PHONY : tools/clang/tools/libclang/CMakeFiles/install-libclang-headers-stripped.dir/clean

tools/clang/tools/libclang/CMakeFiles/install-libclang-headers-stripped.dir/depend:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/tools/libclang /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/libclang /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/libclang/CMakeFiles/install-libclang-headers-stripped.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tools/clang/tools/libclang/CMakeFiles/install-libclang-headers-stripped.dir/depend

