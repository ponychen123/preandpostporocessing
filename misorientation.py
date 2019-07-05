#!/usr/bin/python3
#this script is expermently used to find the primitive cell while two layers rotate
#onlyt test use
#ponychen 
#20190705
#email:18709821294@outlook.com

import numpy as np

#some basic parameters
step = 0.1    #rotation step
start_angle = 1.0 #start angle of rotation
end_angle = 10   #end angle of rotation, depend on symmetry
m = 11   #supercell dimensions along first axis
n = 11   #supercell dimensions along second axis
ther = 0.1 #thershould for checking whther two atoms are overlapping

a1 = float(input("please input the first axis length of layer1: "))
b1 = float(input("please input the second axis length of layer1: "))
theta1 = float(input("please input the angle between two axis of layer1: "))
a2 = float(input("please input the first axis length of layer2: "))
b2 = float(input("please input the second axis of layer2: "))
theta2 = float(input("please input the angle between two axis of layer2 : "))

#get a list containing all the atoms coordinations after cell expansion
layer1 = []

theta1 = theta1/360*2*np.pi
theta2 = theta2/360*2*np.pi

for i in range(-m,m+1):
    for j in range(-n, n+1):
        if i != 0 or j != 0:
            tmp1 = [i*a1+b1*j*np.cos(theta1), b1*j*np.sin(theta1), i, j] #also store the crystal coordination
            layer1.append(tmp1)

#rotate anticlockly step by step layer2
csl = [] #a list to contain all the possible axis
angle = start_angle/360*2*np.pi
while True:
    layer2 = []
    heter1, heter2 = [], []
    angle += step/360*2*np.pi
    print("now calculating angle:  " + str(round(angle/(2*np.pi)*360, 4)))
    for i in range(-m,m+1):
        for j in range(-n,n+1):
            if i != 0 or j != 0:
                tmp2 = [i*a2*np.cos(angle)+j*b2*np.cos(angle+theta2),\
                        i*a2*np.sin(angle)+j*b2*np.sin(angle+theta2), i, j]
                layer2.append(tmp2)

    #check whether two atoms are overlapping
    for atom1 in layer1:
        for atom2 in layer2:
            d = ((atom1[0]-atom2[0])**2+(atom1[1]-atom2[1])**2)**0.5
            if d < ther and atom1[2] < m and atom2[2] < m and atom1[3] < n and atom2[3] < n:
                heter1.append(atom1)
                heter2.append(atom2)
    
    #find the primitive two axis
    if len(heter1) > 8 and len(heter2) > 8:
        dmin = heter1[0][0]**2+heter1[0][1]**2
        for heter in heter1:
            d = heter[0]**2+heter[1]**2
            if d < dmin:
                tmp1 = heter[2:4]
        dmin2 = 10000000        
        for heter in heter1:
            if len(tmp1) > 0:
                if (heter[2]**2+heter[3]**2)%(tmp1[0]**2+tmp1[1]**2) == 0:
                    continue
                else:
                    d = heter[0]**2+heter[1]**2
                    if d < dmin2:
                        tmp2 = heter[2:4]

        dmin = heter2[0][0]**2+heter2[0][1]**2
        for heter in heter2:
            d = heter[0]**2+heter[1]**2
            if d < dmin:
                tmp3 = heter[2:4]
        dmin2 = 10000000        
        for heter in heter2:
            if len(tmp3) != 0:
                if (heter[2]**2+heter[3]**2)%(tmp3[0]**2+tmp3[1]**2) == 0:
                    continue
                else:
                    d = heter[0]**2+heter[1]**2
                    if d < dmin2:
                        tmp4 = heter[2:4]

        csl.append([angle*360/(2*np.pi), tmp1, tmp2, tmp3, tmp4])

    if angle > end_angle/360*2*np.pi:
        break

#output all the data
f = open("out.data", "a+")
for mis in csl:
    line = map(str, mis)
    line = " ".join(line)
    line += "\n"
    f.write(line)
f.close()

    
