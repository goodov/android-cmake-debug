# Created by Alexey Khoroshilov (khoroshilov@alawar.com).
# Copyright (c) 2013 Alawar Entertainment. All rights reserved. 

macro(include_if_exists _file)
	if (EXISTS ${_file})
		include(${_file})
	elseif (EXISTS cmake/${_file})
		include(cmake/${_file})
	elseif (EXISTS CMake/${_file})
		include(CMake/${_file})
	endif()
endmacro()