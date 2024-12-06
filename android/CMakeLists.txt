cmake_minimum_required(VERSION 3.4.1)
project(P2pMessenger)

set (CMAKE_VERBOSE_MAKEFILE ON)
set (CMAKE_CXX_STANDARD 14)

add_library(p2p-messenger            SHARED
            ../cpp/p2p-messenger.cpp
            cpp-adapter.cpp
)

# Specifies a path to native header files.
include_directories(
            ../cpp
)
