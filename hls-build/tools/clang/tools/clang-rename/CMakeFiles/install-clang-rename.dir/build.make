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

# Utility rule file for install-clang-rename.

# Include any custom commands dependencies for this target.
include tools/clang/tools/clang-rename/CMakeFiles/install-clang-rename.dir/compiler_depend.make

# Include the progress variables for this target.
include tools/clang/tools/clang-rename/CMakeFiles/install-clang-rename.dir/progress.make

tools/clang/tools/clang-rename/CMakeFiles/install-clang-rename: bin/clang-rename
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/clang-rename && /export/hdd/scratch/jkim3998/.conda/dst_jiho/hlsllvm/lib/python3.12/site-packages/cmake/data/bin/cmake -DCMAKE_INSTALL_COMPONENT="clang-rename" -P /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/cmake_install.cmake

install-clang-rename: tools/clang/tools/clang-rename/CMakeFiles/install-clang-rename
install-clang-rename: tools/clang/tools/clang-rename/CMakeFiles/install-clang-rename.dir/build.make
.PHONY : install-clang-rename

# Rule to build all files generated by this target.
tools/clang/tools/clang-rename/CMakeFiles/install-clang-rename.dir/build: install-clang-rename
.PHONY : tools/clang/tools/clang-rename/CMakeFiles/install-clang-rename.dir/build

tools/clang/tools/clang-rename/CMakeFiles/install-clang-rename.dir/clean:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/clang-rename && $(CMAKE_COMMAND) -P CMakeFiles/install-clang-rename.dir/cmake_clean.cmake
.PHONY : tools/clang/tools/clang-rename/CMakeFiles/install-clang-rename.dir/clean

tools/clang/tools/clang-rename/CMakeFiles/install-clang-rename.dir/depend:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang/tools/clang-rename /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/clang-rename /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/clang-rename/CMakeFiles/install-clang-rename.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : tools/clang/tools/clang-rename/CMakeFiles/install-clang-rename.dir/depend
