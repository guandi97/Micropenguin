#renyi2.py
#Eric Hallman
#Renyi's parking problem

from visual import *
from random import *

#cars have a default length of 1, just change the lot length

def renyi( lotlength):
    if lotlength < 1:
        return 0
    else:
        r = (lotlength - 1) * random()
        return 1 + renyi(r) + renyi(lotlength - r - 1)

def renyiFrac( lotlength):
    return renyi(lotlength) / lotlength


def renyi2( lotlength):
    distances = [lotlength]
    tot = 0
    while len(distances) > 0:
        last = distances.pop()
        if last > 1:
            tot += 1
            r = (last - 1) * random()
            distances.append(r)
            distances.append( last - r - 1 )
    return tot / lotlength     

print ( "test 1")
for i in range(10):
    print (renyiFrac ( 500000))

print ( "test 2" )
for i in range(10):
    print (renyi2 ( 500000 ))



