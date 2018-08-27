tic
clc;clear;
format long g
%m=input('请输入缩小的倍数：');
% data=load('f:/test.txt');%读取点云数据
Data=load('ping_1.txt');%读取点云数据

%Data=data./m;
Coordx=Data(:,1);
Coordy=Data(:,2);
Coordz=Data(:,3);


jiange=input('取点间隔：')
%sta=floor(1 + (jiange-1).*rand());

gg=0;
for sta=1:jiange :length(Data)
    gg=gg+1;
newdata(gg,1:4)=[Data(sta,:),sta];
end

New_data=newdata(:,1:3);
disp('数据压缩比为：')
gg/length(Data)

%画出缩放压缩后的图
figure(5)
%plot3(Coordx(newdata(:,4)),Coordy(newdata(:,4)),Coordz(newdata(:,4)),'.','markersize',3)
plot3(New_data(:,1),New_data(:,2),New_data(:,3),'.','markersize',3)
axis equal
toc
%dlmwrite('New_data.txt',New_data,'delimiter',',','newline','pc')

