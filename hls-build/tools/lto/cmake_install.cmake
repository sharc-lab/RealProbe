# Install script for directory: /usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/tools/lto

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
  set(CMAKE_OBJDUMP "/usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "LTO" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/libLTO.so.7.0.0svn"
    "/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/libLTO.so.7"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libLTO.so.7.0.0svn"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libLTO.so.7"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/usr/scratch/jkim3998/.conda/dst_jiho/hlsllvm/bin/x86_64-conda-linux-gnu-strip" "${file}")
      endif()
    endif()
  endforeach()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "LTO" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/hls-build/lib/libLTO.so")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "LTO" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/llvm-c" TYPE FILE FILES "/usr/scratch/jkim3998/hls-llvm-project-realprobe/hls-llvm-project/llvm/include/llvm-c/lto.h")
endif()
