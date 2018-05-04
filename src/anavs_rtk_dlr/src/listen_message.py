#!/usr/bin/env python
import rospy
from anavs_rtk_dlr.msg import odometry as od
##from anavs_rtk_dlr.msg import odometry as od



def callback(msg):
    abc=1
    print str(msg.matrix)
    print str(msg.header)


def listen_message():
    rospy.init_node('listen_message',anonymous=True)
    mysub = rospy.Subscriber('message_check', od, callback)
    rospy.spin()
#mysub = rospy.Subscriber('mytopic', od, mytopic_callback)

if __name__ == '__main__':
    listen_message()

