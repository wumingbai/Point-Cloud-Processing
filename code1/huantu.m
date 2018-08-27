clc;clear;
format long g
% m=input('请输入缩小的倍数：');
% Data=load('f:/test.txt');%读取点云数据
Data=load('D:\Point\zawu.txt');%读取点云数据
x=Data(:,1);
y=Data(:,2);
z=Data(:,3);
plot3(x,y,z,'.','markersize',1.5);
axis equal
axis off

