syms t1 t2 t3 d1 d2 d3;

%d1 = 2;
%d2 = 2;
%d3 = 0.5;

%t1 = degtorad(30)
%t2 = degtorad(30)
%t3 = degtorad(30)


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

x = 1.0825
y = 1.8750
z = 3.2500

%t1 = pi()/4

eq1 = (5*cos(t3)*(cos(t1)*cos(t2) - sin(t1)*sin(t2)))/2 == x;
eq2 = (5*cos(t3)*(cos(t1)*sin(t2) + cos(t2)*sin(t1)))/2 == y;
eq3 = (5*sin(t3))/2 + 2 == z;

sol = solve([eq1, eq2, eq3], [t1, t2, t3])

%st1 = round(radtodeg(sol.t1))
%st2 = round(radtodeg(sol.t2))
%st3 = round(radtodeg(sol.t3))

