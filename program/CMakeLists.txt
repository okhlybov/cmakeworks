#
# Sample multiplatform CMake project to build multilanguage (C/C++/FORTRAN) program
# with optional MPI, OpenMP and PkgConfig support
#
# https://github.com/okhlybov/cmakeworks/program
#

# **** Asterisks indicate the level of importance for customization

# *
# Set up CMake compatibility level
cmake_minimum_required(VERSION 3.16) # Ninja Multi-Config requires 3.17+

### Basic project setup

# ****
# Set to project name from which the executable name will be deduced
# Specify languages the program is written in
project(program LANGUAGES C CXX Fortran)

# ****
# Instruct to create a named executable from the space-separated list of source files which consitute the program
add_executable(${PROJECT_NAME} main.c inc.c inc.cpp inc.f90)

# ****
# Link external CMake library subprojects
set(dependency library) # Specify dependency name
add_subdirectory(../${dependency} ${CMAKE_CURRENT_BINARY_DIR}/${dependency}) # Specify dependency location
target_link_libraries(${PROJECT_NAME} PUBLIC ${dependency})

# The code block is to be cloned & tailored for each present dependency
# set(dependency library2) # Specify dependency name
# add_subdirectory(../${dependency} ${CMAKE_CURRENT_BINARY_DIR}/${dependency}) # Specify dependency location
# target_link_libraries(${PROJECT_NAME} PUBLIC ${dependency})

# ***
# Set to the space-separated list of dependent PkgConfig modules
set(PKG_CONFIG_MODULES gmp)

# **
# If set, accounts for static linking (forces setting the USE_MODULE_STATIC_LINKING option)
set(USE_STATIC_LINKING OFF)

# ****
# If set, instruct the build system to compile sources with MPI-aware compiler drivers
# and to link against the appropriate libraries
set(USE_MPI OFF)

# ****
# If set, instruct the build system to emit OpenMP support flags
set(USE_OPENMP OFF)

### Advanced project configuration

# ***
# Enforce language-specific standards
target_compile_features(${PROJECT_NAME} PRIVATE c_std_99 cxx_std_11)

# *
# Specify space-separated list of additional include directories specified as -I command line arguments
# Current directory is considered to contain a public interface and hence is already included by the CMakeWorks common code
# target_include_directories(${PROJECT_NAME} PRIVATE .)

# **
# Specify space-separated list of preprocessor macro definitions specified as -D command line arguments
target_compile_definitions(${PROJECT_NAME} PRIVATE EXE_FOO=EXE_BAR)

# *
# Specify GCC-specific optimization flags
# Set it to empty string or comment it out to revert to default configuration behavior
set(GNU_RELEASE_FLAGS "-pipe -O3 -Wall -pedantic")

# *
# Specify GCC-specific debugging flags
# Set it to empty string or comment it out to revert to default configuration behavior
set(GNU_DEBUG_FLAGS "-pipe -g -Og -Wall -pedantic")

# Slurp in the common logics code
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(CMakeWorks)