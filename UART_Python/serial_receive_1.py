from serial import Serial
ser = Serial('COM15', baudrate=115200)

while True:
	print(ord(ser.read()))
