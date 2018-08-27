clc;clear;
M=[];
x=1:0.2:10;
y=1:0.2:10;
n=length(x);
m=length(y);
for i=1:n
    for j=1:m
        A=[x(i),y(j)];
        M=[M;A];
    end
end
plot(M(:,1),M(:,2),'*')
