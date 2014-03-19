# Created by Alexey Khoroshilov (khoroshilov@alawar.com).
# Copyright (c) 2013 Alawar Entertainment. All rights reserved.

if (NOT PLATFORM_ANDROID)
	return()
endif()

set(NDK_GDB_PY_SCRIPT ${CMAKE_CURRENT_LIST_DIR}/stuff/ndk-gdb.py.in CACHE STRING "" FORCE)

function(install_android_so_file target)

	get_target_property(outfile ${target} IMPORTED_LOCATION)
	
	if (NOT EXISTS ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${outfile})
		execute_process(COMMAND ${CMAKE_COMMAND} -E copy_if_different ${outfile} ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
	endif()
	
endfunction()

function(set_ndk_gdbserver_compatible target)

	set(gdbserver_out ${LIBRARY_OUTPUT_PATH}/gdbserver)

	get_property(conf_list GLOBAL PROPERTY DEBUG_CONFIGURATIONS)
	list(FIND conf_list ${CMAKE_BUILD_TYPE} current_conf_pos)
	if (current_conf_pos EQUAL -1)
		message(STATUS "Configuration '${CMAKE_BUILD_TYPE}' is not debuggable. Skipping ndk gdbserver setup")
		# remove gdbserver from apk if not Debug configuration
		add_custom_target(${target}_ndk_gdbserver
			COMMAND "${CMAKE_COMMAND}" -E remove -f ${gdbserver_out})
		add_dependencies(${target} ${target}_ndk_gdbserver)
		return()
	endif()
    
	message(STATUS "Configuration '${CMAKE_BUILD_TYPE}' is debuggable. Setting up ndk gdbserver compatibility")

	# copy gdbserver to apk from ndk if Debug configuration
	add_custom_target(${target}_ndk_gdbserver ALL
		COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${ANDROID_NDK}/prebuilt/android-arm/gdbserver/gdbserver" ${gdbserver_out})
	add_dependencies(${target} ${target}_ndk_gdbserver)
    
	# Set up some variables which will be inserted in ndk-gdb.py script via CMake's configure_file command
	set(NDK_GDB_APP_OUT ${CMAKE_BINARY_DIR}/ndk-gdb)
	file(MAKE_DIRECTORY ${NDK_GDB_APP_OUT})
    
    set(NDK_GDB_ANDROID_ABI ${ANDROID_ABI})
    if (CMAKE_HOST_WIN32)
        set(gdb_path_delimeter ";")
    else()
        set(gdb_path_delimeter ":")
    endif()
    set(NDK_GDB_GDBSETUP_SOLIB_SEARCH_PATH "${LIBRARY_OUTPUT_PATH}${gdb_path_delimeter}${NDK_GDB_APP_OUT}")
    set(NDK_GDB_GDBSETUP_DIRECTORY "${CMAKE_SOURCE_DIR}")

	# Separate debug information and runnable binary
	add_custom_command(TARGET ${target} POST_BUILD
		# Rename .so file to .so.debug file
		COMMAND ${CMAKE_COMMAND} -E rename $<TARGET_FILE:${target}> $<TARGET_FILE:${target}>.debug
		# Strip .so.debug file to only runnable part and put it into .so file
		COMMAND ${CMAKE_STRIP} --strip-debug --strip-unneeded $<TARGET_FILE:${target}>.debug -o $<TARGET_FILE:${target}>
		# Add link to debuggable .so.debug file to .so file
		COMMAND ${CMAKE_OBJCOPY} --add-gnu-debuglink=$<TARGET_FILE:${target}>.debug $<TARGET_FILE:${target}>)
		
	# Create ndk-gdb/ndk-gdb.py script from ndk-gdb.py.in
    configure_file(${NDK_GDB_PY_SCRIPT} ${NDK_GDB_APP_OUT}/ndk-gdb.py @ONLY)
    file(WRITE ${NDK_GDB_APP_OUT}/app_process "")
    file(WRITE ${NDK_GDB_APP_OUT}/gdb.setup "")

endfunction()
