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
include tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/compiler_depend.make

# Include the progress variables for this target.
include tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/progress.make

# Include the compile flags for this target's objects.
include tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/flags.make

tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.o: tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/flags.make
tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.o: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/llvm-objcopy/llvm-objcopy.cpp
tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.o: tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.o"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/llvm-objcopy && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.o -MF CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.o.d -o CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.o -c /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/llvm-objcopy/llvm-objcopy.cpp

tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.i"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/llvm-objcopy && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/llvm-objcopy/llvm-objcopy.cpp > CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.i

tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.s"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/llvm-objcopy && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/llvm-objcopy/llvm-objcopy.cpp -o CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.s

tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/Object.cpp.o: tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/flags.make
tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/Object.cpp.o: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/llvm-objcopy/Object.cpp
tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/Object.cpp.o: tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/Object.cpp.o"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/llvm-objcopy && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/Object.cpp.o -MF CMakeFiles/llvm-objcopy.dir/Object.cpp.o.d -o CMakeFiles/llvm-objcopy.dir/Object.cpp.o -c /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/llvm-objcopy/Object.cpp

tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/Object.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/llvm-objcopy.dir/Object.cpp.i"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/llvm-objcopy && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/llvm-objcopy/Object.cpp > CMakeFiles/llvm-objcopy.dir/Object.cpp.i

tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/Object.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/llvm-objcopy.dir/Object.cpp.s"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/llvm-objcopy && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/llvm-objcopy/Object.cpp -o CMakeFiles/llvm-objcopy.dir/Object.cpp.s

# Object files for target llvm-objcopy
llvm__objcopy_OBJECTS = \
"CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.o" \
"CMakeFiles/llvm-objcopy.dir/Object.cpp.o"

# External object files for target llvm-objcopy
llvm__objcopy_EXTERNAL_OBJECTS =

bin/llvm-objcopy: tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/llvm-objcopy.cpp.o
bin/llvm-objcopy: tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/Object.cpp.o
bin/llvm-objcopy: tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/build.make
bin/llvm-objcopy: lib/libLLVM-7.0svn.so
bin/llvm-objcopy: tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX executable ../../bin/llvm-objcopy"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/llvm-objcopy && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/llvm-objcopy.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/build: bin/llvm-objcopy
.PHONY : tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/build

tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/clean:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/llvm-objcopy && $(CMAKE_COMMAND) -P CMakeFiles/llvm-objcopy.dir/cmake_clean.cmake
.PHONY : tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/clean

tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/depend:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/llvm-objcopy /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/llvm-objcopy /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : tools/llvm-objcopy/CMakeFiles/llvm-objcopy.dir/depend
