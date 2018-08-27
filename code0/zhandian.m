clc;clear;
format long g
% m=input('请输入缩小的倍数：');
% Data=load('f:/test.txt');%读取点云数据
Data=load('ping_1.txt');%读取点云数据
Coordx=Data(:,1);
Coordy=Data(:,2);
Coordz=Data(:,3);
% data=sortrows(Data,4);
siz1=size(Coordx);
% hold on 
plot3(Coordx,Coordy,Coordz,'b.')
axis equal



zcha=data;
%%%%%%%%%%%%%%%%%%%**********绘图显示

% %后
bilii=0.95;
plot3(zcha(ceil(siz1*bilii):siz1,1),zcha(ceil(siz1*bilii):siz1,2),zcha(ceil(siz1*bilii):siz1,3),'r.')
axis equal

%前
bili=0.1;
plot3(zcha(1:ceil(siz1*bili),1),zcha(1:ceil(siz1*bili),2),zcha(1:ceil(siz1*bili),3),'b.');
axis equal














% plot3(Coordx(1:1000*k),Coordy(1:1000*k),Coordz(1:1000*k),'b_')
% TRI = delaunay(Coordx(1:siz1(1)),Coordy(1:siz1(1)),Coordz(1:siz1(1)));
% siz2=size(TRI);
% for k=1:siz2(1)
%     pause(2);
%     plot3(Coordx(TRI(k,1)),Coordy(TRI(k,1)),Coordz(TRI(k,1)),'b.',...
%           Coordx(TRI(k,2)),Coordy(TRI(k,2)),Coordz(TRI(k,2)),'b.',...
%           Coordx(TRI(k,3)),Coordy(TRI(k,3)),Coordz(TRI(k,3)),'b.',...
%           Coordx(TRI(k,4)),Coordy(TRI(k,4)),Coordz(TRI(k,4)),'b.');
%     hold on
%     axis equal
% end
% 

















% clc;clear;
% format long g
% m=input('请输入缩小的倍数：');
% Data=load('ping3wei.txt');%读取点云数据
% Coordx=Data(:,1);
% Coordy=Data(:,2);
% Coordz=Data(:,3);
% siz1=size(Coordx);
% siz2=size(TRI);
% plot3(Coordx(1:5:1000*k),Coordy(1:5:1000*k),Coordz(1:5:1000*k),'b.')
% TRI = delaunay(Coordx(1:siz(1)),Coordy(1:siz(1)),Coordz(1:siz(1)));
% for k=1:siz1(1)
%     pause(0.01);
%     plot3(Coordx(1:5:200*k),Coordy(1:5:200*k),Coordz(1:5:200*k),'b.')
%     axis equal
% end














% I2 = colfilt(Data,[5 3],'sliding',@S_mean);
% for k=1:siz(1)
%     pause(0.1);
%     plot3(I2(1:20:1000*k,1),I2(1:20:k*1000,2),I2(1:20:k*1000,3),'b.')
%     axis equal
% end
% 
% 
% I2 = colfilt(A,[5 1],'sliding',@mean)
% 
% a=[1 2 3;3 5 3;1 5 9;5 1 2 ;5 2 5 ;6 4 8;1 5 3;8 7 5 ;4 5 6 ];
% b=[1 2 3;3 5 3;1 5 9;5 1 2 ;5 2 5  ];
% S_mean(b)
% for i=1:2;
% sqrt((a(:,1)-b(:,1)).^2+(a(:,2)-b(:,2)).^2+(a(:,3)-b(:,3)).^2)/2
% end          







