#
# Sample multiplatform CMake project to build multilanguage (C/C++/FORTRAN) library
# with optional MPI, OpenMP and PkgConfig support
#
# https://github.com/okhlybov/cmakeworks/library
#

# **** Asterisks indicate the level of importance for customization

# *
# Set up CMake compatibility level
cmake_minimum_required(VERSION 3.16) # Ninja Multi-Config requires 3.17+

### Basic project setup

# ****
# Set to project name from which the executable name will be deduced
# Specify languages the program is written in
project(library LANGUAGES C CXX Fortran)

# ****
# Instruct to create a named library from the space-separated list of source files
add_library(${PROJECT_NAME} ext.cpp ext.f90 add.f90)

# ***
# Set to the space-separated list of dependent PkgConfig modules
set(PKG_CONFIG_MODULES)

# **
# If set, accounts for static linking (forces setting the USE_MODULE_STATIC_LINKING option)
set(USE_STATIC_LINKING OFF)

# ****
# If set, instruct the build system to compile sources with MPI-aware compiler drivers
# and to link against the appropriate libraries
set(USE_MPI ON)

# ****
# If set, instruct the build system to emit OpenMP support flags
set(USE_OPENMP ON)

### Advanced project configuration

# ***
# Enforce language-specific standards
target_compile_features(${PROJECT_NAME} PRIVATE c_std_99 cxx_std_11)

# *
# Specify space-separated list of additional include directories specified as -I command line arguments
# Current directory is considered to contain a public interface and hence is already included by the common code
# target_include_directories(${PROJECT_NAME} PRIVATE .)

# **
# Specify space-separated list of preprocessor macro definitions specified as -D command line arguments
target_compile_definitions(${PROJECT_NAME} PRIVATE LIB_FOO=LIB_BAR)

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