#!/usr/bin/env python
import rospy
from anavs_rtk_dlr.msg import odometry as odom



def callback(msg):
    # print str(msg.matrix)
    time = msg.header.stamp
    print(time)


def listen_message():
    rospy.init_node('listen_message', anonymous=True)
    mysub = rospy.Subscriber('rtk_groundtruth', odom, callback)
    rospy.spin()


if __name__ == '__main__':
    listen_message()
