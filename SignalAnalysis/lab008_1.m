clear all; close all;

m = 2;
c = 0.3;
k = 1000;

sim('lab008_sim_1')

t = tout;
a = acc.Data;
v = velocity.Data;
p = position.Data;
Pd = P.data;

matrix = zeros(3);
pmat = zeros(3,1);
for j=1:1:length(p)  
   ax = a(j);
   vx = v(j);
   px = p(j);
   Px = Pd(j);
   
   matrix(1,1) = matrix(1,1) + ax^2;
   matrix(1,2) = matrix(1,2) + ax * vx;
   matrix(1,3) = matrix(1,3) + ax * px;
   matrix(2,1) = matrix(2,1) + ax * vx;
   matrix(2,2) = matrix(2,2) + vx^2;
   matrix(2,3) = matrix(2,3) + vx * px;
   matrix(3,1) = matrix(3,1) + ax * px;
   matrix(3,2) = matrix(3,2) + vx * px;
   matrix(3,3) = matrix(3,3) + px^2;
   
   pmat(1) = pmat(1) + Px * ax;
   pmat(2) = pmat(2) + Px * vx;
   pmat(3) = pmat(3) + Px * px;
    
end

sol = matrix * [m;c;k];
awasome_solution = matrix\pmat;

