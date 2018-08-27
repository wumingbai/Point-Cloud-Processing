%本程序为生成锥体点云
%具体做法为先生成一个圆面，再通过锥体函数生成三维点云
%============================
%生成圆面
clc;clear;
circle=[];
for R=0.02:0.02:0.4 %角度[0,2*pi]
    for alpha=0:pi/20:2*pi %半径
        x=R*cos(alpha);
        y=R*sin(alpha);
        circle=[circle;x,y];
    end
end
%生成锥体
Point_zhuiti=[0,0,0];
n=length(circle);
circle=[circle,-0.4.*ones(n,1)];
Point_zhuiti=[Point_zhuiti;circle];
for i=1:n
    a=circle(i,1);
    b=circle(i,2);
    z=-(a^2+b^2)^(0.5);
    Point_zhuiti=[Point_zhuiti;[a,b,z]];
end
plot3(Point_zhuiti(:,1),Point_zhuiti(:,2),Point_zhuiti(:,3),'.','markersize',3);
axis equal
dlmwrite('Point_zhuiti3.txt',Point_zhuiti,'delimiter',' ','newline','pc')  
%=====================
