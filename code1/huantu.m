clc;clear;
format long g
% m=input('��������С�ı�����');
% Data=load('f:/test.txt');%��ȡ��������
Data=load('D:\Point\zawu.txt');%��ȡ��������
x=Data(:,1);
y=Data(:,2);
z=Data(:,3);
plot3(x,y,z,'.','markersize',1.5);
axis equal
axis off

