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

# Utility rule file for AttributeCompatFuncTableGen.

# Include any custom commands dependencies for this target.
include lib/IR/CMakeFiles/AttributeCompatFuncTableGen.dir/compiler_depend.make

# Include the progress variables for this target.
include lib/IR/CMakeFiles/AttributeCompatFuncTableGen.dir/progress.make

lib/IR/CMakeFiles/AttributeCompatFuncTableGen: lib/IR/AttributesCompatFunc.inc

lib/IR/AttributesCompatFunc.inc: lib/IR/AttributesCompatFunc.inc.tmp
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Updating AttributesCompatFunc.inc..."
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/IR && /export/hdd/scratch/jkim3998/.conda/dst_jiho/hlsllvm/lib/python3.12/site-packages/cmake/data/bin/cmake -E copy_if_different /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/IR/AttributesCompatFunc.inc.tmp /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/IR/AttributesCompatFunc.inc

lib/IR/AttributesCompatFunc.inc.tmp: bin/llvm-tblgen
lib/IR/AttributesCompatFunc.inc.tmp: bin/llvm-tblgen
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/IR/AttributesCompatFunc.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/CodeGen/SDNodeProperties.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/CodeGen/ValueTypes.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/Attributes.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/Intrinsics.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/IntrinsicsAArch64.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/IntrinsicsAMDGPU.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/IntrinsicsARM.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/IntrinsicsBPF.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/IntrinsicsFPGA.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/IntrinsicsHexagon.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/IntrinsicsMips.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/IntrinsicsNVVM.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/IntrinsicsPowerPC.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/IntrinsicsSPIR.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/IntrinsicsSystemZ.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/IntrinsicsWebAssembly.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/IntrinsicsX86.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/IR/IntrinsicsXCore.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/Option/OptParser.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/TableGen/SearchableTable.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/Target/GenericOpcodes.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/Target/GlobalISel/RegisterBank.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/Target/GlobalISel/SelectionDAGCompat.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/Target/GlobalISel/Target.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/Target/Target.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/Target/TargetCallingConv.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/Target/TargetItinerary.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/Target/TargetSchedule.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm/Target/TargetSelectionDAG.td
lib/IR/AttributesCompatFunc.inc.tmp: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/IR/AttributesCompatFunc.td
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building AttributesCompatFunc.inc..."
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/IR && ../../bin/llvm-tblgen -gen-attrs -I /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/IR -I /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/IR/AttributesCompatFunc.td -o /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/IR/AttributesCompatFunc.inc.tmp

AttributeCompatFuncTableGen: lib/IR/AttributesCompatFunc.inc
AttributeCompatFuncTableGen: lib/IR/AttributesCompatFunc.inc.tmp
AttributeCompatFuncTableGen: lib/IR/CMakeFiles/AttributeCompatFuncTableGen
AttributeCompatFuncTableGen: lib/IR/CMakeFiles/AttributeCompatFuncTableGen.dir/build.make
.PHONY : AttributeCompatFuncTableGen

# Rule to build all files generated by this target.
lib/IR/CMakeFiles/AttributeCompatFuncTableGen.dir/build: AttributeCompatFuncTableGen
.PHONY : lib/IR/CMakeFiles/AttributeCompatFuncTableGen.dir/build

lib/IR/CMakeFiles/AttributeCompatFuncTableGen.dir/clean:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/IR && $(CMAKE_COMMAND) -P CMakeFiles/AttributeCompatFuncTableGen.dir/cmake_clean.cmake
.PHONY : lib/IR/CMakeFiles/AttributeCompatFuncTableGen.dir/clean

lib/IR/CMakeFiles/AttributeCompatFuncTableGen.dir/depend:
	cd /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/lib/IR /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/IR /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/IR/CMakeFiles/AttributeCompatFuncTableGen.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : lib/IR/CMakeFiles/AttributeCompatFuncTableGen.dir/depend
