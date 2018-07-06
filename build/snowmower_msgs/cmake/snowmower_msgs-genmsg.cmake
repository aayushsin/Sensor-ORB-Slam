# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "snowmower_msgs: 4 messages, 0 services")

set(MSG_I_FLAGS "-Isnowmower_msgs:/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg;-Istd_msgs:/opt/ros/indigo/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(snowmower_msgs_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleMsg.msg" NAME_WE)
add_custom_target(_snowmower_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "snowmower_msgs" "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleMsg.msg" ""
)

get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/EncMsg.msg" NAME_WE)
add_custom_target(_snowmower_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "snowmower_msgs" "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/EncMsg.msg" "std_msgs/Header"
)

get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleArray.msg" NAME_WE)
add_custom_target(_snowmower_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "snowmower_msgs" "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleArray.msg" "std_msgs/Header:snowmower_msgs/ObstacleMsg"
)

get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/DecaWaveMsg.msg" NAME_WE)
add_custom_target(_snowmower_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "snowmower_msgs" "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/DecaWaveMsg.msg" "std_msgs/Header"
)

#
#  langs = gencpp;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(snowmower_msgs
  "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleMsg.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/snowmower_msgs
)
_generate_msg_cpp(snowmower_msgs
  "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/EncMsg.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/snowmower_msgs
)
_generate_msg_cpp(snowmower_msgs
  "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleArray.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg;/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleMsg.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/snowmower_msgs
)
_generate_msg_cpp(snowmower_msgs
  "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/DecaWaveMsg.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/snowmower_msgs
)

### Generating Services

### Generating Module File
_generate_module_cpp(snowmower_msgs
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/snowmower_msgs
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(snowmower_msgs_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(snowmower_msgs_generate_messages snowmower_msgs_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleMsg.msg" NAME_WE)
add_dependencies(snowmower_msgs_generate_messages_cpp _snowmower_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/EncMsg.msg" NAME_WE)
add_dependencies(snowmower_msgs_generate_messages_cpp _snowmower_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleArray.msg" NAME_WE)
add_dependencies(snowmower_msgs_generate_messages_cpp _snowmower_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/DecaWaveMsg.msg" NAME_WE)
add_dependencies(snowmower_msgs_generate_messages_cpp _snowmower_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(snowmower_msgs_gencpp)
add_dependencies(snowmower_msgs_gencpp snowmower_msgs_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS snowmower_msgs_generate_messages_cpp)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(snowmower_msgs
  "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleMsg.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/snowmower_msgs
)
_generate_msg_lisp(snowmower_msgs
  "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/EncMsg.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/snowmower_msgs
)
_generate_msg_lisp(snowmower_msgs
  "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleArray.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg;/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleMsg.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/snowmower_msgs
)
_generate_msg_lisp(snowmower_msgs
  "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/DecaWaveMsg.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/snowmower_msgs
)

### Generating Services

### Generating Module File
_generate_module_lisp(snowmower_msgs
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/snowmower_msgs
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(snowmower_msgs_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(snowmower_msgs_generate_messages snowmower_msgs_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleMsg.msg" NAME_WE)
add_dependencies(snowmower_msgs_generate_messages_lisp _snowmower_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/EncMsg.msg" NAME_WE)
add_dependencies(snowmower_msgs_generate_messages_lisp _snowmower_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleArray.msg" NAME_WE)
add_dependencies(snowmower_msgs_generate_messages_lisp _snowmower_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/DecaWaveMsg.msg" NAME_WE)
add_dependencies(snowmower_msgs_generate_messages_lisp _snowmower_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(snowmower_msgs_genlisp)
add_dependencies(snowmower_msgs_genlisp snowmower_msgs_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS snowmower_msgs_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(snowmower_msgs
  "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleMsg.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/snowmower_msgs
)
_generate_msg_py(snowmower_msgs
  "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/EncMsg.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/snowmower_msgs
)
_generate_msg_py(snowmower_msgs
  "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleArray.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg;/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleMsg.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/snowmower_msgs
)
_generate_msg_py(snowmower_msgs
  "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/DecaWaveMsg.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/snowmower_msgs
)

### Generating Services

### Generating Module File
_generate_module_py(snowmower_msgs
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/snowmower_msgs
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(snowmower_msgs_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(snowmower_msgs_generate_messages snowmower_msgs_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleMsg.msg" NAME_WE)
add_dependencies(snowmower_msgs_generate_messages_py _snowmower_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/EncMsg.msg" NAME_WE)
add_dependencies(snowmower_msgs_generate_messages_py _snowmower_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/ObstacleArray.msg" NAME_WE)
add_dependencies(snowmower_msgs_generate_messages_py _snowmower_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/yhlee/Sensor_Sync/src/snowmower_msgs/msg/DecaWaveMsg.msg" NAME_WE)
add_dependencies(snowmower_msgs_generate_messages_py _snowmower_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(snowmower_msgs_genpy)
add_dependencies(snowmower_msgs_genpy snowmower_msgs_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS snowmower_msgs_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/snowmower_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/snowmower_msgs
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(snowmower_msgs_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/snowmower_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/snowmower_msgs
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(snowmower_msgs_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/snowmower_msgs)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/snowmower_msgs\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/snowmower_msgs
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(snowmower_msgs_generate_messages_py std_msgs_generate_messages_py)
endif()
