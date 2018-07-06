# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "anavs_rtk_dlr: 1 messages, 0 services")

set(MSG_I_FLAGS "-Ianavs_rtk_dlr:/home/yhlee/Sensor_Sync/src/anavs_rtk_dlr/msg;-Istd_msgs:/opt/ros/indigo/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(anavs_rtk_dlr_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/anavs_rtk_dlr/msg/odometry.msg" NAME_WE)
add_custom_target(_anavs_rtk_dlr_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "anavs_rtk_dlr" "/home/yhlee/Sensor_Sync/src/anavs_rtk_dlr/msg/odometry.msg" "std_msgs/Header"
)

#
#  langs = gencpp;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(anavs_rtk_dlr
  "/home/yhlee/Sensor_Sync/src/anavs_rtk_dlr/msg/odometry.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/anavs_rtk_dlr
)

### Generating Services

### Generating Module File
_generate_module_cpp(anavs_rtk_dlr
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/anavs_rtk_dlr
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(anavs_rtk_dlr_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(anavs_rtk_dlr_generate_messages anavs_rtk_dlr_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/anavs_rtk_dlr/msg/odometry.msg" NAME_WE)
add_dependencies(anavs_rtk_dlr_generate_messages_cpp _anavs_rtk_dlr_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(anavs_rtk_dlr_gencpp)
add_dependencies(anavs_rtk_dlr_gencpp anavs_rtk_dlr_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS anavs_rtk_dlr_generate_messages_cpp)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(anavs_rtk_dlr
  "/home/yhlee/Sensor_Sync/src/anavs_rtk_dlr/msg/odometry.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/anavs_rtk_dlr
)

### Generating Services

### Generating Module File
_generate_module_lisp(anavs_rtk_dlr
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/anavs_rtk_dlr
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(anavs_rtk_dlr_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(anavs_rtk_dlr_generate_messages anavs_rtk_dlr_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/anavs_rtk_dlr/msg/odometry.msg" NAME_WE)
add_dependencies(anavs_rtk_dlr_generate_messages_lisp _anavs_rtk_dlr_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(anavs_rtk_dlr_genlisp)
add_dependencies(anavs_rtk_dlr_genlisp anavs_rtk_dlr_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS anavs_rtk_dlr_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(anavs_rtk_dlr
  "/home/yhlee/Sensor_Sync/src/anavs_rtk_dlr/msg/odometry.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/anavs_rtk_dlr
)

### Generating Services

### Generating Module File
_generate_module_py(anavs_rtk_dlr
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/anavs_rtk_dlr
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(anavs_rtk_dlr_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(anavs_rtk_dlr_generate_messages anavs_rtk_dlr_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/anavs_rtk_dlr/msg/odometry.msg" NAME_WE)
add_dependencies(anavs_rtk_dlr_generate_messages_py _anavs_rtk_dlr_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(anavs_rtk_dlr_genpy)
add_dependencies(anavs_rtk_dlr_genpy anavs_rtk_dlr_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS anavs_rtk_dlr_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/anavs_rtk_dlr)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/anavs_rtk_dlr
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(anavs_rtk_dlr_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/anavs_rtk_dlr)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/anavs_rtk_dlr
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(anavs_rtk_dlr_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/anavs_rtk_dlr)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/anavs_rtk_dlr\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/anavs_rtk_dlr
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(anavs_rtk_dlr_generate_messages_py std_msgs_generate_messages_py)
endif()
