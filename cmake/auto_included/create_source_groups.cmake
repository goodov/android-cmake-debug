# Created by Alexey Khoroshilov (khoroshilov@alawar.com).
# Copyright (c) 2013 Alawar Entertainment. All rights reserved. 

function(create_source_groups)
	foreach(item IN ITEMS ${ARGN})
		get_filename_component(path ${item} PATH)
		string(REPLACE "/" "\\" group "${path}")
		if (group)
			source_group(${group} FILES ${item})
		endif()
	endforeach()
endfunction()
