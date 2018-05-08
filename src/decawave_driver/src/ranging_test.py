# -*- coding: utf-8 -*-
import Tkinter, tkFileDialog
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import norm
from scipy.stats.kde import gaussian_kde
from numpy import linspace
from scipy.interpolate import UnivariateSpline

if __name__ == "__main__":
    root = Tkinter.Tk()
    root.withdraw()

    file_path = tkFileDialog.askopenfilename()
    f = open(file_path,"r")
    try:
        plt.subplot(2, 1, 1)
        data=f.read().split('\n')
        data = [float(i) for i in data if i]
        plt.xlabel('Time')
        plt.ylabel("Distance(m)")
        plt.plot(data)

        plt.subplot(2, 1, 2)
        # this create the kernel, given an array it will estimate the probability over that values
        kde = gaussian_kde(data)
        # these are the values over wich your kernel will be evaluated
        dist_space = linspace(min(data), max(data), 100)
        # plot the results
        plt.xlabel('Frequency')
        #plt.text(1, 1, r'$\mu=100,\ \sigma=15$')
        #plt.ylabel("Distance(m)")
        plt.plot(dist_space, kde(dist_space))
        plt.show()
        print 'Mean : ' + str(np.mean(data))
        print 'Standard Deviation :' + str(np.std(data))
        print 'Variation : ' + str(max(data)-min(data))



    finally:
        f.close()
