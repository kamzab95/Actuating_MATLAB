fs=1000;
t=0:(1/fs):0.1;

s1=sin(2*pi*10*t);
s2=sin(2*pi*80*t);
s3=sin(2*pi*160*t);
s_sum=s1+s2+s3;



[b,a]=butter(10,[60/500 100/500]);

filtered=filter(b,a,s_sum);

S1 = fft(s_sum);
S2 = fft(filtered);
NS = length(S1);
S1 =S1/NS;
S2 =S2/NS;
df = fs/NS;
fv = 0:df:(fs-df);
figure
subplot(2,1,1)
plot(fv,abs(S1))
title('oryginalny')
subplot(2,1,2)
plot(fv,abs(S2),'r')
title('filtrowany')