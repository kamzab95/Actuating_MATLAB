clear();
syms t1 t2 t3;
%syms d1 d2 d3;
%t1 = degtorad(30)
%t2 = degtorad(30)
%t3 = degtorad(30)

d1 = 2;
d2 = 2;
d3 = 1;

A1 = [cos(t1), -sin(t1), 0, 0;
    sin(t1), cos(t1), 0, 0;
    0, 0, 1, d1; 
    0, 0, 0, 1];

B1 = [cos(t2), -sin(t2), 0, 0;
    sin(t2), cos(t2), 0, 0;
    0, 0, 1, 0;
    0, 0, 0, 1];

B2 = [1, 0, 0, 0;
    0, 0, -1, 0;
    0, 1, 0, 0;
    0, 0, 0, 1];

A2 = B1 * B2;

C1 = [cos(t3), -sin(t3), 0, 0;
    sin(t3), cos(t3), 0, 0;
    0, 0, 1, 0;
    0, 0, 0, 1];

C2 = [1, 0, 0, d2;
    0, 1, 0, 0;
    0, 0, 1, 0;
    0, 0, 0, 1];

A3 = C1 * C2;

A4 = [1, 0, 0, d3;
    0, 1, 0, 0;
    0, 0, 1, 0;
    0, 0, 0, 1];

T = A1 * A2 * A3 * A4

xx = T(1,4)
yy = T(2,4)
zz = T(3,4)

x = 1.299
y = 2.25
z = 3.5

%t1 = pi()/4


eq1 = simplify(xx == x)
eq2 = simplify(yy == y)
eq3 = simplify(zz == z)


s = solve(eq1, eq2, eq3, t1, t2, t3)

a = s.t1

%st1 = round(radtodeg(t1))
%st2 = round(radtodeg(sol.t2))
%st3 = round(radtodeg(sol.t3))

