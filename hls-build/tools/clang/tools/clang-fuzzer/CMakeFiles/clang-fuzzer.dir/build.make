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
include tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/compiler_depend.make

# Include the progress variables for this target.
include tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/progress.make

# Include the compile flags for this target's objects.
include tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/flags.make

tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.o: tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/flags.make
tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.o: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang/tools/clang-fuzzer/DummyClangFuzzer.cpp
tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.o: tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.o"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/clang-fuzzer && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.o -MF CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.o.d -o CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.o -c /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang/tools/clang-fuzzer/DummyClangFuzzer.cpp

tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.i"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/clang-fuzzer && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang/tools/clang-fuzzer/DummyClangFuzzer.cpp > CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.i

tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.s"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/clang-fuzzer && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang/tools/clang-fuzzer/DummyClangFuzzer.cpp -o CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.s

tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.o: tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/flags.make
tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.o: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang/tools/clang-fuzzer/ClangFuzzer.cpp
tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.o: tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.o"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/clang-fuzzer && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.o -MF CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.o.d -o CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.o -c /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang/tools/clang-fuzzer/ClangFuzzer.cpp

tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.i"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/clang-fuzzer && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang/tools/clang-fuzzer/ClangFuzzer.cpp > CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.i

tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.s"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/clang-fuzzer && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang/tools/clang-fuzzer/ClangFuzzer.cpp -o CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.s

# Object files for target clang-fuzzer
clang__fuzzer_OBJECTS = \
"CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.o" \
"CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.o"

# External object files for target clang-fuzzer
clang__fuzzer_EXTERNAL_OBJECTS =

bin/clang-fuzzer: tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/DummyClangFuzzer.cpp.o
bin/clang-fuzzer: tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/ClangFuzzer.cpp.o
bin/clang-fuzzer: tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/build.make
bin/clang-fuzzer: lib/libclangHandleCXX.a
bin/clang-fuzzer: lib/libclangCodeGen.a
bin/clang-fuzzer: lib/libclangTooling.a
bin/clang-fuzzer: lib/libclangFrontend.a
bin/clang-fuzzer: lib/libclangParse.a
bin/clang-fuzzer: lib/libclangSerialization.a
bin/clang-fuzzer: lib/libclangSema.a
bin/clang-fuzzer: lib/libclangAnalysis.a
bin/clang-fuzzer: lib/libclangEdit.a
bin/clang-fuzzer: lib/libclangDriver.a
bin/clang-fuzzer: lib/libclangASTMatchers.a
bin/clang-fuzzer: lib/libclangFormat.a
bin/clang-fuzzer: lib/libclangToolingCore.a
bin/clang-fuzzer: lib/libclangAST.a
bin/clang-fuzzer: lib/libclangRewrite.a
bin/clang-fuzzer: lib/libclangLex.a
bin/clang-fuzzer: lib/libclangBasic.a
bin/clang-fuzzer: lib/libLLVM-7.0svn.so
bin/clang-fuzzer: tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX executable ../../../../bin/clang-fuzzer"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/clang-fuzzer && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/clang-fuzzer.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/build: bin/clang-fuzzer
.PHONY : tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/build

tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/clean:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/clang-fuzzer && $(CMAKE_COMMAND) -P CMakeFiles/clang-fuzzer.dir/cmake_clean.cmake
.PHONY : tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/clean

tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/depend:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang/tools/clang-fuzzer /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/clang-fuzzer /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : tools/clang/tools/clang-fuzzer/CMakeFiles/clang-fuzzer.dir/depend
