fs=1e3;
t=0:(1/fs):0.1-1/fs;

s1=sin(2*pi*10*t);
s2=sin(2*pi*80*t);
s3=sin(2*pi*160*t);
x=s1+s2+s3;

figure
plot(t,x)
title('original signal')

z=zeros(1,1024-length(x))
xpad=[x, z];
figure
plot(xpad)
title('with padding')
xfft=fft(x);
xfft=xfft/length(x);
freqx=0:fs/length(x):fs-(fs/length(x));
figure
plot(freqx,abs(xfft))
title('original signal freq')

xpadfft=fft(xpad);
xpadfft=xpadfft/length(xpad);
freqxpad=0:fs/length(xpad):fs-(fs/length(xpad));
figure
plot(freqxpad,abs(xpadfft))
title('padding freq')
figure
loglog(freqxpad,abs(xpadfft))
title('padding freq- log scale')

xhamm=x.*hamming(length(x))';
xhammpad=[xhamm, z];

xhammpadfft=fft(xhammpad);
xhammpadfft=xhammpadfft/length(xhammpad);
freqxhammpad=0:fs/length(xhammpad):fs-(fs/length(xhammpad));
figure
loglog(freqxpad,abs(xpadfft))
title('window before padding freq') %window changes nothin
