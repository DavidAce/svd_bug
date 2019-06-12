cmake_minimum_required(VERSION 3.10)
project(svd_crashtest)
enable_language(CXX)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/cmake-modules)

option(USE_MKL "Enable MKL" ON)
option(BUILD_SHARED_LIBS "Enable shared libraries" OFF )


add_executable(${PROJECT_NAME} main.cpp)
if(NOT BUILD_SHARED_LIBS)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX} ${CMAKE_FIND_LIBRARY_SUFFIXES})
    target_link_libraries(${PROJECT_NAME} PRIVATE -static)
endif()

target_compile_options(${PROJECT_NAME} PRIVATE  -mavx)

set(BUILD_DIRECTORY   ${PROJECT_SOURCE_DIR}/cmake-build-libs)
set(INSTALL_DIRECTORY ${PROJECT_SOURCE_DIR}/libs)
include(cmake-modules/FindGFortran.cmake)
include(cmake-modules/Find_dont_install_INTELMKL.cmake)    # MKL - Intel's Math Kernel Library, use the BLAS implementation in Eigen and Arpack. Includes lapack.
include(cmake-modules/Fetch_h5pp.cmake)                    # GSL for computing some numerical integrals.
target_link_libraries(${PROJECT_NAME} PRIVATE blas)
target_link_libraries(${PROJECT_NAME} PRIVATE h5pp::h5pp h5pp::deps h5pp::flags)
target_compile_options(${PROJECT_NAME} PRIVATE -pthread)



if(TARGET blas)
    set(EIGEN3_COMPILER_FLAGS  -Wno-parentheses) # -Wno-parentheses
    set(EIGEN3_USING_BLAS ON)
    if("${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU" )
        list(APPEND EIGEN3_COMPILER_FLAGS -Wno-unused-but-set-variable)
    endif()
    if(MKL_FOUND)
        list(APPEND EIGEN3_COMPILER_FLAGS -DEIGEN_USE_MKL_ALL)
        list(APPEND EIGEN3_INCLUDE_DIR ${MKL_INCLUDE_DIR})
        message(STATUS "Eigen3 will use MKL")
    elseif (BLAS_FOUND)
        list(APPEND EIGEN3_COMPILER_FLAGS -DEIGEN_USE_BLAS)
        list(APPEND EIGEN3_COMPILER_FLAGS -DEIGEN_USE_LAPACKE)
        message(STATUS "Eigen3 will use OpenBLAS")
    endif()
    target_compile_options(${PROJECT_NAME} PRIVATE ${EIGEN3_COMPILER_FLAGS})
endif()



