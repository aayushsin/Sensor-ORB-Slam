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
        self.tcp_ip = rospy.get_param('/rtk_module_ip', "localhost") # dummy_receiver (PAD_solution)
        # self.tcp_ip = rospy.get_param('rtk_module_ip', "192.168.42.1") # tum-nav
        #self.tcp_ip = rospy.get_param('/anavs_rtk_node/rtk_module_ip', "192.168.42.1")  # dlr-kn: Columbus (pw: #LocoExplo#)
        
        # ------------------------------------------------------------------------------
        # create publisher, subscriber and node handle
        self.pub_odometry = rospy.Publisher('rtk_odometry_static', odom, queue_size=10)
        self.pub_nav = rospy.Publisher('gnss_nav_static', NavSatFix, queue_size=10)
        self.pub_time = rospy.Publisher('gnss_time_static', TimeReference, queue_size=10)
        rospy.init_node('anavs_rtk_static_node', anonymous=True)

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
                    # TODO: Remove 1 from the statement
                    if self.parser.code == 4 or self.parser.code == 5 or self.parser.code == 1:  ## 1 added just for test
                        current_time = rospy.Time.now()
                        self.build_odometry_msg(current_time, self.parser.code)
                        self.build_nav_msg(current_time)
                        self.build_time(current_time)

            rate.sleep()

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
        self.odometry_msg.header.stamp = current_time
        self.odometry_msg.header.frame_id = "base"

        self.odometry_msg.pose.pose.position.x = self.parser.baseline_x
        self.odometry_msg.pose.pose.position.y = self.parser.baseline_y
        self.odometry_msg.pose.pose.position.z = self.parser.baseline_z

        translation_vector = np.array([[self.parser.baseline_x, self.parser.baseline_y, self.parser.baseline_z]])
        euler_angles = np.array(
            [[self.parser.bank * np.pi / 180, self.parser.elevation * np.pi / 180, self.parser.heading * np.pi / 180]])

	# Rotation sequence from B to MSM: 321 => rotation_matrix: rotm_msm2base
	rotation_matrix = self.build_r3(self.parser.heading * np.pi / 180) * self.build_r2(self.parser.elevation * np.pi / 180) * self.build_r1(self.parser.bank * np.pi / 180) 
        rotation_matrix = np.asarray(rotation_matrix)

        self.rtk_groundtruth.header.stamp = current_time
        self.rtk_groundtruth.header.frame_id = "base"
        self.rtk_groundtruth.rtk_matrix_euler = np.concatenate([translation_vector.flatten(), euler_angles.flatten()])
        self.rtk_groundtruth.rtk_matrix_rotm = np.concatenate([translation_vector.flatten(), rotation_matrix.flatten()])
        self.rtk_groundtruth.rtk_longitude = self.parser.longitude
        self.rtk_groundtruth.rtk_latitude = self.parser.latitude


        self.pub_odometry.publish(self.rtk_groundtruth)

        # self.pub_odometry.publish(self.odometry_msg)

    def build_r1(self, alpha):
        rot_matrix = np.matrix(
            [[1, 0, 0], [0, math.cos(alpha), -math.sin(alpha)], [0, math.sin(alpha), math.cos(alpha)]])
        return rot_matrix

    def build_r2(self, alpha):
        rot_matrix = np.matrix(
            [[math.cos(alpha), 0, math.sin(alpha)], [0, 1, 0], [-math.sin(alpha), 0, math.cos(alpha)]])
        return rot_matrix

    def build_r3(self, alpha):
        rot_matrix = np.matrix(
            [[math.cos(alpha), -math.sin(alpha), 0], [math.sin(alpha), math.cos(alpha), 0], [0, 0, 1]])
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
