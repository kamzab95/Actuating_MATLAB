data=[];
net = feedforwardnet((length(P)-1)/100,'trainlm');
net.trainParam.epochs=10;
net = train(net,P,T);