#!/usr/bin/env python
import rospy
from filter_synchronizer1.msg import slamMsg



def callback(msg):
    time = msg.header.stamp
    print(time)
    print msg.range


def listen_message():
    rospy.init_node('listen_message', anonymous=True)
    mysub = rospy.Subscriber('stereoslam_bag', slamMsg, callback)
    rospy.spin()


if __name__ == '__main__':
    listen_message()
