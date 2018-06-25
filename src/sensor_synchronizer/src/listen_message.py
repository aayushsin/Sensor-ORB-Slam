#!/usr/bin/env python
import rospy
from filter_synchronizer1.msg import slamMsg



def callback(msg):
    time = msg.header.stamp
    print(msg.image_l_mat)
    print msg.range


def listen_message():
    rospy.init_node('listen_message', anonymous=True)
    mysub = rospy.Subscriber('/rover_status', slamMsg, callback)
    rospy.spin()


if __name__ == '__main__':
    listen_message()
