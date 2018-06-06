y=simout.Data';
u=tout';

%for a=1:40
%    P(a)=[y(0+a) u((1+a):39+a)];
%    T(a)=y(40+a);
%end

P=[];
T=[];
for a=1:40
  P=[P; y(a) u((1+a):(39+a))]; 
  T(a)=y(40+a);
end

plot(T);
hold on;

data = [];
for b=1:20
    net = linearlayer(0, 0.0001);
    [Xs,Xi,Ai,Ts] = preparets(net,P(:, b),T(b));
    net = train(net,Xs,Ts,Xi,Ai);
    %view(net)
    Y = net(Xs,Xi);
    perf = perform(net,Ts,Y);
    %dt = cell2mat(Y(1,1))
    data=[data cell2mat(Y)];
    disp(b)
end

plot(data);