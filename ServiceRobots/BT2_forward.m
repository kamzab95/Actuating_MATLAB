syms t1 t2 t3; % d1 d2 d3 d4;

%t1 = degtorad(0);
%t2 = degtorad(0);
%t3 = degtorad(0);

a1 = degtorad(-45);
a2 = degtorad(45);
a3 = degtorad(45);
a4 = degtorad(-45);
a5 = degtorad(-45);
a6 = degtorad(45);


d1 = 1;
d2 = 1;
d3 = 1;
d4 = 1;


% ---A1---
% trans z
A11 = [1, 0 , 0, 0;
       0, 1, 0, 0;
       0, 0, 1, d1;
       0, 0, 0, 1];

%rot x
A12 = [1,    0,       0,     0;
       0, cos(a1), -sin(a1), 0;
       0, sin(a1),  cos(a1), 0;
       0,    0,      0,      1];
    
A1 = A11 * A12;

% ---A2---
%rot z
A21 = [cos(t1), -sin(t1), 0, 0;
       sin(t1),  cos(t1), 0, 0;
       0,           0,    1, 0;
       0,           0,    0, 1];
%rot x
A22 = [1,    0,       0,     0;
       0, cos(a2), -sin(a2), 0;
       0, sin(a2),  cos(a2), 0;
       0,    0,      0,      1];
   
A2 = A21 * A22;

% ---A3---
%rot z
A31 = [1, 0 , 0, 0;
       0, 1, 0, 0;
       0, 0, 1, d2;
       0, 0, 0, 1];
   
A32 = [1,    0,       0,     0;
       0, cos(a3), -sin(a3), 0;
       0, sin(a3),  cos(a3), 0;
       0,    0,      0,      1];
   
A3 = A31 * A32;

% ---A4---
%rot z
A41 = [cos(t2), -sin(t2), 0, 0;
       sin(t2),  cos(t2), 0, 0;
       0,           0,    1, 0;
       0,           0,    0, 1];
%rot x
A42 = [1,    0,       0,     0;
       0, cos(a4), -sin(a4), 0;
       0, sin(a4),  cos(a4), 0;
       0,    0,      0,      1];
   
A4 = A41 * A42;

% ---A5---
% trans z
A51 = [1, 0 , 0, 0;
       0, 1, 0, 0;
       0, 0, 1, d3;
       0, 0, 0, 1];

%rot x
A52 = [1,    0,       0,     0;
       0, cos(a5), -sin(a5), 0;
       0, sin(a5),  cos(a5), 0;
       0,    0,      0,      1];
    
A5 = A51 * A52;

% ---A6---
%rot z
A61 = [cos(t3), -sin(t3), 0, 0;
       sin(t3),  cos(t3), 0, 0;
       0,           0,    1, 0;
       0,           0,    0, 1];
%rot x
A62 = [1,    0,       0,     0;
       0, cos(a6), -sin(a6), 0;
       0, sin(a6),  cos(a6), 0;
       0,    0,      0,      1];
   
A6 = A61 * A62;

% ---A7---
% trans z
A7 = [1, 0 , 0, 0;
       0, 1, 0, 0;
       0, 0, 1, d4;
       0, 0, 0, 1];
   
T = A1 * A2 * A3 * A4 * A5 * A6 * A7;

xx = T(1,4)
yy = T(2,4)
zz = T(3,4)

%

eq1 = xx == 0;
eq2 = yy == -2;
eq3 = zz == 1;

%tx = round(xx,2)
%ty = round(yy, 2)
%tz = round(zz, 2)

[t1,t2,t3] = solve([eq1, eq2, eq3]);

dt1 = round(radtodeg(t1))
dt2 = round(radtodeg(t2))
dt3 = round(radtodeg(t3))









   
 
   
