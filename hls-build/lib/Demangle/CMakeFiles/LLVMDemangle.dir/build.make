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
include lib/Demangle/CMakeFiles/LLVMDemangle.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include lib/Demangle/CMakeFiles/LLVMDemangle.dir/compiler_depend.make

# Include the progress variables for this target.
include lib/Demangle/CMakeFiles/LLVMDemangle.dir/progress.make

# Include the compile flags for this target's objects.
include lib/Demangle/CMakeFiles/LLVMDemangle.dir/flags.make

lib/Demangle/CMakeFiles/LLVMDemangle.dir/Demangle.cpp.o: lib/Demangle/CMakeFiles/LLVMDemangle.dir/flags.make
lib/Demangle/CMakeFiles/LLVMDemangle.dir/Demangle.cpp.o: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/Demangle.cpp
lib/Demangle/CMakeFiles/LLVMDemangle.dir/Demangle.cpp.o: lib/Demangle/CMakeFiles/LLVMDemangle.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object lib/Demangle/CMakeFiles/LLVMDemangle.dir/Demangle.cpp.o"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -std=c++14 -MD -MT lib/Demangle/CMakeFiles/LLVMDemangle.dir/Demangle.cpp.o -MF CMakeFiles/LLVMDemangle.dir/Demangle.cpp.o.d -o CMakeFiles/LLVMDemangle.dir/Demangle.cpp.o -c /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/Demangle.cpp

lib/Demangle/CMakeFiles/LLVMDemangle.dir/Demangle.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/LLVMDemangle.dir/Demangle.cpp.i"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -std=c++14 -E /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/Demangle.cpp > CMakeFiles/LLVMDemangle.dir/Demangle.cpp.i

lib/Demangle/CMakeFiles/LLVMDemangle.dir/Demangle.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/LLVMDemangle.dir/Demangle.cpp.s"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -std=c++14 -S /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/Demangle.cpp -o CMakeFiles/LLVMDemangle.dir/Demangle.cpp.s

lib/Demangle/CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o: lib/Demangle/CMakeFiles/LLVMDemangle.dir/flags.make
lib/Demangle/CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/ItaniumDemangle.cpp
lib/Demangle/CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o: lib/Demangle/CMakeFiles/LLVMDemangle.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object lib/Demangle/CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -std=c++14 -MD -MT lib/Demangle/CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o -MF CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o.d -o CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o -c /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/ItaniumDemangle.cpp

lib/Demangle/CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.i"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -std=c++14 -E /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/ItaniumDemangle.cpp > CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.i

lib/Demangle/CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.s"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -std=c++14 -S /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/ItaniumDemangle.cpp -o CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.s

lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.o: lib/Demangle/CMakeFiles/LLVMDemangle.dir/flags.make
lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.o: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/MicrosoftDemangle.cpp
lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.o: lib/Demangle/CMakeFiles/LLVMDemangle.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.o"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.o -MF CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.o.d -o CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.o -c /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/MicrosoftDemangle.cpp

lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.i"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/MicrosoftDemangle.cpp > CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.i

lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.s"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/MicrosoftDemangle.cpp -o CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.s

lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.o: lib/Demangle/CMakeFiles/LLVMDemangle.dir/flags.make
lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.o: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/MicrosoftDemangleNodes.cpp
lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.o: lib/Demangle/CMakeFiles/LLVMDemangle.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.o"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.o -MF CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.o.d -o CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.o -c /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/MicrosoftDemangleNodes.cpp

lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.i"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/MicrosoftDemangleNodes.cpp > CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.i

lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.s"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/MicrosoftDemangleNodes.cpp -o CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.s

lib/Demangle/CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.o: lib/Demangle/CMakeFiles/LLVMDemangle.dir/flags.make
lib/Demangle/CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.o: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/RustDemangle.cpp
lib/Demangle/CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.o: lib/Demangle/CMakeFiles/LLVMDemangle.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object lib/Demangle/CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.o"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT lib/Demangle/CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.o -MF CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.o.d -o CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.o -c /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/RustDemangle.cpp

lib/Demangle/CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.i"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/RustDemangle.cpp > CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.i

lib/Demangle/CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.s"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && /usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle/RustDemangle.cpp -o CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.s

# Object files for target LLVMDemangle
LLVMDemangle_OBJECTS = \
"CMakeFiles/LLVMDemangle.dir/Demangle.cpp.o" \
"CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o" \
"CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.o" \
"CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.o" \
"CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.o"

# External object files for target LLVMDemangle
LLVMDemangle_EXTERNAL_OBJECTS =

lib/libLLVMDemangle.a: lib/Demangle/CMakeFiles/LLVMDemangle.dir/Demangle.cpp.o
lib/libLLVMDemangle.a: lib/Demangle/CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o
lib/libLLVMDemangle.a: lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangle.cpp.o
lib/libLLVMDemangle.a: lib/Demangle/CMakeFiles/LLVMDemangle.dir/MicrosoftDemangleNodes.cpp.o
lib/libLLVMDemangle.a: lib/Demangle/CMakeFiles/LLVMDemangle.dir/RustDemangle.cpp.o
lib/libLLVMDemangle.a: lib/Demangle/CMakeFiles/LLVMDemangle.dir/build.make
lib/libLLVMDemangle.a: lib/Demangle/CMakeFiles/LLVMDemangle.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Linking CXX static library ../libLLVMDemangle.a"
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && $(CMAKE_COMMAND) -P CMakeFiles/LLVMDemangle.dir/cmake_clean_target.cmake
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/LLVMDemangle.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
lib/Demangle/CMakeFiles/LLVMDemangle.dir/build: lib/libLLVMDemangle.a
.PHONY : lib/Demangle/CMakeFiles/LLVMDemangle.dir/build

lib/Demangle/CMakeFiles/LLVMDemangle.dir/clean:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle && $(CMAKE_COMMAND) -P CMakeFiles/LLVMDemangle.dir/cmake_clean.cmake
.PHONY : lib/Demangle/CMakeFiles/LLVMDemangle.dir/clean

lib/Demangle/CMakeFiles/LLVMDemangle.dir/depend:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/Demangle /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle/CMakeFiles/LLVMDemangle.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : lib/Demangle/CMakeFiles/LLVMDemangle.dir/depend
