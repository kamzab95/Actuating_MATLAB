clear
close all
fs = 100;
t = 0:1/fs:10;
y = exp(-0.02*2*pi*2*t).*sin(2*pi*2*t);
mod = ar2(y,2);
% what happens when you uncomment the next line?
% mod = armax(y',[2 1]);
Y_es = predict(mod,y');
figure
plot(t,y,'LineWidth',2)
hold on
plot(t,Y_es,'--r','LineWidth',2)
xlabel('Time [s]','FontSize',16)
ylabel('Amplitude ','FontSize',16)
grid on
legend('Input signal','Estimated signal')