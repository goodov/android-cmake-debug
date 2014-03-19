# Created by Alexey Khoroshilov (khoroshilov@alawar.com).
# Copyright (c) 2013 Alawar Entertainment. All rights reserved. 

macro(add_subdirectory_safe dir)
	get_filename_component(abs_dir ${dir} ABSOLUTE)
	if (EXISTS ${abs_dir}/CMakeLists.txt)
		add_subdirectory(${dir})
	endif()
endmacro(add_subdirectory_safe)

macro(add_subdirectory_recurse_safe dir)
	add_subdirectory_safe(${dir})
	file(GLOB dir_elements ${dir}/*)
	foreach(dir_element IN ITEMS ${dir_elements})
		if(IS_DIRECTORY ${dir_element})
			add_subdirectory_recurse_safe(${dir_element})
		endif()
	endforeach(dir_element)
endmacro(add_subdirectory_recurse_safe)