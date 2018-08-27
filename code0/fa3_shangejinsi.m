clc;clear;
format long g
m=input('请输入缩小的倍数：');
% data=load('f:/test.txt');%读取点云数据
data=load('ping_1.txt');%读取点云数据
% Data=data./m;
Data=data;
%数据精简
n=input('点云之间的距离（mm）：');

% 
% Coordx=round(Data(:,1)/m*1000/n)*n/1000;
% Coordy=round(Data(:,2)/m*1000/n)*n/1000;
% Coordz=round(Data(:,3)/m*1000/n)*n/1000;

Coordx=round(Data(:,1)*1000/n)*n/1000;
Coordy=round(Data(:,2)*1000/n)*n/1000;
Coordz=round(Data(:,3)*1000/n)*n/1000;
% 
% Coordx=Data(:,1);
% Coordy=Data(:,2);
% Coordz=Data(:,3);
% hold on
% figure(4)
% plot3(Coordx(2:20),Coordy(2:20),Coordz(2:20),'r*')
% axis equal
% grid on


% Coordx=round(Data(:,1)/m*1000/n)*n/1000;
% Coordy=round(Data(:,2)/m*1000/n)*n/1000;
% Coordz=round(Data(:,3)/m*1000/n)*n/1000;
siz=length(Coordx);
cou=1:siz;

%%点云数据压缩
data=[Coordx*1000000000+Coordy*10000+Coordz,cou'];
testt=data(:,1);
jisnjianshu=unique(testt);
datahe=sortrows(data,1);
g=0;
for i=1:siz
    if i==siz
        g=g+1;
        xindata(g,1)=datahe(i,2);
        break
    end 
    if datahe(i,1)-datahe(i+1,1)~=0
        g=g+1;
        xindata(g,1)=datahe(i,2);
    end
end
disp('数据压缩比为：')
length(xindata)/siz

%画出缩放压缩后的图
figure(2)
plot3(Coordx(xindata),Coordy(xindata),Coordz(xindata),'r.')
axis equal
