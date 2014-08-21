from visual import *
from visual.graph import *


xn=10
iterations=5
myDisplay=gdisplay(xtitle='Step',ytitle='x',foreground=color.black,background=color.white)
results=gdots(color=color.red, size=2)

def f(x):
    return x-((x**2-5)/(2*x))

for i in range(0,iterations):
    xn=f(xn)
    results.plot(pos=(i,xn))
