clear all; close all;

c = [0.1 0.1 0.15];
k = [1000 1500 2000];
m = [0.8 1];

sim('lab009_sim_1');

f = force.Data;
x = response.Data;

fs = 1e-3;
n = length(x);

%wind = hann(n/2);
%frf = modalfrf(f, x, fs, wind);
%[fn,dr,ms] = modalfit(frf,f,fs,2,'FitMethod','pp')
frff(x, f, 1/fs);

function frff(x, f, dt)
    x = x .* hann(length(x));
    f = f .* hann(length(f));
    tempx=fft(x);
    tempf=fft(f);
    x1=abs(tempx);
    f1=abs(tempf);
    L=length(x1)/2;
    Nq=(1/dt)/2;
    X=x1(1:L);
    F=f1(1:L);
    FRF=X./F;
    freq=linspace(0,Nq,L);
    figure
    semilogy(freq,FRF);
    grid on
    xlabel('frequency')
    ylabel('Displacement FRF')
end

