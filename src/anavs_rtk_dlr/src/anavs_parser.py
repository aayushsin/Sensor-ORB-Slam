import struct


class ANAVSParserUBX:
    def __init__(self):
        self.code = None

    def parse(self, text):
        resCode = list(reversed(str(bin(2 ** 17 + struct.unpack('H', text[6 + 1:6 + 3])[0]))))
        self.code = 0
        if resCode[12] == '0' and resCode[11] == '1':
            self.code = 1
        if resCode[12] == '1' and resCode[11] == '0':
            self.code = 5
        if resCode[12] == '1' and resCode[11] == '1':
            self.code = 4

        self.week = float(struct.unpack('H', text[6 + 3:6 + 5])[0]) #1996
        self.seconds = struct.unpack('d', text[6 + 5:6 + 13])[0]
        self.baseline_x = struct.unpack('d', text[6 + 49 + 8:6 + 49 + 16])[0] #e
        self.baseline_y = struct.unpack('d', text[6 + 49 + 0:6 + 49 + 8])[0] #N
        self.baseline_z = -struct.unpack('d', text[6 + 49 + 16:6 + 49 + 24])[0] #u
        self.latitude = struct.unpack('d', text[6 + 25:6 + 33])[0]
        self.longitude = struct.unpack('d', text[6 + 33:6 + 41])[0]
        self.height = struct.unpack('d', text[6 + 41:6 + 49])[0]
        self.heading = 360.0 - (struct.unpack('d', text[6 + 193 + 0:6 + 193 + 8])[0])
        self.elevation = struct.unpack('d', text[6 + 193 + 8:6 + 193 + 16])[0]
        self.bank = struct.unpack('d', text[6 + 193 + 16:6 + 193 + 24])[0]
        self.velocity_x = struct.unpack('d', text[6 + 97 + 8:6 + 97 + 16])[0]
        self.velocity_y = struct.unpack('d', text[6 + 97 + 0:6 + 97 + 8])[0]
        self.velocity_z = -struct.unpack('d', text[6 + 97 + 16:6 + 97 + 24])[0]
        self.num_GPS = struct.unpack('B', text[6 + 257 + 80:6 + 258 + 80])[0]
        self.num_GLO = float('nan')

    def __str__(self):
        rval = 'RTK data:\n'
        rval += 'Code: ' + str(self.code) + '\n'
        rval += 'GPS week number: ' + str(self.week) + '\n'
        rval += 'seconds of the week: ' + str(self.seconds) + '\n'
        rval += 'baseline x (ENU [m]): ' + str(self.baseline_x) + '\n'
        rval += 'baseline y (ENU [m]): ' + str(self.baseline_y) + '\n'
        rval += 'baseline z (ENU [m]): ' + str(self.baseline_z) + '\n'
        rval += 'latitude (WGS84): ' + str(self.latitude) + '\n'
        rval += 'longitude (WGS84): ' + str(self.longitude) + '\n'
        rval += 'height (WGS84): ' + str(self.height) + '\n'
        rval += 'heading [deg]: ' + str(self.heading) + '\n'
        rval += 'pitch [deg]: ' + str(self.elevation) + '\n'
        rval += 'roll [deg]: ' + str(self.bank) + '\n'
        rval += 'velocity x [m/s]: ' + str(self.velocity_x) + '\n'
        rval += 'velocity y [m/s]: ' + str(self.velocity_y) + '\n'
        rval += 'velocity z [m/s]: ' + str(self.velocity_z) + '\n'
        rval += 'number of GPS sats: ' + str(self.num_GPS) + '\n'
        rval += 'number of GLONASS sats ' + str(self.num_GLO) + '\n'
        return rval
