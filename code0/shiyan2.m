clc;clear;
format long g
Data=load('bunny.txt');%读取点云数据
x=Data(:,1);
y=Data(:,2);
z=Data(:,3);
A=[x,y,z];
plot3(A(1:10738,1),A(1:10738,2),A(1:10738,3),'.','markersize',3)