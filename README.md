=====================
Hardware requirements
=====================
1. Bumblebee2 BB2-08S2C
via FireWire-1394 standard
2. Decawave range finder with one anchor and onr tag
via SerialPort
3. ANavs RTK System

========
Compile
========
1. cd catkin_ws
2. delete build, devel
3. chmod +x catkin_ws/src/decawave_driver/src/dist_read.py
4. catkin_make


========
Set-Up
========
7. source devel/setup.bash
8. sudo chmod 666 /dev/ttyACM*: the enumeration should be the same as it is displayed.
check accordingly the port number in the launch file <param name="port" value="/dev/ttyACM0" type="string"/> in catkin_ws/src/read_dw_camera_dist.launch 
or
self.dwPort = rospy.get_param('~port','dev/ttyACM0') in catkin_ws/src/decawave_driver/src/dist_read.py
9. Run the ANavsWizard for UBX solution after connecting to wifi SSID: ANavs_RTK_Server and wait for 2-3 mins to get the correct precision data
10. Change the IP of your ANavs_PI in src/anavs_rtk_dlr/src/anavs_rtk_node.py in variable self.tcp_ip
11. The bayer pattern in <CATKIN_WS>/read_dw_camera_dist.launch refers to the type of image displayed and recoreded. "grbg" refers to colorful while "" to monochrome image.
12. Terminal1: roslaunch read_colorImg_dw_camera_dist.launch for rbg image or read_bwImg_dw_camera_dist.launch for monochrome image
13. roslaunch sensor_synchronizer synchronizer.launch

========
Denotation
========
1. On Terminal1 the "image 0" corresponding to left camera image, "image 1" to right camera image, followed by the counter for the image pair, and absolute ros time, in between there would be "UW time" referred to the data from range finder followed by ros time and distance in m. Also, the RTK output data is shown
2. On Terminal2, "Ranging measurement [m]"should be printed out.
3. /rtk_odometry rostopic for rtk position and rotation matrix alongwith rostime
4. /tum_nav/sync_data for synchronized topic with images, rtk and ranging measurements
5. /tum_nav/sync_record for synchronized topic with images, rtk and ranging measurements which is used in storing wherein storing paramters are used

========
Storage
========
######Note the storing rate could be set:
cd /*/catkin_ws/src/sensor_synchronizer/launch/, in synchronizer.launch
"recording_image_frame" default as 2, which means the storage is implemented once every two images between two rannging measurements. Change it accordingly to  your application.
"recording_image_second" default to 0.040 refers to the minimum time difference between two subsequent saved images.

1. cd /*/catkin_ws/src/storage/strorage***/left_image_data/, the left images are stored here
2. cd /*/catkin_ws/src/storage/strorage***/right_image_data/, the right images are stored here
3. cd /*/catkin_ws/src/storage/strorage***/distance_data/, the distances are stored in the range.txt file
4. cd /*/catkin_ws/src/storage/strorage***/time_stamp/, the timestamps are stored in the time_stamp.txt file
5. cd /*/catkin_ws/src/storage/strorage***/ground_truth/, the groundtruth are stored in the ground_truth.txt file
6. cd /*/catkin_ws/src/storage/strorage***/ground_truth/, the groundtruth_euler are stored in the ground_truth_euler.txt file

========
Bag Files
========
1) Change the path in argument of  <CATKIN_WS>/src/rosbag_recoder/launch/record.launch file.
2) Change the path in argument of  <CATKIN_WS>/src/rosbag_recoder/launch/record_sync.launch file.
3) roslaunch rosbag_recoder record.launch will record 4 topics : Camera_left, Camera_right, ranger_distance, rtk_odometry
4) roslaunch rosbag_recoder record_sync.launch will record just 1 topics : /tum_nav/sync_data for synchronized data




