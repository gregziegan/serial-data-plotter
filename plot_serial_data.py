# Greg Ziegan (grz5)
# Matt Prosser (mep99)
# Unfinished: We switched to writing the project in bash. Here's proof that we spent a decent amount of time toying with python, though.

############ DO NOT GRADE THIS %%%%%%%%%%%%%%%%%

import serial
import numpy as np
from matplotlib import pyplot as plt
import re
import time

ser = serial.Serial('/dev/ttyACM0', 9600)

plt.ion()  # set plot to animated

x1_data = [0] * 50
y1_data = [0] * 50
ax1 = plt.axes()

# make plot
x1_line = plt.plot(x1_data)
y1_line = plt.plot(y1_data)

plt.ylim([10, 40])

# start data collection
t_data = [i for i in range(50)]
while True:
    ymin = float(min(y1_data))-10
    ymax = float(max(y1_data))+10

    plt.ylim([ymin, ymax])
    plt.xlim([t_data[0], t_data[-1]])

    full_buffer = str(ser.read(ser.inWaiting()))
    last_received = None
    last_line = None
    if '\n' in full_buffer:
        lines = full_buffer.split('\r\n')
        last_received = lines[-2]
        last_line = lines[-1]

    input_data = last_received if not last_line else last_line

    if input_data and len(input_data) > 52 and 'Y' in input_data:
        print input_data
        x1_data.append(float(re.search(r'\((\d+)\);\s+Y:', input_data).group(1)))
        y1_data.append(float(re.search(r'\((\d+)\)\s*$', input_data).group(1)))
        print "x1_data:", x1_data
        print "y1_data:", y1_data

        x1_line.set_xdata(np.arange(len(x1_data)))
        y1_line.set_xdata(np.arange(len(y1_data)))
        del x1_data[0]
        del y1_data[0]
        x1_line.set_xdata(t_data)
        x1_line.set_ydata(x1_data)
        y1_line.set_xdata(t_data)
        y1_line.set_ydata(y1_data)  # update the data
        plt.pause(0.1)
        plt.draw()  # update the plot
        time.sleep(.1)
