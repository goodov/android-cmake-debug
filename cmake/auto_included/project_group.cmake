# Created by Alexey Khoroshilov (khoroshilov@alawar.com).
# Copyright (c) 2013 Alawar Entertainment. All rights reserved.

# Enables CMake support for project grouping inside .sln, .xcodeproj.

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

function(project_group target group)
	set_target_properties(${target} PROPERTIES FOLDER ${group})
endfunction(project_group)