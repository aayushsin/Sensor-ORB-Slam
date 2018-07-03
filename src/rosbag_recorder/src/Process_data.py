# -*- coding: utf-8 -*-
import binascii
import binhex
import pynmea2


def decode_GGA(string):
    msg = pynmea2.parse(string)
    timestamp = msg.timestamp
    lat = u'%02d\xb0%02d\u2032%07.4f\u2033' % (msg.latitude, msg.latitude_minutes, msg.latitude_seconds)  # msg.lat
    lat_dir = msg.lat_dir
    lng = u'%02d\xb0%02d\u2032%07.4f\u2033' % (msg.longitude, msg.longitude_minutes, msg.longitude_seconds)  # msg.lon
    lng_dir = msg.lon_dir
    abc = 1


def decode_VTG(string):
    msg = pynmea2.parse(string)
    abc = 1


def decode_ZDA(string):
    msg = pynmea2.parse(string)
    abc = 1


def decode_RMC(string):
    msg = pynmea2.parse(string)
    abc = 1


def decode_PASHR(string):
    data = string.split(',')
    key = ['id', 'timestamp', 'heading', 'heading_true', 'roll', 'pitch', 'heave', 'roll_std', 'pitch_std',
           'heading_std', 'quality']
    msg = dict(zip(key, data))
    abc = 1


if __name__ == "__main__":
    abc = 1
    f = open("/home/aayush/ANavS_RTK_Software2/Scripts_for_RPis/ncat/20180323_1329.txt", "rb")
    try:
        string = f.readline()
        while string:
            if 'GGA' in string:  # GPS Fix
                decode_GGA(string)
            if 'VTG' in string:  # Course over ground and ground speed
                decode_VTG(string)
            if 'ZDA' in string:  # Time
                decode_ZDA(string)
            if 'RMC' in string:  # Recommended GNSS data
                decode_RMC(string)
            if 'PASHR' in string:  # Atitude Data
                decode_PASHR(string)
            string = f.readline()
    finally:
        f.close()

        """        
def decode(string):
    print string[2:4] + string[:2]
    len_payload = int(string[2:4] + string[:2], 16)  # in bytes_group of 2
    checksum = string[2 * len_payload + 4:len(string)]
    payload = string[4:len(string) - 4]  # length of payload can be calculated too here
    timing_info = payload[2:18]
    accelerometer_x_axis = int(payload[18:22], 16) - 0x8000
    accelerometer_y_axis = int(payload[22:26], 16) - 0x8000
    accelerometer_z_axis = int(payload[26:30], 16) - 0x8000
    gyroscope_x_axis = int(payload[30:34], 16) - 0x8000
    gyroscope_y_axis = int(payload[34:38], 16) - 0x8000
    gyroscope_z_axis = int(payload[38:42], 16) - 0x8000
    iTOW = int(timing_info[:4], 16)
    fTOW = int(timing_info[4:8], 16) - 0x80000000
    gps_time2 = (iTOW * 10 ** (-3)) + (fTOW * 10 ** (-9))
    n_week = int(timing_info[8:10], 16) - 0x80
    gps_time = int(timing_info, 16)  # in ms


def twos_comp(val, bits):
    #compute the 2's complement of int value val
    if (val & (1 << (bits - 1))) != 0:  # if sign bit is set e.g., 8bit: 128-255
        val = val - (1 << bits)  # compute negative value
    return val

    while i < 2:
        string_new = binascii.b2a_hex(byte)
        text += string_new
        # print binascii.b2a_hex(byte)
        strings = text.split('b56202')
        for idx in xrange(len(strings) - 1):
            if strings[idx][:2] == '49':
                decode(strings[idx][2:])
            else:
                print(strings[idx][:2])
        text = strings[-1]
        byte = str(f.readline())
        i += 1

    """
