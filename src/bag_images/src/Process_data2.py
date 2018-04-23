# -*- coding: utf-8 -*-
import binascii
import binhex
import pynmea2


def decode(string):
    codes = string.split(' ')
    #len_payload = int(codes[5]+codes[4],16)   # len(codes)-8
    #checksum_A = codes[-2]
    #checksum_B=codes[-1]
    payload = codes[6:len(codes)-2]
    week=int(payload[3]+payload[4],16) #uint16
    tow=int(payload[5],16)
    weekInit=int(payload[6]+payload[7],16) #uint16
    towInit=int(payload[8],16)
    latitude=int(payload[11],16)
    longitude=int(payload[12],16)
    height=int(payload[13],16)
    baseline=payload[14]+payload[15]+payload[16]



def twos_comp(val, bits):
    """compute the 2's complement of int value val"""
    if (val & (1 << (bits - 1))) != 0:  # if sign bit is set e.g., 8bit: 128-255
        val = val - (1 << bits)  # compute negative value
    return val


if __name__ == "__main__":
    f = open("/home/aayush/ANavS_RTK_Software2/Scripts_for_RPis/ncat/ssh-hex.log", "rb")
    # msg = pynmea2.parse("$GPGGA,184353.07,1929.045,S,02410.506,E,1,04,2.6,100.00,M,-33.9,M,,0000*6D")

    # print msg
    try:
        text = ''
        i = 0
        byte = f.readline()
        while byte:
            while True:
                strings = byte.split('   ')
                text = text + ' ' + strings[1]
                if strings[2]:
                    text = text + ' ' + strings[2]
                byte = f.readline()
                if '[0000]' in byte:
                    break
            decode(text.strip())
            text = ''
    finally:
        f.close()
