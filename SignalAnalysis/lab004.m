close all; clear all;
%hold on;

%% it's fine
[x1, y1] = sinwave(11, 200, 0.995);
[fx1, fy1] = sft(y1, 200);
%plot(fx1, fy1, 'red');


%% leakage
[x2, y2] = sinwave(11, 200, 0.95);
[fx2, fy2] = sft(y2, 200);
L = length(x2);
%wvtool(rectwin(L));
%wvtool(hamming(L));
a = wvtool(hanning(L));
%wvtool(gausswin(L));
figure(7);
plot(x2, a);

%%
%hold off;
function [x, y]=sinwave(freq, sampling, stoptime)
    fs = sampling; % Sampling frequency (samples per second) 
    F = freq; % Sine wave frequency (hertz) 
    StopTime = stoptime; % seconds
    dt = 1/fs; % seconds per sample 
    t = (0:dt:StopTime)'; % seconds 
    data = sin(2*pi*F*t);
    %plot(t,data)
    x = t;
    y = data;
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