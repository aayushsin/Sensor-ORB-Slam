# -*- coding: utf-8 -*-
import binascii
import struct
import datetime, calendar
import numpy as np
import math
import csv


def decode(string):
    codes = [string[i:i + 2] for i in range(0, len(string), 2)]
    payload = codes[3:len(codes) - 2]
    week = int(payload[4] + payload[3], 16)  # uint16 little Endian
    if week == 0: return 0
    towStr = "".join(reversed(payload[5:13]))  # double litte Endian
    tow = calcValue(towStr)
    if tow == 'n/a': return 0
    latitude_str = "".join(reversed(payload[25:33]))
    latitude = calcValue(latitude_str)
    if latitude == 'n/a': return 0
    longitude_str = "".join(reversed(payload[33:41]))
    longitude = calcValue(longitude_str)
    if longitude == 'n/a': return 0
    height_str = "".join(reversed(payload[41:49]))
    #height = struct.unpack("d", struct.pack("q", int(height_str, 16)))[0]
    UTC_time = weeksecondstoutc(week, tow, 0)
    north_str = "".join(reversed(payload[49:57]))
    north = calcValue(north_str)
    east_str = "".join(reversed(payload[57:65]))
    east = calcValue(east_str)
    down_str = "".join(reversed(payload[65:73]))
    down = calcValue(down_str)
    heading_str = "".join(reversed(payload[193:201]))
    heading = calcValue(heading_str)
    if heading != 'n/a':
        heading_matrix = np.array(
            [[math.cos(heading), -math.sin(heading), 0], [math.sin(heading), math.cos(heading), 0], [0, 0, 1]])
    pitch_str = "".join(reversed(payload[201:209]))
    pitch = calcValue(pitch_str)
    if pitch != 'n/a':
        pitch_matrix = np.array(
            [[math.cos(pitch), 0, math.sin(pitch)], [0, 1, 0], [-math.sin(pitch), 0, math.cos(pitch)]])
    roll_str = "".join(reversed(payload[209:217]))
    roll = calcValue(roll_str)
    if roll != 'n/a':
        roll_matrix = np.array(
            [[1, 0, 0], [0, math.cos(roll), -math.sin(roll)], [0, math.sin(roll), math.cos(roll)]])
    myFile = open('/home/aayushsingla/catkin_ws/src/rosbag_recoder/src/example.csv', 'a')
    data = [[UTC_time, str(north), str(east), str(down), str(heading), str(pitch), str(roll)]]
    with myFile:
        writer = csv.writer(myFile)
        writer.writerows(data)
    abc = 1


def binaryToFloat(value):
    hx = hex(int(value, 2))
    return struct.unpack("d", struct.pack("q", int(hx, 16)))[0]


def calcValue(string):
    try:
        value = struct.unpack("d", struct.pack("q", int(string, 16)))[0]
    except struct.error:
        value = 'n/a'
    return value


def weeksecondstoutc(gpsweek, gpsseconds, leapseconds):
    datetimeformat = "%Y-%m-%d %H:%M:%S"
    epoch = datetime.datetime.strptime("1980-01-06 00:00:00", datetimeformat)
    elapsed = datetime.timedelta(days=(gpsweek * 7), seconds=(gpsseconds + leapseconds))
    return datetime.datetime.strftime(epoch + elapsed, datetimeformat)


if __name__ == "__main__":
    f = open("/home/aayushsingla/ANavS_RTK_Software/ANavS_RTK_Wizard/ANavS_PAD/output_data/20180412_1714/PAD_solution.txt",
             "rb")
    try:
        byte = f.read()
        if not byte:
            exit()
        b = bytearray(byte)
        text = binascii.hexlify(b)
        strings = text.split('b56202')
        myFile = open('/home/aayushsingla/catkin_ws/src/rosbag_recoder/src/example.csv', 'w')
        data = [['Timestamp', 'North', 'East', 'Down', 'Heading_angle', 'Pitch_angle', 'Roll_angle']]
        with myFile:
            writer = csv.writer(myFile)
            writer.writerows(data)
        for idx in xrange(1, len(strings)):
            decode(strings[idx])
    finally:
        f.close()
