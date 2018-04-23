from netcat import Netcat
import struct
import binascii
import datetime
import numpy as np
import math
import csv


def decodeUBX(string):
    print string
    if len(string) <100:
        return 0
    codes = [string[i:i + 2] for i in range(0, len(string), 2)]
    len_payload = len(codes) - 5  # in bytes #int(string[4:6]+string[2:4],16)   # (len(string)-10)/2
    checksum_A = codes[-2]
    checksum_B = codes[-1]
    payload = codes[3:len(codes) - 2]
    week = int(payload[4] + payload[3], 16)  # uint16 little Endian
    if week == 0:
        return 0
    towStr = "".join(reversed(payload[5:13]))  # double litte Endian
    try:
        tow = struct.unpack("d", struct.pack("q", int(towStr, 16)))[0]
    except struct.error:
        return 0
    latitude_str = "".join(reversed(payload[25:33]))
    try:
        latitude = struct.unpack("d", struct.pack("q", int(latitude_str, 16)))[0]
    except struct.error:
        return 0
    longitude_str = "".join(reversed(payload[33:41]))
    try:
        longitude = struct.unpack("d", struct.pack("q", int(longitude_str, 16)))[0]
    except struct.error:
        return 0
    height_str = "".join(reversed(payload[41:49]))
    height = struct.unpack("d", struct.pack("q", int(height_str, 16)))[0]
    UTC_time = weeksecondstoutc(week, tow, 16)
    north_str = "".join(reversed(payload[49:57]))
    try:
        north = struct.unpack("d", struct.pack("q", int(north_str, 16)))[0]
    except struct.error:
        north = 'n/a'
    east_str = "".join(reversed(payload[57:65]))
    try:
        east = struct.unpack("d", struct.pack("q", int(east_str, 16)))[0]
    except struct.error:
        east = 'n/a'
    down_str = "".join(reversed(payload[65:73]))
    try:
        down = struct.unpack("d", struct.pack("q", int(down_str, 16)))[0]
    except struct.error:
        down = 'n/a'
    heading_str = "".join(reversed(payload[193:201]))
    try:
        heading = struct.unpack("d", struct.pack("q", int(heading_str, 16)))[0]
        heading_matrix = np.array(
            [[math.cos(heading), -math.sin(heading), 0], [math.sin(heading), math.cos(heading), 0], [0, 0, 1]])
    except struct.error:
        heading = 'n/a'
    pitch_str = "".join(reversed(payload[201:209]))
    try:
        pitch = struct.unpack("d", struct.pack("q", int(pitch_str, 16)))[0]
        pitch_matrix = np.array(
            [[math.cos(pitch), 0, math.sin(pitch)], [0, 1, 0], [-math.sin(pitch), 0, math.cos(pitch)]])
    except struct.error:
        pitch = 'n/a'
    roll_str = "".join(reversed(payload[209:217]))
    try:
        roll = struct.unpack("d", struct.pack("q", int(roll_str, 16)))[0]
        roll_matrix = np.array(
            [[1, 0, 0], [0, math.cos(roll), -math.sin(roll)], [0, math.sin(roll), math.cos(roll)]])
    except struct.error:
        roll = 'n/a'
    myFile = open('/home/aayushsingla/catkin_ws/src/bag_images/example.csv', 'a')
    data = [[UTC_time, str(north), str(east), str(down), str(heading), str(pitch), str(roll)]]
    with myFile:
        writer = csv.writer(myFile)
        writer.writerows(data)



def calcValue(string):
    try:
        value = struct.unpack("d", struct.pack("q", int(string, 16)))[0]
    except struct.error:
        value ='n/a'
    return value

def binaryToFloat(value):
    hx = hex(int(value, 2))
    return struct.unpack("d", struct.pack("q", int(hx, 16)))[0]


def weeksecondstoutc(gpsweek, gpsseconds, leapseconds):
    datetimeformat = "%Y-%m-%d %H:%M:%S"
    epoch = datetime.datetime.strptime("1980-01-06 00:00:00", datetimeformat)
    elapsed = datetime.timedelta(days=(gpsweek * 7), seconds=(gpsseconds + leapseconds))
    return datetime.datetime.strftime(epoch + elapsed, datetimeformat)


#def decode2(string):
#    print string

if __name__ == "__main__":
    # start a new Netcat() instance
    # nc = Netcat('10.42.0.99', 6001) #ethernet
    nc = Netcat('192.168.42.1', 6001)  # wifi
    """
    myFile = open('/home/aayushsingla/catkin_ws/src/bag_images/example.csv', 'w')
    data = [['Timestamp', 'North', 'East', 'Down', 'Heading_angle', 'Pitch_angle', 'Roll_angle']]
    with myFile:
        writer = csv.writer(myFile)
        writer.writerows(data)
    """
    while True:
        recv = nc.read()
        recv = nc.read_until('b56202')
        if not recv: break
        # print recv  # for nmea
        print '----------------------------------------'
        b = bytearray(recv)
        test = binascii.hexlify(b)
        #print test
        decodeUBX(test)  # for ubx
    abc = 1  # finished

