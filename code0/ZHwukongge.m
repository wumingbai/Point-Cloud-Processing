clc;clear;
format long g
Data=load('text2.txt');%读取点云数据
x=Data(:,1);
y=Data(:,2);
z=Data(:,3);
A=[x,y,z];
dlmwrite('test2.txt',A,'delimiter',' ','newline','pc')