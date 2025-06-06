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
include unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/compiler_depend.make

# Include the progress variables for this target.
include unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/progress.make

# Include the compile flags for this target's objects.
include unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/flags.make

unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.o: unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/flags.make
unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/unittests/Transforms/IPO/LowerTypeTests.cpp
unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.o: unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/unittests/Transforms/IPO && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.o -MF CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.o.d -o CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/unittests/Transforms/IPO/LowerTypeTests.cpp

unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/unittests/Transforms/IPO && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/unittests/Transforms/IPO/LowerTypeTests.cpp > CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.i

unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/unittests/Transforms/IPO && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/unittests/Transforms/IPO/LowerTypeTests.cpp -o CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.s

unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.o: unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/flags.make
unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/unittests/Transforms/IPO/WholeProgramDevirt.cpp
unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.o: unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/unittests/Transforms/IPO && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.o -MF CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.o.d -o CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/unittests/Transforms/IPO/WholeProgramDevirt.cpp

unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/unittests/Transforms/IPO && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/unittests/Transforms/IPO/WholeProgramDevirt.cpp > CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.i

unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/unittests/Transforms/IPO && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/unittests/Transforms/IPO/WholeProgramDevirt.cpp -o CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.s

# Object files for target IPOTests
IPOTests_OBJECTS = \
"CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.o" \
"CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.o"

# External object files for target IPOTests
IPOTests_EXTERNAL_OBJECTS =

unittests/Transforms/IPO/IPOTests: unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/LowerTypeTests.cpp.o
unittests/Transforms/IPO/IPOTests: unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/WholeProgramDevirt.cpp.o
unittests/Transforms/IPO/IPOTests: unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/build.make
unittests/Transforms/IPO/IPOTests: lib/libgtest_main.a
unittests/Transforms/IPO/IPOTests: lib/libgtest.a
unittests/Transforms/IPO/IPOTests: lib/libLLVM-7.0svn.so
unittests/Transforms/IPO/IPOTests: unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX executable IPOTests"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/unittests/Transforms/IPO && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/IPOTests.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/build: unittests/Transforms/IPO/IPOTests
.PHONY : unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/build

unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/clean:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/unittests/Transforms/IPO && $(CMAKE_COMMAND) -P CMakeFiles/IPOTests.dir/cmake_clean.cmake
.PHONY : unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/clean

unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/depend:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/unittests/Transforms/IPO /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/unittests/Transforms/IPO /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : unittests/Transforms/IPO/CMakeFiles/IPOTests.dir/depend

