# Install script for directory: /usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/llvm/unittests/DebugInfo

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/hls-install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "0")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/unittests/DebugInfo/CodeView/cmake_install.cmake")
  include("/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/unittests/DebugInfo/DWARF/cmake_install.cmake")
  include("/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/unittests/DebugInfo/MSF/cmake_install.cmake")
  include("/usr/scratch/jkim3998/bc_test/fccm2025_artifact_eval/llvm-project/hls-build/unittests/DebugInfo/PDB/cmake_install.cmake")

endif()

