# -*- coding: utf-8 -*-
import numpy as np
import cv2 as cv

if __name__ == "__main__":
    abc = 1
    L_d= np.array([-0.316955, 0.080999, 0.007374, -0.004314, 0.000000]).reshape(1,5)
    R_d = np.array([-0.304781, 0.086020, 0.006177, 0.004478, 0.000000])
    L_k = np.array([565.293210, 0.000000, 524.446862, 0.000000, 566.514384, 363.478677, 0.000000, 0.000000, 1.000000]).reshape(3,3)
    R_k = np.array([547.285220, 0.000000, 523.929444, 0.000000, 546.383520, 378.999426, 0.000000, 0.000000, 1.000000]).reshape(3,3)
    newCam , roi = cv.getOptimalNewCameraMatrix(L_k,L_d,(1024,768),1,(1024,768))
   # real signature unknown; restored from __doc__
    """ getOptimalNewCameraMatrix(cameraMatrix, distCoeffs, imageSize, alpha[, newImgSize[, centerPrincipalPoint]]) -> retval, validPixROI """

    """
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