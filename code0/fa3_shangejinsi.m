clc;clear;
format long g
m=input('��������С�ı�����');
% data=load('f:/test.txt');%��ȡ��������
data=load('ping_1.txt');%��ȡ��������
% Data=data./m;
Data=data;
%���ݾ���
n=input('����֮��ľ��루mm����');

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

%%��������ѹ��
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
disp('����ѹ����Ϊ��')
length(xindata)/siz

%��������ѹ�����ͼ
figure(2)
plot3(Coordx(xindata),Coordy(xindata),Coordz(xindata),'r.')
axis equal
