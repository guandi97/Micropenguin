from visual.graph import *
from visual import *
r=1.5
x0=0.5
iterations=100
myDisplay=gdisplay(x=0, y=0, xtitle='x', width=700, height=700, ytitle='f(x)', foreground=color.black, background=color.white, xmax=1,xmin=0, ymax=1, ymin=0)
def f(r,x):
    return r*x*(1-x)
f1= gcurve(color=color.cyan)	 
for x in arange(0, 8.05, 0.001):	
    f1.plot(pos=(x,f(r,x)))
f2=gcurve(color=color.blue)
for x in arange(0, 8.05, 0.001):	
    f2.plot(pos=(x,x))
f3=gcurve(color=color.red)
x=x0
f3.plot(pos=(x,0))
count=0
while count<iterations:
    rate(1)
    f3.plot(pos=(x,f(r,x)))
    f3.plot(pos=(f(r,x),f(r,x)))
    x=f(r,x)
    count+=1

 
