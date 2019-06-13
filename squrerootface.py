#!/usr/bin/python3
#cleave square root surface, only test use 
#ponychen
#20190613
#email:18709821294@163.com

import numpy as np

a0 = float(input("please input the first lattice constant: "))
b0 = float(input("please input the second lattice constant: "))
theta0 = float(input("please input the degree between two axis: "))
k0 = float(input("please input the first new vector length sqrt(: "))
k1 = float(input("please input the second new vector length sqrt(: "))

conver = 0.5

theta1 = theta0/360*2*np.pi
a1 = [float(a0), 0.0]
b1 = [b0*np.cos(theta1), b0*np.sin(theta1)]

def cell_finder(a1, b1, theta1, k, conver):
    k = np.sqrt(k)
    avail = []

    alpha0 = np.linspace(0, np.pi*2, 10000)
    for alpha in alpha0:
        A1 = a1[0]*np.cos(alpha) + a1[1]*np.sin(alpha)
        A2 = b1[0]*np.cos(alpha) + b1[1]*np.sin(alpha)
        B1 = a1[1]*np.cos(alpha) - a1[0]*np.sin(alpha)
        B2 = b1[1]*np.cos(alpha) - b1[0]*np.sin(alpha)
        m = (b1[0]*(k*B1+k*B2)-b1[1]*(k*A1+k*A2))/\
                (a1[1]*b1[0]-a1[0]*b1[1])
        n = (a1[0]*(k*B1+k*B2)-a1[1]*(k*A1+k*A2))/\
                (a1[0]*b1[1]-a1[1]*b1[0])   
        if abs(m-np.rint(m))<conver and  abs(n-np.rint(n))<conver :
                avail.append([int(np.rint(m)), int(np.rint(n))])
    avail = np.unique(np.array(avail), axis=0)
 
    return avail  

avail1 = cell_finder(a1, b1, theta1, k0, conver)
avail2 = cell_finder(a1, b1, theta1, k1, conver)

avail3 = []
k0 = np.sqrt(k0)
k1 = np.sqrt(k1)
for ele1 in avail1:
    for ele2 in avail2:
        ele3 = np.asarray(np.mat(ele1)*np.mat([a1,b1]))
        ele4 = np.asarray(np.mat(ele2)*np.mat([a1,b1]))
        if round(np.linalg.norm(ele3),1) == round(k0*a0,1):
            if round(np.linalg.norm(ele4),1) == round(k1*b0,1):
                cosaxis = round(np.dot(ele3[0],ele4[0])/(np.linalg.norm(ele3[0])*np.linalg.norm(ele4[0])),6)
                if round(np.arccos(cosaxis),2) == round(theta1,2):
                    avail3.append([ele1, ele2])
for ele in avail3:
    print(ele," ")



