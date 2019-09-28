from serial import Serial
import numpy as np

ser = Serial('COM15', baudrate=115200)
ser.read()
k = ser.in_waiting
data = np.frombuffer(ser.read(k), dtype=np.uint8)
if sum(data[0:int(k/2)*2:2]) < sum(data[1:int(k/2)*2:2]) :
	print(data[0:int(k/2)*2:2]*256+data[1:int(k/2)*2:2])
else:
	print(data[1:int(k/2)*2:2]*256+data[0:int(k/2)*2:2])