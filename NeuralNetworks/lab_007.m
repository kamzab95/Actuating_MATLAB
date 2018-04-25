clear all; close all;

m=2; % mass
k=0.2; % range of stiffness changes
c=0.2; % range of damping changes
P=[]; T=[];% reset training set
% consider all combinations of parameters (K,C) in the ranges with some step
li = 3;
lj = 3;

C = 0;
for i=1:li
    C = C + c;
    K = 0;
    for j=1:lj
        K = K + k;
        % combine temporary values of parameters
        T=[T [K C]']; % Save as a column of target matrix
        a=sim('lab_007_sim', 'StopTime', '10.0'); % simulate system in ? Seconds
        % save the output of the system as a column in input matrix
        disp('----------------');
        disp(i); disp(j);
        s = a.get('simout');
        P=[P s.Data];  
    end
end

data=[];
f = waitbar(0,'Training in process...');
for b=1:length(T)
    net = linearlayer(0, 0.0001);
    [Xs,Xi,Ai,Ts] = preparets(net,P(:, b),T(:,b));
    net = train(net,Xs,Ts,Xi,Ai);
    %view(net)
    Y = net(Xs,Xi);
    perf = perform(net,Ts,Y);
    %dt = cell2mat(Y(1,1))
    data=[data cell2mat(Y)];
    disp(b)
    waitbar(b/length(T),f,'Training in process...');
end

close(f)
plot(data);
comp = [T; data]