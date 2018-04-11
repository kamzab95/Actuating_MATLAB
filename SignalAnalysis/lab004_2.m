close all; clear all;
hold on;

fs = 300; % Częstotliwość próbkowania sygnału
t=0:(1/fs):1; % Wektor czasu

N = 6000; % 0 to turn off zero padding

[x1, t1] = sinwave(10, fs, 0 , 1, 10);
[x2, t2] = sinwave(12, fs, 90 , 1,10);
[x3, t3] = sinwave(80, fs, 180 ,1,10);
[x4, t4] = sinwave(81, fs, 0 ,1,10);
[x5, t5] = sinwave(120, fs, 90 ,2,10);


winapply(x1, rectwin(length(x1)), fs, N)
winapply(x2, rectwin(length(x2)), fs, N)
winapply(x3, rectwin(length(x3)), fs, N)
winapply(x4, rectwin(length(x4)), fs, N)
winapply(x5, rectwin(length(x5)), fs, N)

figure(2);
hold on;
winapply(x1, hanning(length(x1)), fs, N)
winapply(x2, hanning(length(x2)), fs, N)
winapply(x3, hanning(length(x3)), fs, N)
winapply(x4, hanning(length(x4)), fs, N)
winapply(x5, hanning(length(x5)), fs, N)

N=4; %zero padding


function [f2, am2]=winapply(x, w, fs, N)
    if N ~= 0
        y = fft(x, N);
    else
        y = fft(x);
    end
    
    f = (0:length(y)-1)'*fs/length(y);
    y = fft(x'.*w);
    ind=find(f<=fs/2);
    f2=f(ind); am2 = 20*log10(abs(y(ind)/norm(w)));
    plot(f2,am2)
end



%%
%hold off;
function [x, t]=sinwave(freq, fs, phase_shift, amp, stoptime)
    t=0:(1/fs):stoptime; % Wektor czasu
    x = amp*(sin(2*pi*freq*t + deg2rad(phase_shift)));
end

function [fx, fy]=sft(X, sampling)
    fy = fft(X);
    fn = length(fy);
    fy = fy./fn;
    df = sampling/fn;
    fv = 0:df:(sampling-df);
    sf = abs(fy);
    %plot(fv1, sf1);
    fx = fv;
    fy = sf;
end