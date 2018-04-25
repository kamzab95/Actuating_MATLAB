fs = 250;
t1 = 0:0.004:1-1/fs;
t2 = 1:0.004:2-1/fs;
t3 = 2:0.004:3-1/fs;
t = [t1 t2 t3];
N = length(t);

s1 = 1*sin(2*pi*5*t1 + 0);
s2 = 1*sin(2*pi*20*t2 + 0);
s3 = 1*sin(2*pi*2*t3 + 0);
s = [s1 s2 s3];

y = fft(s);
dF = fs/N;                      
f = [-fs/2:dF:fs/2-dF];           


figure(1)
plot(t,s)
figure(2);
plot(f,abs(y)/N);
xlim([0 fs/2]);

windowLength=128;
noverlap=120;
nfft=128;
figure(3)
spectrogram(s,rectwin(fs),0,fs, fs,'yaxis'); 

scale = 6:1:350; 
% obtain wavelet transform coefficients
coefs = cwt(s,scale,'cmor1-1'); 
% calculate the frequency vector 
freqs = scal2frq(scale,'cmor 1-1',1/fs);  
% prepare matrices for surf plot
fr = repmat(freqs,length(t),1);  
time = repmat(t,length(freqs),1);  
%display scalogram
figure(4)
surf(time,fr',abs(coefs)); 
shading interp