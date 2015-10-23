# CMAKE IS STUPIDLY BAD.
# This just runs the stupid Makefile I already have:
cmake_minimum_required(VERSION 2.8.4)
project(runMake)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

add_custom_target(runMake COMMAND make -C ${runMake_SOURCE_DIR}
                         CLION_EXE_DIR=${PROJECT_BINARY_DIR})