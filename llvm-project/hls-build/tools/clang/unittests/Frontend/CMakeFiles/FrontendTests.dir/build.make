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
include tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/compiler_depend.make

# Include the progress variables for this target.
include tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/progress.make

# Include the compile flags for this target's objects.
include tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/flags.make

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.o: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/flags.make
tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/ASTUnitTest.cpp
tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.o: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.o -MF CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.o.d -o CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/ASTUnitTest.cpp

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/ASTUnitTest.cpp > CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.i

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/ASTUnitTest.cpp -o CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.s

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.o: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/flags.make
tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/CompilerInstanceTest.cpp
tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.o: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.o -MF CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.o.d -o CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/CompilerInstanceTest.cpp

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/CompilerInstanceTest.cpp > CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.i

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/CompilerInstanceTest.cpp -o CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.s

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.o: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/flags.make
tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/FrontendActionTest.cpp
tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.o: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.o -MF CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.o.d -o CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/FrontendActionTest.cpp

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/FrontendActionTest.cpp > CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.i

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/FrontendActionTest.cpp -o CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.s

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.o: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/flags.make
tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/CodeGenActionTest.cpp
tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.o: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.o -MF CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.o.d -o CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/CodeGenActionTest.cpp

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/CodeGenActionTest.cpp > CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.i

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/CodeGenActionTest.cpp -o CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.s

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.o: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/flags.make
tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/ParsedSourceLocationTest.cpp
tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.o: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.o -MF CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.o.d -o CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/ParsedSourceLocationTest.cpp

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/ParsedSourceLocationTest.cpp > CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.i

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/ParsedSourceLocationTest.cpp -o CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.s

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.o: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/flags.make
tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/PCHPreambleTest.cpp
tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.o: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.o -MF CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.o.d -o CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/PCHPreambleTest.cpp

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/PCHPreambleTest.cpp > CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.i

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend/PCHPreambleTest.cpp -o CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.s

# Object files for target FrontendTests
FrontendTests_OBJECTS = \
"CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.o" \
"CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.o" \
"CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.o" \
"CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.o" \
"CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.o" \
"CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.o"

# External object files for target FrontendTests
FrontendTests_EXTERNAL_OBJECTS =

tools/clang/unittests/Frontend/FrontendTests: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ASTUnitTest.cpp.o
tools/clang/unittests/Frontend/FrontendTests: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CompilerInstanceTest.cpp.o
tools/clang/unittests/Frontend/FrontendTests: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/FrontendActionTest.cpp.o
tools/clang/unittests/Frontend/FrontendTests: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/CodeGenActionTest.cpp.o
tools/clang/unittests/Frontend/FrontendTests: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/ParsedSourceLocationTest.cpp.o
tools/clang/unittests/Frontend/FrontendTests: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/PCHPreambleTest.cpp.o
tools/clang/unittests/Frontend/FrontendTests: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/build.make
tools/clang/unittests/Frontend/FrontendTests: lib/libgtest_main.a
tools/clang/unittests/Frontend/FrontendTests: lib/libgtest.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangAST.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangBasic.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangFrontend.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangLex.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangSema.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangCodeGen.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangFrontend.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangDriver.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangParse.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangSerialization.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangSema.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangEdit.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangAnalysis.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangAST.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangLex.a
tools/clang/unittests/Frontend/FrontendTests: lib/libclangBasic.a
tools/clang/unittests/Frontend/FrontendTests: lib/libLLVM-7.0svn.so
tools/clang/unittests/Frontend/FrontendTests: tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Linking CXX executable FrontendTests"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/FrontendTests.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/build: tools/clang/unittests/Frontend/FrontendTests
.PHONY : tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/build

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/clean:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend && $(CMAKE_COMMAND) -P CMakeFiles/FrontendTests.dir/cmake_clean.cmake
.PHONY : tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/clean

tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/depend:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/unittests/Frontend /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tools/clang/unittests/Frontend/CMakeFiles/FrontendTests.dir/depend

