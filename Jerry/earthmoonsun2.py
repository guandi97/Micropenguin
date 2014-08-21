#Check that force on moon is always inward
#Adjust dem to vary

from visual import *
from math import *

##palette: miaka
miaka1 = (.988,.207,.298)
lalunanera = (.161,.133,.122)
miaka2 = (.074,.455,.490)
gameboyteal = (.039,.749,.737)
saumur = (.988,.968,.772)
watermelon = (.075,.678,.216)
goldfish = (.980,.51,.121)

scene.background=saumur
scene.fullscreen = True
sun=sphere(radius=1, pos=(0,0,0), color=goldfish)
real=False #we've set up some predetermined values for the real system and a
           #convenient fake one

if not real:
    #print("made it here")
    scene.autoscale=False
    scene.range=20
    des=10 #distance earth sun
    dem=.7 #(.7 is good)

    G=1
    
    sun=sphere(radius=1, pos=(0,0,0), color=goldfish)
    sun.m=1e5
    sun.p=vector(0,0,0)
    
    earth=sphere(radius=.5, pos=(des,0,0), color=gameboyteal)
    earth.m=99.5
    earth.period=sqrt(4*math.pi**2*des**3/(sun.m+earth.m))
    earth.p=vector(0,earth.m*sqrt(sun.m/des),0)
    
    moon=sphere(radius=.3, pos=(des+dem,0,0), color=lalunanera)
    moon.m=.0032
    moon.p=vector(0,.78*moon.m*sqrt(sun.m/(dem+des))+moon.m*sqrt(earth.m/dem),0)
    
    sun.p=-moon.p-earth.p
    forcearrow=arrow(color=miaka1,shaftwidth=1e-9)
    varrow=arrow(color=moon.color,shaftwidth=1e-1)
    points(pos=(0,0,1.01),color=lalunanera)

else:
    scene.range=300000000000
    des=149597870700
    dem=384399000

    G=6.67384e-11
    
    sun=sphere(radius=1, pos=(0,0,0), color=goldfish)
    sun.m=1.9891e30
    sun.p=vector(0,0,0)
    
    earth=sphere(radius=6371000, pos=(des,0,0), color=gameboyteal)
    earth.m=5.9736e24
    earth.period=365.25636004*24*60*60
    earth.p=vector(0,29780*earth.m,0)
    
    moon=sphere(radius=1737100, pos=(des+dem,0,0), color=lalunanera)
    moon.m=7.3477e22
    moon.p=vector(0,(earth.p[1]/earth.m+1022)*moon.m,0)
    
    sun.p=-moon.p-earth.p
    ep = points(pos=earth.pos,color=earth.color)
    mp = points(pos=moon.pos,color=moon.color)
    sp = points(pos=sun.pos,color=sun.color)

pArray=array([sun,earth,moon])
for a in pArray:
    a.orbit=curve(color=a.color)

dt = earth.period/50000
t=0
pause=True

while t<100*earth.period:
    rate(10000)
    t=t+dt

    if scene.mouse.events:
        m1 = scene.mouse.getevent()
        if m1.press:
            if pause==False:            
                pause=True
            else:
                pause=False

    if pause==False:
        for a in pArray:
            forceOnA=vector(0,0,0)
            for b in pArray:
                if a!=b:
                    distAtoB=b.pos-a.pos
                    forceOnA+=G*a.m*b.m*distAtoB/mag(distAtoB)**3
            a.p+=forceOnA*dt
            a.pos+=a.p/a.m*dt
            a.orbit.append(pos=a.pos)
            if a == moon and not real:
                forcearrow.axis=4*forceOnA
                forcearrow.pos=a.pos
                varrow.axis=a.p/a.m/40
                varrow.pos=a.pos
            if real:
                ep.pos=earth.pos
                mp.pos=moon.pos
                sp.pos=sun.pos

