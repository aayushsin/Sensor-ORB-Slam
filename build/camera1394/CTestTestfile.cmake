# CMake generated Testfile for 
# Source directory: /home/yhlee/Sensor_Sync/src/camera1394
# Build directory: /home/yhlee/Sensor_Sync/build/camera1394
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
ADD_TEST(_ctest_camera1394_rostest_tests_no_device_node.test "/home/yhlee/Sensor_Sync/build/catkin_generated/env_cached.sh" "/usr/bin/python" "/opt/ros/indigo/share/catkin/cmake/test/run_tests.py" "/home/yhlee/Sensor_Sync/build/test_results/camera1394/rostest-tests_no_device_node.xml" "--return-code" "/opt/ros/indigo/share/rostest/cmake/../../../bin/rostest --pkgdir=/home/yhlee/Sensor_Sync/src/camera1394 --package=camera1394 --results-filename tests_no_device_node.xml --results-base-dir \"/home/yhlee/Sensor_Sync/build/test_results\" /home/yhlee/Sensor_Sync/src/camera1394/tests/no_device_node.test ")
ADD_TEST(_ctest_camera1394_rostest_tests_no_device_nodelet.test "/home/yhlee/Sensor_Sync/build/catkin_generated/env_cached.sh" "/usr/bin/python" "/opt/ros/indigo/share/catkin/cmake/test/run_tests.py" "/home/yhlee/Sensor_Sync/build/test_results/camera1394/rostest-tests_no_device_nodelet.xml" "--return-code" "/opt/ros/indigo/share/rostest/cmake/../../../bin/rostest --pkgdir=/home/yhlee/Sensor_Sync/src/camera1394 --package=camera1394 --results-filename tests_no_device_nodelet.xml --results-base-dir \"/home/yhlee/Sensor_Sync/build/test_results\" /home/yhlee/Sensor_Sync/src/camera1394/tests/no_device_nodelet.test ")
SUBDIRS(src/nodes)
