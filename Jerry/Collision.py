from visual import *
ball=sphere(pos=(-5,0,0), radius=0.5, color=color.cyan)
wallR=box(pos=(6,0,0), size=(0.2,12,12), color=color.green)
wallL=box(pos=(-6,0,0), size=(0.2,12,12), color=color.green)
wallT=box(pos=(0,6,0), size=(12,0.2,12), color=color.blue)
wallB=box(pos=(0,-6,0), size=(12,0.2,12), color=color.blue)
wallF=box(pos=(0,0,0), size=(12,12,0.2), color=color.red)
ball.velocity=vector(25,5,15)
deltat=0.005
t=0
ball.pos=ball.pos+ball.velocity*deltat
vscale=0.1
varr=arrow(pos=ball.pos, axis=vscale*ball.velocity, color=color.yellow)
ball.trail=curve(color=ball.color)
scene.autoscale=False
while True:
    rate(100)
    if ball.pos.x>wallR.pos.x or ball.pos.x<wallL.pos.x:
        ball.velocity.x=-ball.velocity.x
    if ball.pos.y>wallT.pos.y or ball.pos.y<wallB.pos.y:
        ball.velocity.y=-ball.velocity.y
    if ball.pos.z>6 or ball.pos.y<wallF.pos.z:
        ball.velocity.z=-ball.velocity.z
    ball.pos=ball.pos+ball.velocity*deltat
    t=t+deltat
    varr.pos=ball.pos
    varr.axis=vscale*ball.velocity
    ball.trail.append(pos=ball.pos)
    
