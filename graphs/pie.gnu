reset
os=1.3
FIT_LIMIT=1e-8
L=6.0
f(x,a)=(x>a-0.5?(x<a+0.5?b:0):0)
r(x)=abs(2*x-0.5); g(x)=sin(x*pi); b(x)=cos(x*pi/2.0)
set term postscript eps color blacktext "Helvetica" 24

set view 30, 20
set parametric
set isosample 2, 2
unset border
unset tics
unset key
set ticslevel 0
unset colorbox
set urange [0:1]
set vrange [0:1]
set xrange [-2:2]
set yrange [-2:2]
set zrange [0:3]

A=0.0; D=0.0
set multiplot
# First, we draw the 'box' around the plotting volume
set palette model RGB functions 0.9, 0.9,0.95
splot -2+4*u, -2+4*v, 0 w pm3d
set palette model RGB functions 0.8, 0.8, 0.85

splot cos(u*2*pi)*v, sin(u*2*pi)*v, 0 w pm3d

call 'pie_r.gnu'
unset multiplot

pause 1