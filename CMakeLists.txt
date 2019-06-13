cmake_minimum_required(VERSION 3.10)
project(svd_bug)
enable_language(CXX)
set(CMAKE_VERBOSE_MAKEFILE ON)

option(DOWNLOAD_EIGEN3 "Download Eigen3 automatically if not found" ON)
option(USE_MKL "Enable MKL" ON)
option(BUILD_SHARED_LIBS "Enable shared libraries" OFF )


add_executable(${PROJECT_NAME} main.cpp)

if(NOT BUILD_SHARED_LIBS)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX} ${CMAKE_FIND_LIBRARY_SUFFIXES})
    target_link_libraries(${PROJECT_NAME} PRIVATE -static)
endif()

# This flag causes the crash on xeon gold
target_compile_options(${PROJECT_NAME} PRIVATE  -mavx)



# Find or get the dependencies MKL and Eigen


set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/cmake-modules)
set(BUILD_DIRECTORY   ${PROJECT_SOURCE_DIR}/cmake-build-libs)
set(INSTALL_DIRECTORY ${PROJECT_SOURCE_DIR}/libs)
if(USE_MKL)
    include(cmake-modules/FindGFortran.cmake)
    include(cmake-modules/Find_INTELMKL.cmake) 
endif()
include(cmake-modules/Fetch_Eigen3.cmake)

if(TARGET blas)
    target_link_libraries(${PROJECT_NAME} PRIVATE blas)
    target_compile_options(${PROJECT_NAME} PRIVATE  -DEIGEN_USE_MKL_ALL)
endif()


if(TARGET Eigen3::Eigen)
target_link_libraries(${PROJECT_NAME} PRIVATE Eigen3::Eigen)
endif()


