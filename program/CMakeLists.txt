# Sample multiplatform CMake project to build multilanguage (C/C++/FORTRAN) program
# with optional MPI, OpenMP and PkgConfig support
#
# https://github.com/okhlybov/cmakeworks/program
#

# **** Asterisks indicate the level of importance for customization

# *
# Set up CMake compatibility level
cmake_minimum_required(VERSION 3.17) # Ninja Multi-Config

### Basic project setup

# ****
# Set to project name from which the executable name will be deduced
# Specify languages the program is written in
project(program LANGUAGES C CXX Fortran)

# ****
# Instruct to create a named executable from the space-separated list of source files which consitute the program
add_executable(${PROJECT_NAME} main.c inc.c inc.cpp inc.f90)

# ***
# Set to the space-separated list of dependent PkgConfig modules
set(PKG_CONFIG_MODULES gmp)

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

# **
# Specify space-separated list of additional include directories specified as -I command line arguments
target_include_directories(${PROJECT_NAME} PRIVATE .)

# **
# Specify space-separated list of preprocessor macro definitions specified as -D command line arguments
target_compile_definitions(${PROJECT_NAME} PRIVATE FOO=BAR)

# Issue -DNDEBUG for non debugging builds
if(NOT ${CMAKE_BUILD_TYPE} MATCHES Debug)
	target_compile_definitions(${PROJECT_NAME} PRIVATE NDEBUG)
endif()

# *
# Set up default GCC-specific release compilation flags
set(flags "-g -O3")
if(${CMAKE_C_COMPILER_ID} MATCHES GNU)
	set(CMAKE_C_FLAGS_RELEASE ${flags})
endif()
if(${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
	set(CMAKE_CXX_FLAGS_RELEASE ${flags})
endif()
if(${CMAKE_Fortran_COMPILER_ID} MATCHES GNU)
	set(CMAKE_Fortran_FLAGS_RELEASE ${flags})
endif()

# *
# Set up default GCC-specific debug compilation flags
set(flags "-g -Og -Wall -pedantic")
if(${CMAKE_C_COMPILER_ID} MATCHES GNU)
	set(CMAKE_C_FLAGS_DEBUG ${flags})
endif()
if(${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
	set(CMAKE_CXX_FLAGS_DEBUG ${flags})
endif()
if(${CMAKE_Fortran_COMPILER_ID} MATCHES GNU)
	set(CMAKE_Fortran_FLAGS_DEBUG ${flags})
endif()

include(CMakeDependentOption)

# If set, PkgConfig is requested to link its modules statically
cmake_dependent_option(USE_MODULE_STATIC_LINKING "Link against PkgConfig modules statically" OFF USE_STATIC_LINKING ON)

if(NOT "${PKG_CONFIG_MODULES}" STREQUAL "")
	find_package(PkgConfig REQUIRED)
endif()

# Specify .mod files location inside the build directory
set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY})

# MPI cpecific compilation configuration
if(${USE_MPI})
	find_package(MPI REQUIRED)
	if(DEFINED CMAKE_C_COMPILER AND DEFINED MPI_C_COMPILER)
		set(CMAKE_C_COMPILER ${MPI_C_COMPILER})
	endif()
	if(DEFINED CMAKE_CXX_COMPILER AND DEFINED MPI_CXX_COMPILER)
		set(CMAKE_CXX_COMPILER ${MPI_CXX_COMPILER})
	endif()
	if(DEFINED CMAKE_Fortran_COMPILER AND DEFINED MPI_Fortran_COMPILER)
		set(CMAKE_Fortran_COMPILER ${MPI_Fortran_COMPILER})
	endif()
endif()

# Consume PkgConfig modules' command line flags
foreach(PC ${PKG_CONFIG_MODULES})
	pkg_check_modules(${PC} REQUIRED ${PC})
	target_include_directories(${PROJECT_NAME} PRIVATE ${${PC}_INCLUDE_DIRS})
	target_compile_options(${PROJECT_NAME} PRIVATE ${${PC}_CFLAGS_OTHER})
	target_link_directories(${PROJECT_NAME} PUBLIC ${${PC}_LIBRARY_DIRS})
	if(${USE_MODULE_STATIC_LINKING})
		target_link_options(${PROJECT_NAME} PUBLIC ${${PC}_STATIC_LDFLAGS_OTHER})
		target_link_libraries(${PROJECT_NAME} ${${PC}_STATIC_LIBRARIES})
	else()
		target_link_options(${PROJECT_NAME} PUBLIC ${${PC}_LDFLAGS_OTHER})
		target_link_libraries(${PROJECT_NAME} ${${PC}_LIBRARIES})
	endif()
endforeach(PC)

# GCC specific configuration
if(${CMAKE_C_COMPILER_ID} MATCHES GNU)
 	# Strip debugging information from release builds
	set(CMAKE_EXE_LINKER_FLAGS_RELEASE -s)
	# Account for static linking on demand
	if(${USE_STATIC_LINKING})
		target_link_options(${PROJECT_NAME} PUBLIC -static)
	endif()
	# Set up OpenMP flags on demand
	if(${USE_OPENMP})
		target_compile_options(${PROJECT_NAME} PRIVATE -fopenmp)
		target_link_options(${PROJECT_NAME} PUBLIC -fopenmp)
	endif()
endif()

get_property(languages GLOBAL PROPERTY ENABLED_LANGUAGES)

# Link standard C libraries
if(C IN_LIST languages)
	if(${USE_MPI})
		target_link_libraries(${PROJECT_NAME} MPI::MPI_C)
	endif()
endif()

# Link standard C++ libraries
if(CXX IN_LIST languages)
	if(${USE_MPI})
		target_link_libraries(${PROJECT_NAME} MPI::MPI_CXX)
	else()
		if(${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
			target_link_libraries(${PROJECT_NAME} stdc++)
		endif()
	endif()
endif()

# Link standard FORTRAN libraries
if(Fortran IN_LIST languages)
	if(${USE_MPI})
		target_link_libraries(${PROJECT_NAME} MPI::MPI_Fortran)
	else()
		if(${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
			target_link_libraries(${PROJECT_NAME} gfortran quadmath)
		endif()
	endif()
endif()