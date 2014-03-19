# http://stackoverflow.com/questions/7046956/populating-srcs-from-cmakelists-txt-in-subdirectories
#
# The macro first computes the path of the source file relative to the project root for each argument. 
# If the macro is invoked from inside a project sub directory the new value of the variable SRCS needs 
# to be propagated to the parent folder by using the PARENT_SCOPE option.

# This macro adds files in ${SRCS_VAR} (SRCS by default).
macro (add_sources)
    if (NOT DEFINED SRCS_VAR)
        set(SRCS_VAR SRCS)
    endif()
    file (RELATIVE_PATH _relPath ${PROJECT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
    foreach (_src ${ARGN})
        if (_relPath)
            set(_srcPath ${_relPath}/${_src})
        else()
            set(_srcPath ${_src})
        endif()
        list(APPEND ${SRCS_VAR} ${_srcPath})
    endforeach()
    unset(_srcPath)
    if (_relPath)
        # propagate SRCS to parent directory
        set (${SRCS_VAR} ${${SRCS_VAR}} PARENT_SCOPE)
    endif()
endmacro()

# This macro put files in ${SRCS_VAR} (SRCS by default) and ${SRCS_VAR}_RES.
# To finish importing resources from dependencies you need to call 'apply_target_resources'
macro (add_resources)
    if (NOT DEFINED SRCS_VAR)
        set(SRCS_VAR SRCS)
    endif()
    file (RELATIVE_PATH _relPath ${PROJECT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
    foreach (_src ${ARGN})
        if (_relPath)
            set(_srcPath ${_relPath}/${_src})
        else()
            set(_srcPath ${_src})
        endif()
        list(APPEND ${SRCS_VAR} ${_srcPath})
        get_filename_component(_absPath ${CMAKE_CURRENT_SOURCE_DIR}/${_src} ABSOLUTE)
        list(APPEND ${SRCS_VAR}_RES ${_absPath})
    endforeach()
    unset(_srcPath)
    unset(_absPath)
    if (_relPath)
        # propagate SRCS and SRCS_RES to parent directory
        set(${SRCS_VAR} ${${SRCS_VAR}} PARENT_SCOPE)
        set(${SRCS_VAR}_RES ${${SRCS_VAR}_RES} PARENT_SCOPE)
    endif()
endmacro()

# Imports resources from selected target (using values in property RESOURCE)
macro(add_resources_from_target target)
    if (NOT DEFINED SRCS_VAR)
        set(SRCS_VAR SRCS)
    endif()
    get_target_property(resources ${target} RESOURCE)
    if (resources)
        list(APPEND ${SRCS_VAR} ${resources})
        list(APPEND ${SRCS_VAR}_RES ${resources})
    endif()
endmacro()

# By default adds resources from SRCS_RES variable
# Can be invoked with custom resource variable name to add selected files only into target
function(apply_target_resources target)

    if (NOT ARGV1)
        set(res_list_variable SRCS)
    else()
        set(res_list_variable ${ARGV1})
    endif()

    get_target_property(_resources ${target} RESOURCE)
    if (_resources)
        list(APPEND _resources ${${res_list_variable}_RES})
        list(REMOVE_DUPLICATES _resources)
    else()
        set(_resources "${${res_list_variable}_RES}")
    endif()

    set_target_properties(${target} PROPERTIES RESOURCE "${_resources}")

endfunction()