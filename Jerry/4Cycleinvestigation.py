from visual.graph import *
from visual import *
r=3.47

myDisplay=gdisplay(x=0, y=0, xtitle='x', width=700, height=700, ytitle='f(x)', foreground=color.black, background=color.white, xmax=1,xmin=0, ymax=1, ymin=0)
def f(r,x):
    return r*x*(1-x)
def f2(r,x):
    return f(r,f(r,x))
def f4(r,x):
    return f2(r,f2(r,x))

fd= gcurve(color=color.yellow)	 
for x in arange(0, 8.05, 0.001):
    fd.plot(pos=(x,x))
fa= gcurve(color=color.cyan)	 
rate(1)
for x in arange(0, 8.05, 0.001):	
    fa.plot(pos=(x,f(r,x)))
fb=gcurve(color=color.blue)
rate(1)
for x in arange(0, 8.05, 0.001):	
    fb.plot(pos=(x,f2(r,x)))
fc=gcurve(color=color.red)
rate(1)
for x in arange(0, 8.05, 0.001):
    fc.plot(pos=(x,f4(r,x)))

