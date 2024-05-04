# Install script for directory: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/hls-install")
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
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Demangle/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/Support/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/TableGen/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/utils/TableGen/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/include/llvm/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/utils/FileCheck/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/utils/PerfectShuffle/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/utils/count/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/utils/not/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/utils/yaml-bench/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/projects/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/tools/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/runtimes/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/examples/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/utils/lit/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/test/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/unittests/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/utils/unittest/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/docs/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/cmake/modules/cmake_install.cmake")
  include("/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/utils/llvm-lit/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
