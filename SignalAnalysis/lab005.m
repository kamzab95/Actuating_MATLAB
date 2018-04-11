hold on;
[t1, y1]=sinwave(10, 10000, 20, 1, 0.1);
plot(t1, y1);
[t2, y2]=sinwave(80, 10000, 40, 3, 0.1);
plot(t2, y2);
[t2, y2]=sinwave(120, 10000, 60, 1, 0.1);
plot(t2, y2);

hold off;

figure(2);
%x=[0 0 -1 2 4 8 2 0 0 0];
x = y2;
%n=-3:6;
n = t2;
y = filter(1/3*[1 1 1 1],1,x);


for m=3:length(n)
 y(m)=1/3*(x(m)+x(m-1)+x(m-2));
 subplot(2,1,1)
 cla
 hold on
 stem(n,x)
% plot([n(m)+0.25 n(m)+0.25],[0 10],'--r');
% plot([n(m-2)-0.25 n(m-2)-0.25],[0 10],'--r')
 title('x[n]')
% text(0, 4, sprintf('n=%d',m-4))
%  box on
%  subplot(2,1,2)
%  hold on
%  plot(n(m),y(m),'*r')
%  title('y[n]')
 %pause ;
end

function [t, y]=sinwave(freq, fs, phase_shift, amp, stoptime)
    t=0:(1/fs):stoptime;
    y = amp*(sin(2*pi*freq*t + deg2rad(phase_shift)));
end