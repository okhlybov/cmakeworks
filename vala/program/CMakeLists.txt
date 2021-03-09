#
# Sample multiplatform CMake project to build Vala program
#
# https://github.com/okhlybov/cmakeworks/vala/program
#

# **** Asterisks indicate the level of importance for customization

# *
# Set up CMake compatibility level
cmake_minimum_required(VERSION 3.16) # Ninja Multi-Config requires 3.17+

# Slurp in the common logics code
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

find_package(Vala REQUIRED)

### Basic project setup

# ****
# Set to project name from which the executable name will be deduced
project(program)

# ****
# Specify source files and Vala dependencies
# The sources can be either Vala or any other languages such as C that will be passed through
vala_precompile_target(${PROJECT_NAME}-vala VALAC_AUTO
    SOURCES main.vala ext.vala
    PACKAGES gtk+-3.0
)

# *
# Instruct to create a named executable from the space-separated list of source files which consitute the program
add_executable(${PROJECT_NAME} ${VALAC_AUTO})

# *
# Set to the space-separated list of dependent PkgConfig modules
# There is no need to modify anything for the pure Vala program
set(PKG_CONFIG_MODULES ${VALAC_PACKAGES} glib-2.0 gobject-2.0) # glib and gobject are always used by Vala program

### Advanced project configuration

# *
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

include(CMakeWorks)