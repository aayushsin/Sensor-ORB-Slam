# -*- coding: utf-8 -*-
import Tkinter, tkFileDialog
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats.kde import gaussian_kde
from numpy import linspace
import matplotlib.mlab as mlab
import math

if __name__ == "__main__":
    root = Tkinter.Tk()
    root.withdraw()

    file_path = tkFileDialog.askopenfilename()
    f = open(file_path,"r")
    try:
        #plt.subplot(2, 1, 1)
        fig, ax = plt.subplots()
        data=f.read().split('\n')
        data = [float(i) for i in data if i]
        #plt.xlabel('Time')
        #plt.ylabel("Distance(m)")
        #plt.plot(data)

        #plt.subplot(2, 1, 2)
        # this create the kernel, given an array it will estimate the probability over that values
        kde = gaussian_kde(data)
        # these are the values over wich your kernel will be evaluated
        dist_space = linspace(min(data), max(data), 100)
        # plot the results
        plt.xlabel('Distance(m)')
        plt.ylabel('Number of observations')


        # these are matplotlib.patch.Patch properties
        props = dict(boxstyle='round', facecolor='wheat', alpha=0.5)
        mean = np.mean(data)
        sigma= np.std(data)
        x_th = np.linspace(mean - 3 * sigma, mean + 3 * sigma, 100)
        textstr = '$\mu=%.3f$\n$\mathrm{Variation}=%.3f$\n$\sigma=%.3f$\n$Deviation Height=%.4f$' % (mean, max(data)-min(data), sigma,max(x_th)-max(data))
        # place a text box in upper left in axes coords
        ax.text(0.05, 0.95, textstr, transform=ax.transAxes, fontsize=14, verticalalignment='top', bbox=props)
        #plt.xlim(109.5,110.5)
        plt.plot(dist_space, kde(dist_space),'b')
        plt.plot(x_th,mlab.normpdf(x_th, mean, sigma),'r')
        plt.savefig('ranging_tests/Range_pinakothen_11  0_1.png')
        plt.show()
        print 'Mean : ' + str(np.mean(data))
        print 'Standard Deviation :' + str(np.std(data))
        print 'Variation : ' + str(max(data)-min(data))
        print np.max(x_th)-np.max(data)
    finally:
        f.close()
