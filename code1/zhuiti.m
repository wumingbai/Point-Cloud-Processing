%������Ϊ����׶�����
%��������Ϊ������һ��Բ�棬��ͨ��׶�庯��������ά����
%============================
%����Բ��
clc;clear;
circle=[];
for R=0.02:0.02:0.4 %�Ƕ�[0,2*pi]
    for alpha=0:pi/20:2*pi %�뾶
        x=R*cos(alpha);
        y=R*sin(alpha);
        circle=[circle;x,y];
    end
end
%����׶��
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
