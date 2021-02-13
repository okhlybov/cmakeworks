#
# Sample multiplatform CMake project to build multilanguage (C/C++/FORTRAN) library
# with optional MPI, OpenMP and PkgConfig support
#
# https://github.com/okhlybov/cmakeworks/library
#

# **** Asterisks indicate the level of importance for customization

# *
# Set up CMake compatibility level
cmake_minimum_required(VERSION 3.17) # Ninja Multi-Config

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

# WARNING for changes to the options below to take effect, a project cleanup & reconfiguration is required

# **
# If set, accounts for static linking (forces setting the USE_MODULE_STATIC_LINKING option)
option(USE_STATIC_LINKING "Perform static linking of the executable" OFF)

# ****
# If set, instruct the build system to compile sources with MPI-aware compiler drivers
# and to link against the appropriate libraries
option(USE_MPI "Enable MPI support" ON)

# ****
# If set, instruct the build system to emit OpenMP support flags
option(USE_OPENMP "Enable OpenMP support" ON)

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

# **
# Set GCC-specific optimization flags
set(gcc_release_flags "-g -O3")

# **
# Set GCC-specific debugging flags
set(gcc_debug_flags "-g -Og -Wall -pedantic")

# Slurp in the common logics code
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(CMakeWorks)