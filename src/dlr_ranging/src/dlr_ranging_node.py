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

import dlr_ranging_parser
import rospkg
#from nav_msgs.msg import Odometry
#from anavs_rtk_dlr.msg import odometry as odom
from dlr_ranging.msg import ranging_msg
#from sensor_msgs.msg import NavSatFix, TimeReference

# TCP_IP = "192.168.20.53" #'localhost'
TCP_PORT = 52001

#LEAPSECONDS = 37

class DLRRangingNode:
    def __init__(self):
        # ------------------------------------------------------------------------------
        # init values
        self.text_buffer = ' '
        self.parser = dlr_ranging_parser.DLRRangingParser()
        self.ranging_msg = ranging_msg()
        self.ranging_all_msg = ranging_msg()
        self.ranging_cut_msg = ranging_msg()
        self.tcp_ip =  rospy.get_param('/dlr_ranging_node/ranging_module_ip') 
        #self.tcp_ip =  rospy.get_param('/dlr_ranging_node/ranging_module_ip', "192.168.20.12") # Columbus
        #self.tcp_ip =  rospy.get_param('/dlr_ranging_node/ranging_module_ip', "192.168.20.42") # Drake
        #self.tcp_ip =  rospy.get_param('/dlr_ranging_node/ranging_module_ip', "localhost") # dummy_receiver (Log_Ranging.txt)
        
        self.dRoverID = rospy.get_param('/dlr_ranging_node/dRoverID')
        self.sRoverID = rospy.get_param('/dlr_ranging_node/sRoverID')
        
        print 'dRoverID: ', self.dRoverID
        print 'sRoverID: ', self.sRoverID

        # ------------------------------------------------------------------------------
        # create publisher, subscriber and node handle
        self.pub_ranging_all = rospy.Publisher('/dlr_kn/dist_estimates_all', ranging_msg, queue_size=10)
        self.pub_ranging_cut = rospy.Publisher('/dlr_kn/dist_estimates_cut', ranging_msg, queue_size=10)
        #rospy.init_node('dlr_ranging_node', anonymous=True) 
        rospy.init_node('dlr_ranging_node', disable_signals=True)
        # ------------------------------------------------------------------------------
        # create connection
        self.tcp_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.tcp_socket.connect((self.tcp_ip, TCP_PORT))
        self.tcp_socket.setblocking(0)
        print "Connected to DLR range processing module at %s:%d" % (self.tcp_ip, TCP_PORT)

        # ------------------------------------------------------------------------------
        # main loop
        rate = rospy.Rate(10)
        
        try:
	    while not rospy.is_shutdown():
		readable, writable, exceptional = select.select([self.tcp_socket], [], [self.tcp_socket], 1)
		if self.tcp_socket in readable:
		    # we can read from the network, lets do it
		    self.text_buffer += self.tcp_socket.recv(4096)
		    
		    # if we can find a new line we have one complete line in the buffer, parse it
		    indx = self.text_buffer.find('\n')
		    
		    if indx:
			# split off complete line
			line = self.text_buffer[:indx]
			self.text_buffer = self.text_buffer[indx+1:]
			
			if self.parser.parse(line):
			    print self.parser
			    
			    current_time = rospy.Time.now()
			    self.build_ranging_all_msg(current_time)
			    
			    if (self.parser.selfID == self.dRoverID) and (self.parser.neigID == self.sRoverID):
				print 'Distance estimate between the dynamics and static rover is found'
				self.build_ranging_cut_msg(current_time)
				
				rate.sleep()
				
	except KeyboardInterrupt:
	    print 'Keyboard interruptted...'
	
	finally:
	    print 'Close the socket connection...'
	    #self.tcp_socket.shutdown(socket.SHUT_RDWR)
	    self.tcp_socket.close()
		
	    
	
	#self.tcp_socket.shutdown(socket.SHUT_RDWR)
	#self.tcp_socket.close()

    #def __del__(self):
	#print 'Closing socket connection...'
	#self.tcp_socket.shutdown(socket.SHUT_RDWR)
	#self.tcp_socket.close()
	

    def build_ranging_all_msg(self, current_time):
        self.ranging_all_msg.header.stamp = current_time
        self.ranging_all_msg.selfID = self.parser.selfID
        self.ranging_all_msg.neigID = self.parser.neigID
        self.ranging_all_msg.ranging = self.parser.ranging
        self.ranging_all_msg.snr = self.parser.snr
        self.ranging_all_msg.dayInfo = self.parser.dayInfo
        self.ranging_all_msg.timeStamp = self.parser.timeStamp
        
        self.pub_ranging_all.publish(self.ranging_all_msg)
        
    def build_ranging_cut_msg(self, current_time):
        self.ranging_cut_msg.header.stamp = current_time
        self.ranging_cut_msg.selfID = self.parser.selfID
        self.ranging_cut_msg.neigID = self.parser.neigID
        self.ranging_cut_msg.ranging = self.parser.ranging
        self.ranging_cut_msg.snr = self.parser.snr
        self.ranging_cut_msg.dayInfo = self.parser.dayInfo
        self.ranging_cut_msg.timeStamp = self.parser.timeStamp
        
        self.pub_ranging_cut.publish(self.ranging_cut_msg)


if __name__ == '__main__':
    try:
        node = DLRRangingNode()
    except rospy.ROSInterruptException:
        pass
