add_subdirectory(android/cpufeatures)
add_subdirectory(android/native_app_glue)
add_subdirectory(android/ndk_helper)

project(TeapotNativeActivity)

include(sources.cmake)

add_library(${PROJECT_NAME} SHARED ${SRCS})
target_link_libraries(${PROJECT_NAME} cpufeatures native_app_glue ndk_helper log android EGL GLESv2)

set_ndk_gdbserver_compatible(${PROJECT_NAME})