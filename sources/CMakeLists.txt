cmake_minimum_required (VERSION 2.8.11)

# Load platform definition, custom modules
add_subdirectory(../CMake cmake_helpers)

project(TeapotNativeActivity)

if (PLATFORM_ANDROID)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -gdwarf-2")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -gdwarf-2")
endif()

add_subdirectory(TeapotNativeActivity)
