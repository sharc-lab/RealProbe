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
include tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/compiler_depend.make

# Include the progress variables for this target.
include tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/progress.make

# Include the compile flags for this target's objects.
include tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/flags.make

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.o: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/flags.make
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/DefaultArgumentsCheck.cpp
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.o: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.o -MF CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.o.d -o CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/DefaultArgumentsCheck.cpp

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/DefaultArgumentsCheck.cpp > CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.i

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/DefaultArgumentsCheck.cpp -o CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.s

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.o: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/flags.make
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/FuchsiaTidyModule.cpp
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.o: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.o -MF CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.o.d -o CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/FuchsiaTidyModule.cpp

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/FuchsiaTidyModule.cpp > CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.i

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/FuchsiaTidyModule.cpp -o CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.s

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.o: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/flags.make
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/MultipleInheritanceCheck.cpp
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.o: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.o -MF CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.o.d -o CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/MultipleInheritanceCheck.cpp

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/MultipleInheritanceCheck.cpp > CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.i

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/MultipleInheritanceCheck.cpp -o CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.s

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.o: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/flags.make
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/OverloadedOperatorCheck.cpp
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.o: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.o -MF CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.o.d -o CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/OverloadedOperatorCheck.cpp

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/OverloadedOperatorCheck.cpp > CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.i

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/OverloadedOperatorCheck.cpp -o CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.s

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.o: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/flags.make
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/StaticallyConstructedObjectsCheck.cpp
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.o: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.o -MF CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.o.d -o CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/StaticallyConstructedObjectsCheck.cpp

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/StaticallyConstructedObjectsCheck.cpp > CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.i

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/StaticallyConstructedObjectsCheck.cpp -o CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.s

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.o: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/flags.make
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/TrailingReturnCheck.cpp
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.o: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.o -MF CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.o.d -o CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/TrailingReturnCheck.cpp

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/TrailingReturnCheck.cpp > CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.i

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/TrailingReturnCheck.cpp -o CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.s

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.o: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/flags.make
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/VirtualInheritanceCheck.cpp
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.o: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building CXX object tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.o -MF CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.o.d -o CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/VirtualInheritanceCheck.cpp

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/VirtualInheritanceCheck.cpp > CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.i

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia/VirtualInheritanceCheck.cpp -o CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.s

# Object files for target clangTidyFuchsiaModule
clangTidyFuchsiaModule_OBJECTS = \
"CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.o" \
"CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.o" \
"CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.o" \
"CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.o" \
"CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.o" \
"CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.o" \
"CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.o"

# External object files for target clangTidyFuchsiaModule
clangTidyFuchsiaModule_EXTERNAL_OBJECTS =

lib/libclangTidyFuchsiaModule.a: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/DefaultArgumentsCheck.cpp.o
lib/libclangTidyFuchsiaModule.a: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/FuchsiaTidyModule.cpp.o
lib/libclangTidyFuchsiaModule.a: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/MultipleInheritanceCheck.cpp.o
lib/libclangTidyFuchsiaModule.a: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/OverloadedOperatorCheck.cpp.o
lib/libclangTidyFuchsiaModule.a: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/StaticallyConstructedObjectsCheck.cpp.o
lib/libclangTidyFuchsiaModule.a: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/TrailingReturnCheck.cpp.o
lib/libclangTidyFuchsiaModule.a: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/VirtualInheritanceCheck.cpp.o
lib/libclangTidyFuchsiaModule.a: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/build.make
lib/libclangTidyFuchsiaModule.a: tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Linking CXX static library ../../../../../../lib/libclangTidyFuchsiaModule.a"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && $(CMAKE_COMMAND) -P CMakeFiles/clangTidyFuchsiaModule.dir/cmake_clean_target.cmake
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/clangTidyFuchsiaModule.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/build: lib/libclangTidyFuchsiaModule.a
.PHONY : tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/build

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/clean:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia && $(CMAKE_COMMAND) -P CMakeFiles/clangTidyFuchsiaModule.dir/cmake_clean.cmake
.PHONY : tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/clean

tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/depend:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang-tools-extra/clang-tidy/fuchsia /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tools/clang/tools/extra/clang-tidy/fuchsia/CMakeFiles/clangTidyFuchsiaModule.dir/depend

