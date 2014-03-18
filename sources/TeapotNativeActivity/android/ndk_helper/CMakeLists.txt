project(ndk_helper)

set(PROJ_ROOT ${ANDROID_NDK}/sources/android/ndk_helper)

set(SRCS
	${PROJ_ROOT}/JNIHelper.cpp
	${PROJ_ROOT}/interpolator.cpp
	${PROJ_ROOT}/tapCamera.cpp
	${PROJ_ROOT}/gestureDetector.cpp
	${PROJ_ROOT}/perfMonitor.cpp
	${PROJ_ROOT}/vecmath.cpp
	${PROJ_ROOT}/GLContext.cpp
	${PROJ_ROOT}/shader.cpp
	${PROJ_ROOT}/gl3stub.c 
)

add_library(${PROJECT_NAME} STATIC ${SRCS})
target_include_directories(${PROJECT_NAME} PUBLIC ${PROJ_ROOT})
target_link_libraries(${PROJECT_NAME} cpufeatures native_app_glue)
