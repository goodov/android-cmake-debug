# Created by Alexey Khoroshilov (khoroshilov@alawar.com).
# Copyright (c) 2013 Alawar Entertainment. All rights reserved. 

# This file defines following variables:
#	PROJECT_NAME - name of platform (WIN32, IOS, ...)
#	PLATFORM_<PROJECT_NAME> - BOOL variable for platform testing (PLATFORM_WIN32, PLATFORM_IOS, ...)
#	PLATFORM_LOWERCASE_NAME - lowercase platform name :) (win32, ios, ...)


# Empty project() to initialize CMake generator variables and configurations
project("")

if (MSVC)

	set(PLATFORM_NAME WIN32)
	set(PLATFORM_${PLATFORM_NAME} TRUE CACHE BOOL "Is current platform Win32" FORCE)
	
	set(PLATFORM_VERSION 8.1 CACHE STRING "Platform version")
	set(PLATFORM_ARCH x86 CACHE STRING "Platform active architectures")
	set(PLATFORM_TYPE DESKTOP CACHE STRING "Platform type")
		
	set(PLATFORM_GRAPHICS_TYPE DX9 CACHE STRING "Platform 3D graphics API")

	if (MSVC90)
		set(PLATFORM_WIN32_MSVC_TOOLSET v90 CACHE STRING "MSVC Platform toolset" FORCE)
		set(PLATFORM_SUFFIX "-v90" CACHE STRING "" FORCE)
	elseif(MSVC10)
		set(PLATFORM_WIN32_MSVC_TOOLSET v100 CACHE STRING "MSVC Platform toolset" FORCE)
		set(PLATFORM_SUFFIX "-v100" CACHE STRING "" FORCE)
	elseif(MSVC11)
		set(PLATFORM_WIN32_MSVC_TOOLSET v110 CACHE STRING "MSVC Platform toolset" FORCE)
		set(PLATFORM_SUFFIX "-v110" CACHE STRING "" FORCE)
	elseif(MSVC12)
		set(PLATFORM_WIN32_MSVC_TOOLSET v120 CACHE STRING "MSVC Platform toolset" FORCE)
		set(PLATFORM_SUFFIX "-v120" CACHE STRING "" FORCE)
	endif()
	
	if (CMAKE_GENERATOR_TOOLSET)
		set(PLATFORM_WIN32_MSVC_TOOLSET ${CMAKE_GENERATOR_TOOLSET} CACHE STRING "MSVC Platform toolset" FORCE)
		set(PLATFORM_SUFFIX "-${CMAKE_GENERATOR_TOOLSET}" CACHE STRING "" FORCE)
	endif()

elseif (IOS)

	set(PLATFORM_NAME IOS)
	set(PLATFORM_${PLATFORM_NAME} TRUE CACHE BOOL "Is current platform iOS" FORCE)
	
	set(PLATFORM_GRAPHICS_TYPE GLES CACHE STRING "Platform 3D graphics API")

elseif (APPLE)

	set(PLATFORM_NAME MAC)
	set(PLATFORM_${PLATFORM_NAME} TRUE CACHE BOOL "Is current platform MacOS" FORCE)
	
	set(PLATFORM_GRAPHICS_TYPE GLES CACHE STRING "Platform 3D graphics API")

elseif (ANDROID)

	set(PLATFORM_NAME ANDROID)
	set(PLATFORM_${PLATFORM_NAME} TRUE CACHE BOOL "Is current platform Android" FORCE)
	
	set(PLATFORM_GRAPHICS_TYPE GLES CACHE STRING "Platform 3D graphics API")
	set(PLATFORM_ANDROID_ARCH ${ANDROID_NDK_ABI_NAME} CACHE STRING "" FORCE)	

	set(PLATFORM_SUFFIX "-${ANDROID_NDK_RELEASE}-${ANDROID_COMPILER_VERSION}" CACHE STRING "" FORCE)

endif()

string(TOLOWER ${PLATFORM_NAME} PLATFORM_LOWERCASE_NAME)
set(PLATFORM_LOWERCASE_NAME ${PLATFORM_LOWERCASE_NAME} CACHE STRING "" FORCE)

string(TOLOWER "${PLATFORM_SUFFIX}" PLATFORM_LOWERCASE_SUFFIX)
set(PLATFORM_LOWERCASE_SUFFIX "${PLATFORM_LOWERCASE_SUFFIX}" CACHE STRING "" FORCE)

# Includes if exists:
#   <type>.cmake
#   <type>.<platform>.cmake
macro(smart_include type)
	include_if_exists(${type}.cmake)
	include_if_exists(${type}.${PLATFORM_LOWERCASE_NAME}.cmake)
endmacro()