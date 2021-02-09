# Common CMake logic for use in CMakeWorks projects
#
# https://github.com/okhlybov/cmakeworks

# Set up default GCC-specific release compilation flags
set(flags "-g -O3")
if(${CMAKE_C_COMPILER_ID} MATCHES GNU)
	set(CMAKE_C_FLAGS_RELEASE_INIT ${flags})
endif()
if(${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
	set(CMAKE_CXX_FLAGS_RELEASE_INIT ${flags})
endif()
if(${CMAKE_Fortran_COMPILER_ID} MATCHES GNU)
	set(CMAKE_Fortran_FLAGS_RELEASE_INIT ${flags})
endif()

# Set up default GCC-specific debug compilation flags
set(flags "-g -Og -Wall -pedantic")
if(${CMAKE_C_COMPILER_ID} MATCHES GNU)
	set(CMAKE_C_FLAGS_DEBUG_INIT ${flags})
endif()
if(${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
	set(CMAKE_CXX_FLAGS_DEBUG_INIT ${flags})
endif()
if(${CMAKE_Fortran_COMPILER_ID} MATCHES GNU)
	set(CMAKE_Fortran_FLAGS_DEBUG_INIT ${flags})
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
