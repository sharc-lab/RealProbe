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
include tools/sancov/CMakeFiles/sancov.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tools/sancov/CMakeFiles/sancov.dir/compiler_depend.make

# Include the progress variables for this target.
include tools/sancov/CMakeFiles/sancov.dir/progress.make

# Include the compile flags for this target's objects.
include tools/sancov/CMakeFiles/sancov.dir/flags.make

tools/sancov/CMakeFiles/sancov.dir/sancov.cc.o: tools/sancov/CMakeFiles/sancov.dir/flags.make
tools/sancov/CMakeFiles/sancov.dir/sancov.cc.o: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/sancov/sancov.cc
tools/sancov/CMakeFiles/sancov.dir/sancov.cc.o: tools/sancov/CMakeFiles/sancov.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tools/sancov/CMakeFiles/sancov.dir/sancov.cc.o"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/sancov && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/sancov/CMakeFiles/sancov.dir/sancov.cc.o -MF CMakeFiles/sancov.dir/sancov.cc.o.d -o CMakeFiles/sancov.dir/sancov.cc.o -c /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/sancov/sancov.cc

tools/sancov/CMakeFiles/sancov.dir/sancov.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/sancov.dir/sancov.cc.i"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/sancov && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/sancov/sancov.cc > CMakeFiles/sancov.dir/sancov.cc.i

tools/sancov/CMakeFiles/sancov.dir/sancov.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/sancov.dir/sancov.cc.s"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/sancov && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/sancov/sancov.cc -o CMakeFiles/sancov.dir/sancov.cc.s

# Object files for target sancov
sancov_OBJECTS = \
"CMakeFiles/sancov.dir/sancov.cc.o"

# External object files for target sancov
sancov_EXTERNAL_OBJECTS =

bin/sancov: tools/sancov/CMakeFiles/sancov.dir/sancov.cc.o
bin/sancov: tools/sancov/CMakeFiles/sancov.dir/build.make
bin/sancov: lib/libLLVM-7.0svn.so
bin/sancov: tools/sancov/CMakeFiles/sancov.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../../bin/sancov"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/sancov && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/sancov.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/sancov/CMakeFiles/sancov.dir/build: bin/sancov
.PHONY : tools/sancov/CMakeFiles/sancov.dir/build

tools/sancov/CMakeFiles/sancov.dir/clean:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/sancov && $(CMAKE_COMMAND) -P CMakeFiles/sancov.dir/cmake_clean.cmake
.PHONY : tools/sancov/CMakeFiles/sancov.dir/clean

tools/sancov/CMakeFiles/sancov.dir/depend:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/sancov /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/sancov /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/sancov/CMakeFiles/sancov.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : tools/sancov/CMakeFiles/sancov.dir/depend
