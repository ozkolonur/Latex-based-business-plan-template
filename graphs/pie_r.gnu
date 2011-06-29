unset parametric
b=0.3
set yrange [*:*]
fit [0:L] f(x,D) 'pie.dat' u 0:2 via b
B=b
fit [0:L] f(x,D) 'pie.dat' u 0:1 via b
D=D+1.0
set palette model RGB functions r(D/L), g(D/L), b(D/L)
set parametric
set yrange [-2:2]
set urange [A:A+B]
set label 1 "%g", b at os*cos(2*pi*(A+B/2.0)), os*sin(2*pi*(A+B/2.0)), 0.2 cent
splot cos(u*2*pi)*v, sin(u*2*pi)*v, 0.2 w pm3d
A=A+B
if(D<L) reread
