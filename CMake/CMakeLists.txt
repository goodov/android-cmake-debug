include(platform.cmake)

# Include recursively modules from auto_include directory (functions and macroses)
file(GLOB_RECURSE cmake_helpers ${CMAKE_CURRENT_LIST_DIR}/auto_included/*.cmake)
foreach(cmake_helper ${cmake_helpers})
	include(${cmake_helper})
endforeach(cmake_helper)
