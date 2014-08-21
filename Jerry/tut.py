from visual import *
from math import *
ball=sphere(pos=(0,0,0),radius=0.5,color=color.cyan)
wallR=box(pos=(6,0,0),size=(0.2,12,12),color=color.green)
wallL=box(pos=(-6,0,0),size=(0.2,12,12),color=color.green)
wallT=box(pos=(0,6,0),size=(12,0.2,12),color=color.blue)
wallB=box(pos=(0,-6,0),size=(12,0.2,12),color=color.blue)
wallV=box(pos=(0,0,-6),size=(12,12,0.2),color=color.yellow)

ball.velocity=vector(25,5,15)
ball.acceleration=vector(0,-9.8,0)
ball.jerk=vector(0,15,0)
deltat=0.005
t=0


vscale=0.1
varr=arrow(pos=ball.pos,axis=vscale*ball.velocity,color=color.red)
scene.autoscale=False
ball.trail=curve(color=ball.color)

while t<100:
    rate(1000)
    if ball.pos.x>wallR.pos.x or ball.pos.x<wallL.pos.x:
        ball.velocity.x=-ball.velocity.x
    if ball.pos.y>wallT.pos.y or ball.pos.y<wallB.pos.y:
        ball.velocity.y=-ball.velocity.y
    if ball.pos.z>6 or ball.pos.z<wallV.pos.z:
        ball.velocity.z=-ball.velocity.z
    ball.pos=ball.pos+ball.velocity*deltat
    ball.velocity=ball.velocity+deltat*ball.acceleration
    ball.acceleration=ball.acceleration=deltat*ball.jerk
    ball.trail.append(pos=ball.pos)
    t=t+deltat
    varr.pos=ball.pos
    varr.axis=vscale*ball.velocity


    
