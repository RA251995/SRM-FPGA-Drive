from serial import Serial

import matplotlib.pyplot as plt
import numpy as np

def live_plotter(x_vec,y1_data,line1,identifier='',pause_time=0.000001):
    if line1==[]:
        plt.ion()
        fig = plt.figure(figsize=(13,6))
        ax = fig.add_subplot(111)
        line1, = ax.plot(x_vec,y1_data,'-o',alpha=0.8)        
        plt.show()
    
    line1.set_ydata(y1_data)
    if np.min(y1_data)<=line1.axes.get_ylim()[0] or np.max(y1_data)>=line1.axes.get_ylim()[1]:
        plt.ylim([np.min(y1_data)-np.std(y1_data),np.max(y1_data)+np.std(y1_data)])
    plt.pause(pause_time)
    
    return line1

ser = Serial('COM15', baudrate=115200)
	
size = 500
x_vec = np.linspace(0,1,size+1)[0:-1]
y_vec = np.zeros(len(x_vec))
line1 = []

while True:
    val = ord(ser.read()) << 8 | ord(ser.read())
    y_vec[-1] = val
    line1 = live_plotter(x_vec,y_vec,line1)
    y_vec = np.append(y_vec[1:],0.0)