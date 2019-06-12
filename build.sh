#!/bin/bash
export CC=gcc
export CXX=g++

mode=Debug
shared=OFF
# Set this flag if clang is linking to an undesired GNU standard library
#gcc_toolchain=/software/sse/easybuild/prefix/software/GCCcore/7.3.0


cmake -E make_directory build/$mode
cd build/$mode
cmake -DBUILD_SHARED_LIBS=$shared -DCMAKE_BUILD_TYPE=$mode -DGCC_TOOLCHAIN=$gcc_toolchain  -G "CodeBlocks - Unix Makefiles" ../../
cmake --build . --target $target -- -j 16
