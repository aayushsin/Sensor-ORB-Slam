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
4. chmod +x *.sh
4. catkin_make
5. Run ./delete_images.sh //Ignore error
5. cd /*/catkin_ws/src/left_image_data/ 
   empty the folder manually
   cd /*/catkin_ws/src/right_image_data/ 
   empty the folder manually

========
Set-Up
========
7. source devel/setup.bash
8. sudo chmod 666 /dev/ttyACM*: the enumeration should be the same as it is displayed.
check accordingly the port number in the launch file <param name="port" value="/dev/ttyACM0" type="string"/> in catkin_ws/src/read_dw_camera_dist.launch 
or
self.dwPort = rospy.get_param('~port','dev/ttyACM0') in catkin_ws/src/decawave_driver/src/dist_read.py
9. Run the ANavsWizard for UBX solution after connecting to wifi SSID: ANavs_RTK_Server
10. Change the IP of your ANavs_PI in src/anavs_rtk_dlr/src/anavs_rtk_node.py in variable self.tcp_ip
11. Terminal1: roslaunch read_dw_camera_dist.launch
12. roaslaunch filter_sychronizer1 synchronizer.launch

========
Denotation
========
1. On Terminal1 the "image 0" corresponding to left camera image, "image 1" to right camera image, followed by the counter for the image pair, and absolute ros time, in between there would be "UW time" referred to the data from range finder followed by ros time and distance in m. Also, the RTK output data is shown
2. On Terminal2, "Ranging measurement [m]"should be printed out.
3. /rtk_odometry rostopic for rtk position and rotation matrix alongwith rostime
4. tum_nav/sync_camera_rtk for synchronized topic with images, rtk and ranging measurements

========
Storage
========
######Note the storing rate could be set:
cd /*/catkin_ws/src/filter_synchronizer1/launch/, in synchronizer.launch "recording_counter" default as 2, which means the storage is implemented once every two images. Change it accordingly to  your application.
Moreover, recording_frequency refers to the time difference between two subsequent images.

1. cd /*/catkin_ws/src/storage/strorage***/left_image_data/, the left images are stored here
2. cd /*/catkin_ws/src/storage/strorage***/right_image_data/, the right images are stored here
3. cd /*/catkin_ws/src/storage/strorage***/distance_data/, the distances are stored in the range.txt file
4. cd /*/catkin_ws/src/storage/strorage***/time_stamp/, the timestamps are stored in the time_stamp.txt file
5. cd /*/catkin_ws/src/storage/strorage***/ground_truth/, the groundtruth are stored in the ground_truth.txt file



