% number of degrees of freedom
n=3;
% mass parameters
m1=5;
m2=2;
% damping parameters
al1 = 10;
al2 = 5;
al3 = 6;
% stiffness parameters
k1 = 60000;
k2 = 12000;
k3 = 10000;
% matrices of coefficients
% mass matrix
M = [m1, 0;
     0, m2];
% damping matrix
C = [al1+al2 -al2;
    -al2 al2+al3];

% stiffness matrix
K = [k1+k2 -k2;
    -k2 k2+k3];
% definition of matrix for eigenvalue problem
ZER = zeros(size(M));
A = [ZER,M;M,C];
B = [-M,ZER;ZER,K];
% solving the eigenvalue problem
[PHI,LAMBDA]=eig(-B,A);
% calculation of dampened natural frequencies [Hz]
WD=imag(diag(LAMBDA))/2/pi;

% calculation of natural frequencies [Hz]
WW=sqrt(imag(diag(LAMBDA)).^2+real(diag(LAMBDA)).^2)/2/pi;
% calculation of damping ratios
KSI=-real(diag(LAMBDA))./sqrt(imag(diag(LAMBDA)).^2+real(diag(LAMBDA)).^2);


%%
% scaling factor estimation
AAA=PHI'*A*PHI;
for a=1:n
    AN(:,2*a-1)=AAA(:,2*a);
    AN(:,2*a)=AAA(:,2*a-1);
end;
QQ=inv(AN);
Q=diag(QQ);
% synthesis of FRFs
for c=1:3
    jj=[1:3];
    f=[0:0.25:40];
    for b=1:length(f)
        for a=1:n
            htemp=0;
            for r=1:2*n
                htemp=htemp+((Q(r)*PHI(n+a,r)*PHI(n+jj(c),r))/(i*f(b)*2*pi- LAMBDA(r,r)));
            end;
            H{a,c}(b)=htemp*(-1)*(f(b)*2*pi)^2;
        end;
    end;
end;
plot(f,abs(H{1,3}))