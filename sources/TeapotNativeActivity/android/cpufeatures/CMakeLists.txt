project(cpufeatures)

set(PROJ_ROOT ${ANDROID_NDK}/sources/android/cpufeatures)

set(SRCS
	${PROJ_ROOT}/cpu-features.c
)

add_library(${PROJECT_NAME} STATIC ${SRCS})
target_include_directories(${PROJECT_NAME} PUBLIC ${PROJ_ROOT})


