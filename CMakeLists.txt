# ======================================================================
#  art main build file
#
#  cd .../path/to/build/directory
#  source .../path/to/art/ups/setup_for_development
#  cmake [-DCMAKE_INSTALL_PREFIX=/install/path]
#        -DCMAKE_BUILD_TYPE=$CETPKG_TYPE
#        $CETPKG_SOURCE
#  make
#  make test
#  make install
#  make package (builds distribution tarfile)
# ======================================================================
# Required to keep CMake happy.
cmake_minimum_required(VERSION ${CMAKE_VERSION} FATAL_ERROR)
# Actual version requirement.
cmake_policy(VERSION 3.4)

# Project information.
project(canvas_root_io VERSION 1.01.06 LANGUAGES CXX)

# cetmodules contains our cmake modules
find_package(cetmodules REQUIRED)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/Modules)

include(CetCMakeEnv)
cet_cmake_env()

cet_set_compiler_flags(DIAGS VIGILANT
  WERROR
  NO_UNDEFINED
  EXTRA_FLAGS -pedantic
  EXTRA_CXX_FLAGS -Wnon-virtual-dtor -Wdelete-non-virtual-dtor
  )

cet_report_compiler_flags()

find_package(canvas REQUIRED)
find_package(cetlib_except REQUIRED)
find_package(fhiclcpp REQUIRED)
find_package(messagefacility REQUIRED)
find_package(TBB REQUIRED)
set(TBB "TBB::tbb")
find_package(CLHEP COMPONENTS Matrix Vector REQUIRED)
include_directories(${CLHEP_INCLUDE_DIRS})
find_package(ROOT REQUIRED COMPONENTS)
find_package(Boost COMPONENTS thread REQUIRED)

# art_dictionary
include(ArtDictionary)

# source
add_subdirectory(canvas_root_io)

# ups - table and config files
add_subdirectory(ups)

# CMake modules
add_subdirectory(Modules)

# tools - e.g. migration scripts
add_subdirectory(tools)
