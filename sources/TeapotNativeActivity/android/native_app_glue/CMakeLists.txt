project(native_app_glue)

set(PROJ_ROOT ${ANDROID_NDK}/sources/android/native_app_glue)

set(SRCS
	${PROJ_ROOT}/android_native_app_glue.c
)

add_library(${PROJECT_NAME} STATIC ${SRCS})
target_include_directories(${PROJECT_NAME} PUBLIC ${PROJ_ROOT})
