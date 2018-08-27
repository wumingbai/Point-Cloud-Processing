a=linspace(0,2*pi,50);
x=5*cos(a);
y=5*sin(a);
[X,Y]=meshgrid(x,y);
Z=sin(sqrt(X.^2+Y.^2))./sqrt(X.^2+Y.^2);%%%��֪��������滭�ĶԲ���,�㿴һ��
surf(X,Y,Z)
hold on
[U V W]=surfnorm(X,Y,Z);
quiver3(X,Y,Z,U,V,W,0.4)