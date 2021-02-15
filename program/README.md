# Sample multiplatform CMake project for multilanguage program

This project can be used as either a testbed for the build environment or a starting point for new projects.

## Features

- Build native Linux executable on either native Linux host or the [Windows Subsystem for Linux](https://docs.microsoft.com/windows/wsl/)

- Build native Windows executable using [MSYS2](https://www.msys2.org/) & [MinGW](http://mingw-w64.org/) environments

- Support for GCC toolchain

- Support for C/C++/FORTRAN code within a single executable

- Automatic source dependency tracking

- Static/dynamic linking

- Optional support for external [PkgConfig](https://www.freedesktop.org/wiki/Software/pkg-config/) modules

- Optional MPI support

- Optional OpenMP support

- Optional CMake-based modularization with [dependent libraries](../library/README.md)

- [Visual Studio Code](https://code.visualstudio.com/) integration via preconfigured setup for [CMakeTools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) & [CppTools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) extensions

## Build environment test

Before jumping into a new CMakeWorks-assisted adventure it is

## New project quick start

In order to start a new CMake project (say, `myprog`) for the program with this project as a template, do the following

- Copy the `program` directory to a destination place for a new project

- Get rid of original source files inside the `program` directory

- Rename the freshly copied `program` directory to `myprog`

- Create/copy source files consituting the program to `myprog`

- Perform the basic project configuration by tailoring the `myprog/CMakeLists.txt` file

    - Set up the project name in `project(...)` command by changing `program` to `myprog`

    - Specify the languages the program uses in `project(... LANGUAGES ...)` option (it's OK to leave it as is)

    - Specify the program space-separated source files list in  `add_executable(...)` command (for example, to `main.c ext.cpp`) replacing the original one

    - Tailor the library dependency block started with `set(dependency ...)` to the dependent library module. Comment or delete the block in case of no dependencies or clone & tailor it in case of multiple dependent libraries

    - Specify the external [PkgConfig](https://www.freedesktop.org/wiki/Software/pkg-config/) dependencies by setting the space-separated list of dependent PkgConfig modules in `set(PKG_CONFIG_MODULES ...)`. Wipe out the list in case of no dependencies

    - Toggle the preconfigured `USE` flags handled by the CMakeWorks boilerplate code (support for OpenMP, MPI, static linking, etc)

Now the basic configuration should be fairly complete.

There are a few more optional features in the `CMakeLists.txt` to be considered

    - Preprocessor macro definitions with `target_compile_definitions(...)`

    - Source code compliance & capabilities with `target_compile_features(...)`

    - Language-agnostic optimizing & debugging GCC compilation options `GNU_*_FLAGS`

These are likely to be left as is until a need arises.

Finally there is a CMake code in the `cmake/CMakeWorks.cmake` which handles all the logic driving the project. Although this code can be modified as well, it is considered a very advanced topic and as such it is most likey to be left untouched.