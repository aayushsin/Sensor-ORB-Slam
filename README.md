=====================
Hardware requirements
=====================
1. Bumblebee2 BB2-08S2C via FireWire-1394 standard
2. Decawave ranging sensors; one anchor and one tag (serial port connection via a USB cable)
3. ANavs RTK System

=====================
Get the repository
=====================
1. git clone -b <Branch_name: master (indigo) or kinetic> URL
2. Enter your credentials
3. cd <repo_name>

=========
Compile
=========
1. cd <repo_name>
2. delete build, devel
3. chmod +x <repo_name>/src/decawave_driver/src/dist_read.py
4. catkin_make
Hint: If you have errors with your opencv version and installation path, fix the path in CmakeLists.txt of appropriate package as OPENCV_DIR

=============
ROS packages
=============
1.  anavs_rtk_dlr: 
This package reads the anavs_rtk UBX solution and parses it: 
anavs_parser.py: used to decode the UBX solution into corresponding fields
anavs_rtk_node.py: listens to the UBX solution, calls the parser to parse the solution, and publishes a ros topic with the solution artifacts
odometry message: has fields like timestamps, latitude longitude, rtk euler matrix and rotation matrix

2. camera1394: 
ROS driver for cameras that use the IEEE 1394 Digital Camera (IIDC) protocol, such as Chameleon. Only supports the ros indigo version  
http://wiki.ros.org/camera1394/

3. camera1394stereo: 
Stereo version of camera1394. Used as a driver for Bumblebee2. Supports both indigo and kinetic; the kinetic version has a problem with adjusting camera paramsters.
http://wiki.ros.org/camera1394stereo
https://github.com/srv/camera1394stereo
More information about parameters in http://wiki.ros.org/camera1394

4.  decawave_driver: 
This driver reads distance values from the DecaWave TREK1000 modules and publishes a snowmower_msgs/DecaWaveMsgs.msg on the topic decawave/dist.
ranging_test.py: to test the sensors
dist_reader.py: reads the distance via an USB serial port and publish the rostopic /ranger_finder/data

5.  dlr_ranging: 
This driver receives the ranging measurements between two rovers in a swarm system, provided by the DLR’s USRP radio navigation system. The number and IP of the rovers should be set in the launch file. 

6. geometry: 
Optional – to use euler and quarterian conversions

7.  rosbag_recorder: 
bag_to_images.py (in development) converts rosbag to images based on topic name. 

8. sensor_synchronizer: 
The driver synchronizes stereo images, ranging measurements, and RTK odometry using ROS timestamp, and published two following topics: 
/tum_nav/sync_data: all synchronized data (stereo images-rangign-RTK odometry)
/tum_nav/sync_record: truncated synchronized data (for the purpose of smaller data storage)

9.  snowmover_msgs:
ROS message package needed for decawave driver

10. ueye_cam: 
A ROS nodelet and node that wraps the driver API for UEye cameras by IDS Imaging Development Systems GMBH.

========
Steps
========
1. source devel/setup.bash
* OPTIONAL: add <repo_name>/devel/setup.bash in your .bashrc using sudo nano ~/.bashrc. Then, you do not have to execute line1 every time you open a new terminal.
2. sudo chmod 666 /dev/ttyACM*: normally, it should be "/dev/ttyACM0". If not, modify:
    a. <repo_name>/src/read_dw_camera_dist.launch and
    b. <repo_name>/src/decawave_driver/src/dist_read.py with right enumeration
3. Run the ANavsWizard for receiving the UBX solution after connecting to wifi SSID: ANavs_RTK_Server. Wait a couple of minutes until we can get the fixed solution 
4. Terminal 1 - read all the sensor data;
Modify read_all_sensor.launch, and launch it with roslaunch read_all_sensor.launch. With this, all the systems start to receive the data
    a. Camera paramters (e.g. auto_exposure, auto_gain)
    b. The IP of the ANavS Pi: rtk_module_ip
    c. (The IP, dynamic, and static rover ID of the DLR ranging system: ranging_module_ip, dRoverID, sRoverID)
5. Terminal 2 - synchronize the received sensor data;
Modify src/sensor_synchronizer/launch/synchronizer.launch and launch it with roslaunch sensor_synchronizer synchronizer.launch. With this, all the received sensor data are synchronized and 2 topics (/tum_nav/sync_data, /tum_nav/sync_record) are published
6. Modify arguments in <repo_name>/src/rosbag_recoder/launch/record.launch, and record a rosbag file with roslaunch rosbag_recorder record.launch 

===========
Checklist
===========
1. In the Terminal 1, the "image 0" and “image 1” are the left and right camera images. The counter of the image pair, and absolute ros time, in between there would be "UW time" referred to the data from range finder followed by ros time and distance in m. Also, the RTK output data is shown
2. In the Terminal 2, "Ranging measurement [m]"should be printed out.

====================================
Data storage as png and text files
====================================
Parameter setting in <repo_name>/src/sensor_synchronizer/launch/synchronizer.launch:
1. recording_image_frame: minimum number of frames between the stored images; default 2. 
2. recording_image_second: minimum time difference between the stored images; default 0.040. 
3. use_recording_image_second: if true, the synchronizer uses the time difference as a criteria. If false, it uses the frame number; default true 
4. storage_mode: default false

Stored data:
1. Timestamps: <repo_name>/src/storage/strorage***/time_stamp/time_stamp.txt
2. Left images: <repo_name>/src/storage/strorage***/left_image_data/*.png
3. Right images: <repo_name>/src/storage/strorage***/right_image_data/*.png
4. Ranging: <repo_name>/src/storage/strorage***/distance_data/range.txt
5. RTK odometry (with matrices): <repo_name>/src/storage/strorage***/ground_truth/ground_truth.txt 
6. RTK odometry (with angles): <repo_name>/src/storage/strorage***/ground_truth/ground_truth_euler.txt





