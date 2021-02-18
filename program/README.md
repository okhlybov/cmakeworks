# Sample multiplatform CMake project for multilanguage program

This project can be used as either a testbed for the build environment or a starting point for new projects.

## Features

- Build native Linux executable on either native Linux host or the [Windows Subsystem for Linux](https://docs.microsoft.com/windows/wsl/)

- Build native Windows executable using [MSYS2](https://www.msys2.org/) & [MinGW](http://mingw-w64.org/) environments

- Support for GCC toolchain

- Support for mixed C/C++/FORTRAN code within a single executable

- Automatic source dependency tracking for all languages

- Support for release/debug builds separation

- Static/dynamic program linking

- Optional support for external libraries with the [PkgConfig](https://www.freedesktop.org/wiki/Software/pkg-config/) modules

- Optional MPI support

- Optional OpenMP support

- Optional CMake-based source code modularization with [library subprojects](../library/README.md)

- [Visual Studio Code](https://code.visualstudio.com/) integration via preconfigured setup for [CMakeTools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) & [CppTools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) extensions

## Build environment test

Before jumping into a new CMakeWorks-assisted adventure it makes sense to perform a test run of the selected build environment.

The sample program project provided by this repository consists of the program itself residing in the `program` directory and the separate source library subproject residing in the `library` directory as the program's dependency. The command sequence below builds both main program and dependent library projects producing a single executable.

Provided that the build environment is [properly configured](...), the command line build sequence is as follows

- Get into the project directory with something like

```shell
cd path/to/program
```

**Note** that the actual command above depends on the specific location.

- Perform the project configuration with

```shell
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
```

The above command performs an out-of-source project build, which is a preferred CMake way, where all generated files including the resulting executable itself come into the `build` subdirectory (`-B build`) of the project's source tree (`-S .`) thus making it very easy to reset the build simply by deleting this directory with `rm -rf build` if a need arises.

In addition, it instructs to appoint the CMake-preferred [Ninja](https://ninja-build.org/) as the generator tool (`-G Ninja`) to perform the actual build.

- Build the configured project with

```shell
cmake --build build
```

The above command builds the freshly configured project inside the `build` directory (`--build build`) producing the `build/program{.exe}` executable by calling the respective generator tool.

For a complete options list refer to the `cmake` tool [documentation](https://cmake.org/cmake/help/latest/manual/cmake.1.html).

## New project quick start

In order to start a new CMake-based program project (`myprog`, for example) with this project as a template, do the following

- Copy the `program` directory to a destination place for a new project

- Get rid of original source files inside the `program` directory

- Rename the freshly copied `program` directory to `myprog`

- Create/copy source files consituting the program to `myprog`

- Perform the basic project configuration by tailoring the `myprog/CMakeLists.txt` file

    - Set up the project name in `project(...)` command by changing `program` to `myprog`

    - Specify the languages the program uses in `project(... LANGUAGES ...)` option (it's OK to leave it as is)

    - Specify the program space-separated source files list in  `add_executable(...)` command (for example, to `main.c ext.cpp`) replacing the original one

    - Tailor the library dependency (`mylib`, for example) block started with `set(dependency mylib)` to the dependent library module. Comment or delete the block in case of no dependencies or clone & tailor it in case of multiple dependent libraries providing actual library locations in the corresponding `add_subdirectory(...)` commands

    - Specify the external [PkgConfig](https://www.freedesktop.org/wiki/Software/pkg-config/) dependencies by setting the space-separated list of dependent PkgConfig modules in `set(PKG_CONFIG_MODULES ...)`. Wipe out the list in case of no dependencies

    - Toggle the preconfigured `USE` flags handled by the CMakeWorks boilerplate code (support for OpenMP, MPI, static linking, etc)

Now the basic configuration should be fairly complete.

- There are a few more optional features in the `myprog/CMakeLists.txt` to be considered

    - Preprocessor macro definitions with `target_compile_definitions(...)`

    - Source code compliance & capabilities with `target_compile_features(...)`

    - Language-agnostic optimizing & debugging GCC compilation options `GNU_*_FLAGS`

**Note** that these are likely to be left as is until a real need arises.

Finally there is a CMake code in the `cmake/CMakeWorks.cmake` file which handles all the logic driving the project. Although this code can be modified as well, it is considered a very advanced topic and as such it is most likey to be left untouched for a reason.