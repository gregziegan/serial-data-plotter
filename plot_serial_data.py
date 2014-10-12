#!usr/bin/python
import serial
import time
import re
import numpy as np
import pylab

ser = serial.Serial(
    port='/dev/ttyACM0'
)

x_data, y_data = [120], [120]

pylab.ion()
graph = pylab.plot(x_data, y_data)[0]

while True:
    full_buffer = str(ser.read(ser.inWaiting()))
    last_received = None
    last_line = None
    if '\n' in full_buffer:
        lines = full_buffer.split('\r\n')
        last_received = lines[-2]
        last_line = lines[-1]

    input_data = last_received if not last_line else last_line
    if 'Y' in input_data:
        x_data.append(re.search(r'\((\d+)\);\s+Y:', input_data).group(1))
        y_data.append(re.search(r'\((\d+)\)\s*$', input_data).group(1))
        print(x_data)
        print(y_data)

    graph.set_xdata(x_data)
    graph.set_ydata(y_data)
    pylab.draw()

    time.sleep(1)

ser.close()