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

# Utility rule file for install-llvm-ar-stripped.

# Include any custom commands dependencies for this target.
include tools/llvm-ar/CMakeFiles/install-llvm-ar-stripped.dir/compiler_depend.make

# Include the progress variables for this target.
include tools/llvm-ar/CMakeFiles/install-llvm-ar-stripped.dir/progress.make

tools/llvm-ar/CMakeFiles/install-llvm-ar-stripped: bin/llvm-ar
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/llvm-ar && /export/hdd/scratch/jkim3998/.conda/dst_jiho/hlsllvm/lib/python3.12/site-packages/cmake/data/bin/cmake -DCMAKE_INSTALL_COMPONENT="llvm-ar" -DCMAKE_INSTALL_DO_STRIP=1 -P /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/cmake_install.cmake

install-llvm-ar-stripped: tools/llvm-ar/CMakeFiles/install-llvm-ar-stripped
install-llvm-ar-stripped: tools/llvm-ar/CMakeFiles/install-llvm-ar-stripped.dir/build.make
.PHONY : install-llvm-ar-stripped

# Rule to build all files generated by this target.
tools/llvm-ar/CMakeFiles/install-llvm-ar-stripped.dir/build: install-llvm-ar-stripped
.PHONY : tools/llvm-ar/CMakeFiles/install-llvm-ar-stripped.dir/build

tools/llvm-ar/CMakeFiles/install-llvm-ar-stripped.dir/clean:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/llvm-ar && $(CMAKE_COMMAND) -P CMakeFiles/install-llvm-ar-stripped.dir/cmake_clean.cmake
.PHONY : tools/llvm-ar/CMakeFiles/install-llvm-ar-stripped.dir/clean

tools/llvm-ar/CMakeFiles/install-llvm-ar-stripped.dir/depend:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/llvm-ar /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/llvm-ar /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/llvm-ar/CMakeFiles/install-llvm-ar-stripped.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : tools/llvm-ar/CMakeFiles/install-llvm-ar-stripped.dir/depend
