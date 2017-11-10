angle = -90
B = [2;-2;0]

rad = degtorad(angle);
% x rotation


Ax = [1, 0, 0;
    0, cos(rad), -sin(rad);
    0, sin(rad), cos(rad)];

Cx = Ax * B

% y rotation

Ay = [cos(rad), 0, sin(rad);
    0, 1, 0;
    -sin(rad), 0, cos(rad)];
Cy = Ay * B

% z rotation

Az = [cos(rad), -sin(rad), 0;
    sin(rad), cos(rad), 0;
    0, 0, 1];

Cz = Az * B

%plot3(Cy);


bb = [1;0;2];
aa = Ax
ab = Ay
ra = aa * ab

md = aa * bb
cc = ra * bb




