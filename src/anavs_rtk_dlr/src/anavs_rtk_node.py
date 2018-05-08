#!/usr/bin/env python
import roslib
import rospy
import math
import socket
import select
import numpy as np
import os
import tf
import time
import struct
from datetime import datetime, timedelta

import anavs_parser
import rospkg
from nav_msgs.msg import Odometry
from anavs_rtk_dlr.msg import odometry as odom
from sensor_msgs.msg import NavSatFix, TimeReference

# TCP_IP = "192.168.20.53" #'localhost'
TCP_PORT = 6001

LEAPSECONDS = 37


class AnavsRTKNode:
    def __init__(self):
        # ------------------------------------------------------------------------------
        # init values
        self.text_buffer = ' '
        self.parser = anavs_parser.ANAVSParserUBX()
        self.odometry_msg = Odometry()
        self.rtk_groundtruth = odom()
        self.nav_msg = NavSatFix()
        self.gnss_time_msg = TimeReference()
        self.odom_local = Odometry()
        self.tcp_ip = rospy.get_param('rtk_module_ip', "192.168.42.1")

        # ------------------------------------------------------------------------------
        # create publisher, subscriber and node handle
        self.pub_odometry = rospy.Publisher('rtk_odometry', Odometry, queue_size=10)
        self.pub_rtk_groundtruth = rospy.Publisher('rtk_groundtruth', odom, queue_size=10)
        self.pub_nav = rospy.Publisher('gnss_nav', NavSatFix, queue_size=10)
        self.pub_time = rospy.Publisher('gnss_time', TimeReference, queue_size=10)
        rospy.init_node('anavs_rtk_node', anonymous=True)
        self.filepath = str(rospkg.RosPack().get_path('anavs_rtk_dlr')) + '/ground_truth'
        self.file_s = open(self.filepath, "w")

        # ------------------------------------------------------------------------------
        # create connection
        self.tcp_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.tcp_socket.connect((self.tcp_ip, TCP_PORT))
        self.tcp_socket.setblocking(0)
        print "Connected to RTK processing module"

        # ------------------------------------------------------------------------------
        # main loop
        rate = rospy.Rate(10)
        while not rospy.is_shutdown():
            readable, writable, exceptional = select.select([self.tcp_socket], [], [self.tcp_socket], 1)
            if self.tcp_socket in readable:
                self.text_buffer += self.tcp_socket.recv(4096)
                if self.parse_data_ubx():
                    #print rospkg.RosPack().get_path('anavs_rtk_dlr')
                    if self.parser.code == 4 or self.parser.code == 5 or self.parser.code == 1:
                        current_time = rospy.Time.now()
                        self.build_odometry_msg(current_time, self.parser.code)
                        self.build_nav_msg(current_time)
                        self.build_time(current_time)

            rate.sleep()
        self.file_s.close()

    def parse_data_ubx(self):
        header = chr(int('0xb5', 16)) + chr(int('0x62', 16)) + chr(int('0x02', 16)) + chr(int('0xe0', 16))

        idx_start = self.text_buffer.find(header)

        payload_length = 0
        if len(self.text_buffer) > idx_start + 5:
            payload_length = struct.unpack('H', self.text_buffer[idx_start + 4:idx_start + 6])[0]

        if idx_start > 0 and len(self.text_buffer) >= idx_start + payload_length + 8:
            self.text_buffer = self.text_buffer[idx_start:idx_start + payload_length + 8]
            self.parser.parse(self.text_buffer)
            self.text_buffer = ' '
            print self.parser
            return True
        else:
            return False

    def build_odometry_msg(self, current_time, code):
        # todo: angular velocity is missing (may do numerical differtiation) and covariance is  not filled
        self.odometry_msg.header.stamp = current_time
        self.odometry_msg.header.frame_id = "world"

        self.odometry_msg.pose.pose.position.x = self.parser.baseline_x
        self.odometry_msg.pose.pose.position.y = self.parser.baseline_y
        self.odometry_msg.pose.pose.position.z = self.parser.baseline_z

        translation_vector = np.array([[self.parser.baseline_x, self.parser.baseline_y, self.parser.baseline_z]])
        #self.rtk_groundtruth.header.stamp=rospy.Time.now()
        self.rtk_groundtruth.header.stamp = current_time
        self.rtk_groundtruth.header.frame_id = "world"
        rotation_matrix = self.build_r1(self.parser.bank) * self.build_r2(self.parser.elevation) * self.build_r3(
            self.parser.heading)
        self.rtk_groundtruth.matrix = np.concatenate([translation_vector.flatten(), rotation_matrix.flatten()])
        self.file_s.write(str(current_time) + str(np.concatenate([translation_vector.flatten(), rotation_matrix.flatten()])) + '\n')
        print np.concatenate([translation_vector.flatten(), rotation_matrix.flatten()])

        #self.odometry_msg.pose.covariance[0] = 0.001
        #self.odometry_msg.pose.covariance[7] = 0.001
        #self.odometry_msg.pose.covariance[14] = 99999.0
        #self.odometry_msg.pose.covariance[21] = 99999.0
        #self.odometry_msg.pose.covariance[28] = 99999.0
        #self.odometry_msg.pose.covariance[35] = 2.0 / 180.0 * math.pi

        #deg2rad = math.pi / 180.
        # out_R_nb = R1(phi)*R2(theta)*R3(psi);
        #quaternion = tf.transformations.quaternion_from_euler(self.parser.bank * deg2rad,
        #                                                      self.parser.elevation * deg2rad,
        #                                                      self.parser.heading * deg2rad)
        #self.odometry_msg.pose.pose.orientation.x = quaternion[0]
        #self.odometry_msg.pose.pose.orientation.y = quaternion[1]
        #self.odometry_msg.pose.pose.orientation.z = quaternion[2]
        #self.odometry_msg.pose.pose.orientation.w = quaternion[3]

        # self.odometry_msg.twist.twist.linear.x= 0.0 #self.parser.velocity_x
        # self.odometry_msg.twist.twist.linear.y=0.0 #self.parser.velocity_y
        # self.odometry_msg.twist.twist.linear.z=0.0 #self.parser.velocity_z

        #self.odometry_msg.twist.covariance[0] = 0.02
        #self.odometry_msg.twist.covariance[7] = 9999.0
        #self.odometry_msg.twist.covariance[14] = 99999.0
        #self.odometry_msg.twist.covariance[21] = 99999.0
        #self.odometry_msg.twist.covariance[28] = 99999.0
        #self.odometry_msg.twist.covariance[35] = 99999.0
        self.pub_rtk_groundtruth.publish(self.rtk_groundtruth)

        # self.odometry_msg.twist.twist = self.odom_local.twist.twist;

        # Using RTK x and y velocity jointly
        # self.odometry_msg.twist.twist.linear.x= np.sqrt(self.parser.velocity_x*self.parser.velocity_x + self.parser.velocity_y*self.parser.velocity_y);

        # self.odom_broadcaster.sendTransform((self.parser.baseline_x,self.parser.baseline_y, self.parser.baseline_z), quaternion, current_time,"base_footprint","odom")
        self.pub_odometry.publish(self.odometry_msg)

    def build_r1(self, alpha):
        rot_matrix = np.array(
            [[1, 0, 0], [0, math.cos(alpha), math.sin(alpha)], [0, -math.sin(alpha), math.cos(alpha)]])
        return rot_matrix

    def build_r2(self, alpha):
        rot_matrix = np.array(
            [[math.cos(alpha), 0, -math.sin(alpha)], [0, 1, 0], [math.sin(alpha), 0, math.cos(alpha)]])
        return rot_matrix

    def build_r3(self, alpha):
        rot_matrix = np.array(
            [[math.cos(alpha), math.sin(alpha), 0], [-math.sin(alpha), math.cos(alpha), 0], [0, 0, 1]])
        return rot_matrix

    def build_nav_msg(self, current_time):
        self.nav_msg.header.stamp = current_time
        self.nav_msg.latitude = self.parser.latitude
        self.nav_msg.longitude = self.parser.longitude
        self.nav_msg.altitude = self.parser.height

        # the status field is alienated; status is filled with anavs code and service with the number of satelites
        self.nav_msg.status.status = self.parser.code
        self.nav_msg.status.service = self.parser.num_GPS  # +self.parser.num_GLO
        self.pub_nav.publish(self.nav_msg)

    def build_time(self, current_time):
        self.gnss_time_msg.header.stamp = current_time
        seconds = self.parser.seconds + self.parser.week * 604800
        utc = datetime(1980, 1, 6) + timedelta(seconds=seconds - (LEAPSECONDS - 19))
        print utc
        if utc.year != 2018:
            rospy.logwarn('AnavsRTKNode: the leapseconds are set for 2018, please adjust in anavs_rtk_node.py!')
        self.gnss_time_msg.time_ref = rospy.Time.from_sec((utc - datetime(1970, 1, 1)).total_seconds())
        self.pub_time.publish(self.gnss_time_msg)


if __name__ == '__main__':
    try:
        node = AnavsRTKNode()
    except rospy.ROSInterruptException:
        pass
