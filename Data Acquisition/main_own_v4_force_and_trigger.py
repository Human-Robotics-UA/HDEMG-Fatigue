#echo client.py

#import socket
import numpy as np
import csv
import time
import serial
import pandas as pd
import struct
from serial.tools.list_ports import comports
import matplotlib.pyplot as plt

#devices = [dev for dev in comports() if dev.description == 'OptoForce USB Sensor']
devices = [dev for dev in comports() if dev.description == 'OptoForce USB Sensor (COM7)']

if len(devices) == 0:
    raise RuntimeError(f"Couldn't find an OptoForce")
elif len(devices) == 1:
    dev = devices[0]
else:
    raise RuntimeError(f'Found more than one OptoForce: {devices}')

#devices = "C:\WINDOWS\system32\DRIVERS\usbser.sys"
#Port_#0001.Hub_#0002
#dev = USBPDO-2

SENSOR_PARAMS = {
    'baudrate': 1000_000,
    'stopbits': serial.STOPBITS_ONE,
    'parity': serial.PARITY_NONE,
    'bytesize': serial.EIGHTBITS,
}
#.................................................................................................
#Conversion:
#The Force (or Torque) values are in dimensionless COUNTS that can be converted to N (or
#Nm) by using the values in the sensitivity report.

#For example if the reading is 532 [Counts] from Fx and the sensitivity (Counts@N.C.) is 6100
#and the Nominal Capacity (N.C.) for Fx is 150N, then

#Fx [N] = Fx[Counts] / (Counts@N.C.) * (N.C.) = 532 / 6100 * 150N = 13.08N

#Please note that the force (and torque) values are all signed INT16 values.
#.................................................................................................
#Sample counter UINT16   (fixed at 1 kHz).
#Status UINT16
#Checksum UINT16

SensitivityFx = 1491.0
NC = 200.0 #Nomical Capacity

longitud_actual=0
longitud_previa=0
y_current_value=0
x_value = 0 #indices................
total_1=0
total_2=0
fieldnames = ["x_value", "total_1", "total_2"]
#fieldnames = ["x_value", "total_1"]
#.................................................................................................
with open('data1.csv', 'w') as csv_file:
    csv_writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
    csv_writer.writeheader()



with serial.Serial(dev.device, **SENSOR_PARAMS) as opt_ser:    
    # write sensor setup code
    #Example: In order to set 1000 Hz update rate and 500Hz cut-off frequency and cancel the offset
    #(by zeroing) the 16 bytes to be sent should be the following:
    #170 0 50 3 1 1 255 1 224



    header = (170, 0, 50, 3)
    #header = (170, 7, 8, 16)
    speed = 1  # 0: stops the transmission, 1 = 1000 Hz, 10 = 100 Hz, 
    filt = 0   # don't pre-filter data
    zero = 255
    checksum = sum(header) + speed + filt + zero
    payload = (*header, speed, filt, zero, *checksum.to_bytes(2, 'big', signed=False))
    opt_ser.write(bytes(payload))

    
    while True:
    #for i in range(0,10000):
    #................................................................................................
        #s = pd.read_csv("data2.txt", sep=" ", header=None)
        #s.columns = ["total_2"]
        #longitud_actual = len(s["total_2"])

        #longitud_actual = len(pd.read_csv("data2.txt", sep=" ", header=None))
        #with open('data2.csv', 'w') as csv_file:


 
            
        #longitud_previa=longitud_actual
        #y_trigger
        #y_current_value = y_trigger[-1]
    #................................................................................................

        with open('data2.txt', 'r') as txt_file2:

            with open('data1.csv', 'a') as csv_file:

                longitud_actual = int(len(txt_file2.read())/2)

                if longitud_actual>longitud_previa:
                    y_current_value=1
                    longitud_previa=longitud_actual
                else:
                    y_current_value=0

                csv_writer = csv.DictWriter(csv_file, fieldnames=fieldnames)

                info = {
                    "x_value": x_value,
                    "total_1": total_1,
                    "total_2": total_2,
                }

                expected_header = bytes((170, 7, 8, 16))
                opt_ser.read_until(expected_header)

                count, status, fx, fy, fz, tx, ty, tz, checksum = (
                    struct.unpack('>HHhhhhhhH', opt_ser.read(18))
                )

                csv_writer.writerow(info)
                print(x_value, total_1, total_2)
            
                fzN = (fz/SensitivityFx)*NC

                if (fzN<-255 or fzN>255):
                    fzN=0

                x_value += 1
                total_1 = fzN
                total_2 = y_current_value

                #print(x_value, total_1)
                
            #time.sleep(0.001)

