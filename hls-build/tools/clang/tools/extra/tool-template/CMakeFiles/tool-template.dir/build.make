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
include tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/compiler_depend.make

# Include the progress variables for this target.
include tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/progress.make

# Include the compile flags for this target's objects.
include tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/flags.make

tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/ToolTemplate.cpp.o: tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/flags.make
tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/ToolTemplate.cpp.o: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang-tools-extra/tool-template/ToolTemplate.cpp
tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/ToolTemplate.cpp.o: tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/ToolTemplate.cpp.o"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/extra/tool-template && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/ToolTemplate.cpp.o -MF CMakeFiles/tool-template.dir/ToolTemplate.cpp.o.d -o CMakeFiles/tool-template.dir/ToolTemplate.cpp.o -c /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang-tools-extra/tool-template/ToolTemplate.cpp

tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/ToolTemplate.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/tool-template.dir/ToolTemplate.cpp.i"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/extra/tool-template && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang-tools-extra/tool-template/ToolTemplate.cpp > CMakeFiles/tool-template.dir/ToolTemplate.cpp.i

tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/ToolTemplate.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/tool-template.dir/ToolTemplate.cpp.s"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/extra/tool-template && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang-tools-extra/tool-template/ToolTemplate.cpp -o CMakeFiles/tool-template.dir/ToolTemplate.cpp.s

# Object files for target tool-template
tool__template_OBJECTS = \
"CMakeFiles/tool-template.dir/ToolTemplate.cpp.o"

# External object files for target tool-template
tool__template_EXTERNAL_OBJECTS =

bin/tool-template: tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/ToolTemplate.cpp.o
bin/tool-template: tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/build.make
bin/tool-template: lib/libclangAST.a
bin/tool-template: lib/libclangASTMatchers.a
bin/tool-template: lib/libclangBasic.a
bin/tool-template: lib/libclangFrontend.a
bin/tool-template: lib/libclangTooling.a
bin/tool-template: lib/libclangToolingRefactor.a
bin/tool-template: lib/libclangASTMatchers.a
bin/tool-template: lib/libclangIndex.a
bin/tool-template: lib/libclangFrontend.a
bin/tool-template: lib/libclangDriver.a
bin/tool-template: lib/libclangParse.a
bin/tool-template: lib/libclangSerialization.a
bin/tool-template: lib/libclangSema.a
bin/tool-template: lib/libclangEdit.a
bin/tool-template: lib/libclangAnalysis.a
bin/tool-template: lib/libclangFormat.a
bin/tool-template: lib/libclangToolingCore.a
bin/tool-template: lib/libclangAST.a
bin/tool-template: lib/libclangRewrite.a
bin/tool-template: lib/libclangLex.a
bin/tool-template: lib/libclangBasic.a
bin/tool-template: lib/libLLVM-7.0svn.so
bin/tool-template: tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../../../../../bin/tool-template"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/extra/tool-template && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/tool-template.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/build: bin/tool-template
.PHONY : tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/build

tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/clean:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/extra/tool-template && $(CMAKE_COMMAND) -P CMakeFiles/tool-template.dir/cmake_clean.cmake
.PHONY : tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/clean

tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/depend:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/clang-tools-extra/tool-template /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/extra/tool-template /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : tools/clang/tools/extra/tool-template/CMakeFiles/tool-template.dir/depend
