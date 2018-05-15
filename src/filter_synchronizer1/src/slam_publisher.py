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
import rospkg
from filter_synchronizer1.msg import slamMsg

class slam_publisher:

    def __init__(self):
        # ------------------------------------------------------------------------------
        # init values
        self.slam_pub = slamMsg()
        # ------------------------------------------------------------------------------
        # create publisher, subscriber and node handle
        self.pub_slam_bag = rospy.Publisher('stereoslam_bag', slamMsg, queue_size=10)
        rospy.init_node('slam_publisher', anonymous=True)
        # ------------------------------------------------------------------------------
        # main loop
        rate = rospy.Rate(100)
        while not rospy.is_shutdown():
            self.build_slam_bag()
            rate.sleep()

    def build_slam_bag(self):
        self.slam_pub.range = 10
        self.pub_slam_bag.publish(self.slam_pub)

if __name__ == '__main__':
    try:
        node = slam_publisher()
    except rospy.ROSInterruptException:
        pass

