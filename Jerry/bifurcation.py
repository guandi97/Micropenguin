from visual.graph import *
r=0
xn=.3
iterations=100
myDisplay=gdisplay(xtitle='r', ytitle='x', foreground=color.black, background=color.white)
results=gdots(color=color.red, size=2)
def f(r,x):
    return r*x*(1-x)
while r<=4:
    xn=.3
    r=r+0.001
    for i in range(0,iterations):
        xn=f(r,xn)
    for i in range(0,10):
        xn=f(r,xn)
        results.plot(pos=(r,xn))
