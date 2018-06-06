C = 0;
Input = [];
Output = [];
c1 = 0.1;
k1 = 0.1;
for i=1:li
    C = C + c1;
    K = 0;
    for j=1:lj
        K = K + k1;
        Output=[Output [K C]'];
        a=sim('lab_007_sim2015', 'StopTime', '10.0');
        s = a.get('simout');
        Input=[Input s.Data];  
    end
end
data = [];
for a=1:length(Output)
    Y = net(Input(:,a));
    data=[data Y];
end
data1 = [];
for a=1:length(T)
    Y = net(P(:,a));
    data1=[data1 Y];
end
comp = [T; data]
figure(1)
plot(data')
hold;
plot(Output')

figure(2)
plot(data1')
hold;
plot(T')