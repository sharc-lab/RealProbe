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
include lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/compiler_depend.make

# Include the progress variables for this target.
include lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/progress.make

# Include the compile flags for this target's objects.
include lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/flags.make

lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/Error.cpp.o: lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/flags.make
lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/Error.cpp.o: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Testing/Support/Error.cpp
lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/Error.cpp.o: lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/Error.cpp.o"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Testing/Support && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/Error.cpp.o -MF CMakeFiles/LLVMTestingSupport.dir/Error.cpp.o.d -o CMakeFiles/LLVMTestingSupport.dir/Error.cpp.o -c /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Testing/Support/Error.cpp

lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/Error.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/LLVMTestingSupport.dir/Error.cpp.i"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Testing/Support && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Testing/Support/Error.cpp > CMakeFiles/LLVMTestingSupport.dir/Error.cpp.i

lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/Error.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/LLVMTestingSupport.dir/Error.cpp.s"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Testing/Support && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Testing/Support/Error.cpp -o CMakeFiles/LLVMTestingSupport.dir/Error.cpp.s

# Object files for target LLVMTestingSupport
LLVMTestingSupport_OBJECTS = \
"CMakeFiles/LLVMTestingSupport.dir/Error.cpp.o"

# External object files for target LLVMTestingSupport
LLVMTestingSupport_EXTERNAL_OBJECTS =

lib/libLLVMTestingSupport.a: lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/Error.cpp.o
lib/libLLVMTestingSupport.a: lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/build.make
lib/libLLVMTestingSupport.a: lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library ../../libLLVMTestingSupport.a"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Testing/Support && $(CMAKE_COMMAND) -P CMakeFiles/LLVMTestingSupport.dir/cmake_clean_target.cmake
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Testing/Support && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/LLVMTestingSupport.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/build: lib/libLLVMTestingSupport.a
.PHONY : lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/build

lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/clean:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Testing/Support && $(CMAKE_COMMAND) -P CMakeFiles/LLVMTestingSupport.dir/cmake_clean.cmake
.PHONY : lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/clean

lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/depend:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Testing/Support /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Testing/Support /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : lib/Testing/Support/CMakeFiles/LLVMTestingSupport.dir/depend
