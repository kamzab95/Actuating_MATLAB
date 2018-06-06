clear all; 
close all;
m=2; 
k=0.2; 
c=0.2; 
P=[]; T=[];
li = 5;
lj = 5;
C = 0;
for i=1:li
    C = C + c;
    K = 0;
    for j=1:lj
        K = K + k;
        T=[T [K C]'];
        a=sim('lab_007_sim2015', 'StopTime', '10.0');
        s = a.get('simout');
        P=[P s.Data];
    end
end