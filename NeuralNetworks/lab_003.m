w = [2;1];
x1=[-1:.2:4];
x2=[-2:.2:3];
z=[x1;x2];
a=1;
for i=1:length(x1)
    for j=1:length(x2)
        x(:,a)=[z(1,i);z(2,j)];
        a=a+1;
    end
end
y=w'*x

nnstart()
