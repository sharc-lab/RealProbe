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
include tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/compiler_depend.make

# Include the progress variables for this target.
include tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/progress.make

# Include the compile flags for this target's objects.
include tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/flags.make

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/DeltaTree.cpp.o: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/flags.make
tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/DeltaTree.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/DeltaTree.cpp
tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/DeltaTree.cpp.o: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/DeltaTree.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/DeltaTree.cpp.o -MF CMakeFiles/clangRewrite.dir/DeltaTree.cpp.o.d -o CMakeFiles/clangRewrite.dir/DeltaTree.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/DeltaTree.cpp

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/DeltaTree.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/clangRewrite.dir/DeltaTree.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/DeltaTree.cpp > CMakeFiles/clangRewrite.dir/DeltaTree.cpp.i

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/DeltaTree.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/clangRewrite.dir/DeltaTree.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/DeltaTree.cpp -o CMakeFiles/clangRewrite.dir/DeltaTree.cpp.s

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.o: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/flags.make
tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/HTMLRewrite.cpp
tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.o: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.o -MF CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.o.d -o CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/HTMLRewrite.cpp

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/HTMLRewrite.cpp > CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.i

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/HTMLRewrite.cpp -o CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.s

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/RewriteRope.cpp.o: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/flags.make
tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/RewriteRope.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/RewriteRope.cpp
tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/RewriteRope.cpp.o: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/RewriteRope.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/RewriteRope.cpp.o -MF CMakeFiles/clangRewrite.dir/RewriteRope.cpp.o.d -o CMakeFiles/clangRewrite.dir/RewriteRope.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/RewriteRope.cpp

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/RewriteRope.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/clangRewrite.dir/RewriteRope.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/RewriteRope.cpp > CMakeFiles/clangRewrite.dir/RewriteRope.cpp.i

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/RewriteRope.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/clangRewrite.dir/RewriteRope.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/RewriteRope.cpp -o CMakeFiles/clangRewrite.dir/RewriteRope.cpp.s

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/Rewriter.cpp.o: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/flags.make
tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/Rewriter.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/Rewriter.cpp
tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/Rewriter.cpp.o: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/Rewriter.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/Rewriter.cpp.o -MF CMakeFiles/clangRewrite.dir/Rewriter.cpp.o.d -o CMakeFiles/clangRewrite.dir/Rewriter.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/Rewriter.cpp

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/Rewriter.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/clangRewrite.dir/Rewriter.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/Rewriter.cpp > CMakeFiles/clangRewrite.dir/Rewriter.cpp.i

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/Rewriter.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/clangRewrite.dir/Rewriter.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/Rewriter.cpp -o CMakeFiles/clangRewrite.dir/Rewriter.cpp.s

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.o: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/flags.make
tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.o: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/TokenRewriter.cpp
tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.o: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.o"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.o -MF CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.o.d -o CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.o -c /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/TokenRewriter.cpp

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.i"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/TokenRewriter.cpp > CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.i

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.s"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite/TokenRewriter.cpp -o CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.s

# Object files for target clangRewrite
clangRewrite_OBJECTS = \
"CMakeFiles/clangRewrite.dir/DeltaTree.cpp.o" \
"CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.o" \
"CMakeFiles/clangRewrite.dir/RewriteRope.cpp.o" \
"CMakeFiles/clangRewrite.dir/Rewriter.cpp.o" \
"CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.o"

# External object files for target clangRewrite
clangRewrite_EXTERNAL_OBJECTS =

lib/libclangRewrite.a: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/DeltaTree.cpp.o
lib/libclangRewrite.a: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/HTMLRewrite.cpp.o
lib/libclangRewrite.a: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/RewriteRope.cpp.o
lib/libclangRewrite.a: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/Rewriter.cpp.o
lib/libclangRewrite.a: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/TokenRewriter.cpp.o
lib/libclangRewrite.a: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/build.make
lib/libclangRewrite.a: tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Linking CXX static library ../../../../lib/libclangRewrite.a"
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && $(CMAKE_COMMAND) -P CMakeFiles/clangRewrite.dir/cmake_clean_target.cmake
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/clangRewrite.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/build: lib/libclangRewrite.a
.PHONY : tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/build

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/clean:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite && $(CMAKE_COMMAND) -P CMakeFiles/clangRewrite.dir/cmake_clean.cmake
.PHONY : tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/clean

tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/depend:
	cd /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/clang/lib/Rewrite /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tools/clang/lib/Rewrite/CMakeFiles/clangRewrite.dir/depend

