# Created by Alexey Khoroshilov (khoroshilov@alawar.com)
# Copyright (c) 2013 Alawar Entertainment. All rights reserved. 

function(create_configuration name from)
	if (CMAKE_CONFIGURATION_TYPES)
		list(APPEND CMAKE_CONFIGURATION_TYPES ${name})
		list(REMOVE_DUPLICATES CMAKE_CONFIGURATION_TYPES)
		set(CMAKE_CONFIGURATION_TYPES "${CMAKE_CONFIGURATION_TYPES}"
			CACHE STRING "Semicolon separated list of supported configuration types" FORCE)
	endif()

	# For single-configuration generators we still can use configurations via CMAKE_BUILD_TYPE
	string(TOUPPER ${name} NAME)
	string(TOUPPER ${from} FROM)
	
	set(CMAKE_CXX_FLAGS_${NAME} ${CMAKE_CXX_FLAGS_${FROM}}
		CACHE STRING "Flags used by the compiler during ${name} builds" FORCE)
	set(CMAKE_C_FLAGS_${NAME} ${CMAKE_C_FLAGS_${FROM}}
		CACHE STRING "Flags used by the compiler during ${name} builds" FORCE)
	set(CMAKE_EXE_LINKER_FLAGS_${NAME} ${CMAKE_EXE_LINKER_FLAGS_${FROM}}
		CACHE STRING "Flags used by the linker for executables during ${name} builds" FORCE)
	set(CMAKE_MODULE_LINKER_FLAGS_${NAME} ${CMAKE_MODULE_LINKER_FLAGS_${FROM}}
		CACHE STRING "Flags used by the linker for loadable modules during ${name} builds" FORCE)
	set(CMAKE_SHARED_LINKER_FLAGS_${NAME} ${CMAKE_SHARED_LINKER_FLAGS_${FROM}}
		CACHE STRING "Flags used by the linker for shared libraries during ${name} builds" FORCE)
	
	mark_as_advanced(
		CMAKE_CXX_FLAGS_${NAME}
		CMAKE_C_FLAGS_${NAME}
		CMAKE_EXE_LINKER_FLAGS_${NAME}
		CMAKE_MODULE_LINKER_FLAGS_${NAME}
		CMAKE_SHARED_LINKER_FLAGS_${NAME}
	)
endfunction()

function(remove_configuration name)
	if(NOT CMAKE_CONFIGURATION_TYPES)
		return()
	endif()

	list(REMOVE_ITEM CMAKE_CONFIGURATION_TYPES ${name})
	set(CMAKE_CONFIGURATION_TYPES "${CMAKE_CONFIGURATION_TYPES}"
		CACHE STRING "Semicolon separated list of supported configuration types" FORCE)
endfunction()

function(set_debug_configuration configuration)
	get_property(conf_list GLOBAL PROPERTY DEBUG_CONFIGURATIONS)
	list(APPEND conf_list ${configuration})
	set_property(GLOBAL PROPERTY DEBUG_CONFIGURATIONS ${conf_list})
endfunction()

function(setup_configurations_mappings target)

	if (NOT CMAKE_CONFIGURATION_TYPES)
		return()
	endif()

	function(find_best_match item elements out_var)
		string(LENGTH ${item} item_len)
		foreach(element IN ITEMS ${elements})
			string(LENGTH ${element} element_len)
			if (element_len LESS item_len OR element_len EQUAL item_len)
				string(SUBSTRING ${item} 0 ${element_len} item_substr)
				if (${item_substr} STREQUAL ${element})
					set(${out_var} ${element} PARENT_SCOPE)
					return()
				endif()
			endif()
		endforeach()
	endfunction()
		
	get_target_property(target_configurations ${target} IMPORTED_CONFIGURATIONS)
	if (NOT target_configurations)
		message(STATUS "IMPORTED_CONFIGURATIONS is empty in target ${target}. Skipping configurations mapping")
	endif()
	
	string(TOUPPER "${target_configurations}" target_configurations)
	foreach(target_config ${target_configurations})
		get_target_property(target_imported_location_config ${target} IMPORTED_LOCATION_${target_config})
		if (NOT target_imported_location_config)
			message(FATAL_ERROR "IMPORTED_LOCATION_${target_config} is empty in target ${target}")
		endif()
	endforeach()

	list(SORT target_configurations)
	list(REVERSE target_configurations)
	list(FIND target_configurations "RELEASE" release_config_pos)

	string(TOUPPER "${CMAKE_CONFIGURATION_TYPES}" cmake_configurations)
	list(SORT cmake_configurations)

	foreach(cmake_configuration ${cmake_configurations})
		unset(mapped_config)
		find_best_match(${cmake_configuration} "${target_configurations}" mapped_config)
		if (NOT mapped_config AND NOT release_config_pos EQUAL -1 AND
			(${cmake_configuration} STREQUAL "MINSIZEREL" OR ${cmake_configuration} STREQUAL "RELWITHDEBINFO"))
			set(mapped_config "RELEASE")
		endif()
		if (NOT mapped_config)
			message(FATAL_ERROR "Can't map ${cmake_configuration} configuration to any configuration in target ${target}")
		endif()
		# message(STATUS "Configuration ${cmake_configuration} mapped to ${target} ${mapped_config}")
		set_target_properties(${PROJECT_NAME} PROPERTIES MAP_IMPORTED_CONFIG_${cmake_configuration} ${mapped_config})
	endforeach()
endfunction()


set_debug_configuration(Debug) # Mark default CMake Debug configuration as Debug