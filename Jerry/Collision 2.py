from visual import *
def bounce(Vold,R):
    Vnew=Vold-2*dot(Vold,norm(R))*norm(R)
    return Vnew
circle=ring(pos=(0,0,0), axis=(0,0,1), radius=4, thickness=0.1)
balla=sphere(pos=(2,3,0), radius=0.1, color=color.cyan)
balla.velocity=vector(10,5,0)
massa=10
ballb=sphere(pos=(3,2,0), radius=0.1, color=color.red)
ballb.velocity=vector(-10,-5,0)
massb=5
ga=0.1massb/(
gb=
deltat=0.005
t=0
ball.pos=ball.pos+ball.velocity*deltat
vscale=0.01
varr=arrow(pos=ball.pos, axis=vscale*norm(ball.velocity), color=color.yellow)
ball.trail=curve(color=ball.color)
scene.autoscale=False
while t<10:
    rate(100)
    if (balla.pos.x)**2+(balla.pos.y)**2>=16:
        x=balla.pos.x
        y=balla.pos.y
        balla.velocity=bounce(balla.velocity, (x,y,0))
    if (ballb.pos.x)**2+(ballb.pos.y)**2>=16:
        x=ballb.pos.x
        y=ballb.pos.y
        ballb.velocity=bounce(ballb.velocity, (x,y,0))
    if balla.pos==ballb.pos:
        balla.velocity=-balla.velocity
        ballb.velocity=-ballb.velocity
    balla.velocity=balla.velocity+ga*deltat
    ballb.velocity=balla.velocity+gb*deltat
    balla.pos=balla.pos+balla.velocity*deltat
    ballb.pos=ballb.pos+ballb.velocity*deltat
    t=t+deltat
    varr.pos=balla.pos
    varr.pos=ballb.pos
    varr.axis=vscale*balla.velocity
    varr.axis=vscale*ballb.velocity
    balla.trail.append(pos=balla.pos)
    ballb.trail.append(pos=ballb.pos)
