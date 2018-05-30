cmake_minimum_required(VERSION 2.8.3)
project(filter_synchronizer1)
SET(CMAKE_CXX_FLAGS "-std=c++11")
set(OpenCV_DIR /usr/share/OpenCV/)
find_package(catkin REQUIRED COMPONENTS 
	camera_info_manager 
	image_transport 
	roscpp
	rospy
    cv_bridge
    OpenCV
    snowmower_msgs
    std_msgs
    sensor_msgs
    anavs_rtk_dlr
    message_generation
	tf)
#find_package(OpenCV REQUIRED)
#catkin_package(
#  CATKIN_DEPENDS message_runtime
#)
include_directories(${OpenCV_INCLUDE_DIRS})
# This driver uses Boost threads
find_package(Boost REQUIRED COMPONENTS thread)

## Generate messages in the 'msg' folder
 add_message_files(
   FILES
   DecaWaveMsg.msg
   odometry.msg
   slamMsg.msg
 )

 generate_messages(
   DEPENDENCIES
   std_msgs
   sensor_msgs
 )


catkin_package(
##  LIBRARIES ${PROJECT_NAME}
  CATKIN_DEPENDS rospy std_msgs sensor_msgs message_runtime
)


###########
## Build ##
###########

include_directories(include ${catkin_INCLUDE_DIRS})

# common source files for both node and nodelet driver interfaces


add_executable(synchronizer_node1 src/synchronizer1.cpp)
add_executable(synchronizer_node2 src/sync1.cpp)
add_executable(synchronizer_node3 src/sync2.cpp)
add_dependencies(synchronizer_node2 filter_synchronizer1_generate_messages_cpp)
target_link_libraries(synchronizer_node1 ${catkin_LIBRARIES})
target_link_libraries(synchronizer_node2 ${catkin_LIBRARIES})
target_link_libraries(synchronizer_node3 ${catkin_LIBRARIES})
target_link_libraries(synchronizer_node1 ${OpenCV_LIBS})
target_link_libraries(synchronizer_node2 ${OpenCV_LIBS})
target_link_libraries(synchronizer_node3 ${OpenCV_LIBS})