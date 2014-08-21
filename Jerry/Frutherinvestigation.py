from visual.graph import *
from visual import *
r=3.47

myDisplay=gdisplay(x=0, y=0, xtitle='x', width=700, height=700, ytitle='f(x)', foreground=color.black, background=color.white, xmax=4,xmin=3.5, ymax=1, ymin=0)
def g(n,r):
    if n==0:
        return r/4
    else:
        k=g(n-1,r)
        return r*k*(1-k)

for i in range(0,9,1):
    fa= gcurve(color=color.red)
    for r in arange(3.5,4,0.001):
        fa.plot(pos=(r,g(i,r)))
