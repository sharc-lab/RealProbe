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
include tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/compiler_depend.make

# Include the progress variables for this target.
include tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/progress.make

# Include the compile flags for this target's objects.
include tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/flags.make

tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.o: tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/flags.make
tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/tools/llvm-isel-fuzzer/DummyISelFuzzer.cpp
tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.o: tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/llvm-isel-fuzzer && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.o -MF CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.o.d -o CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/tools/llvm-isel-fuzzer/DummyISelFuzzer.cpp

tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/llvm-isel-fuzzer && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/tools/llvm-isel-fuzzer/DummyISelFuzzer.cpp > CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.i

tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/llvm-isel-fuzzer && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/tools/llvm-isel-fuzzer/DummyISelFuzzer.cpp -o CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.s

tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.o: tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/flags.make
tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/tools/llvm-isel-fuzzer/llvm-isel-fuzzer.cpp
tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.o: tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/llvm-isel-fuzzer && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.o -MF CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.o.d -o CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/tools/llvm-isel-fuzzer/llvm-isel-fuzzer.cpp

tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/llvm-isel-fuzzer && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/tools/llvm-isel-fuzzer/llvm-isel-fuzzer.cpp > CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.i

tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/llvm-isel-fuzzer && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/tools/llvm-isel-fuzzer/llvm-isel-fuzzer.cpp -o CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.s

# Object files for target llvm-isel-fuzzer
llvm__isel__fuzzer_OBJECTS = \
"CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.o" \
"CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.o"

# External object files for target llvm-isel-fuzzer
llvm__isel__fuzzer_EXTERNAL_OBJECTS =

bin/llvm-isel-fuzzer: tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/DummyISelFuzzer.cpp.o
bin/llvm-isel-fuzzer: tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/llvm-isel-fuzzer.cpp.o
bin/llvm-isel-fuzzer: tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/build.make
bin/llvm-isel-fuzzer: lib/libLLVM-7.0svn.so
bin/llvm-isel-fuzzer: tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX executable ../../bin/llvm-isel-fuzzer"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/llvm-isel-fuzzer && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/llvm-isel-fuzzer.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/build: bin/llvm-isel-fuzzer
.PHONY : tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/build

tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/clean:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/llvm-isel-fuzzer && $(CMAKE_COMMAND) -P CMakeFiles/llvm-isel-fuzzer.dir/cmake_clean.cmake
.PHONY : tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/clean

tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/depend:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/tools/llvm-isel-fuzzer /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/llvm-isel-fuzzer /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tools/llvm-isel-fuzzer/CMakeFiles/llvm-isel-fuzzer.dir/depend

