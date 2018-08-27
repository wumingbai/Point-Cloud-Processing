clc;clear;
format long g
Data=load('bunny.txt');%读取点云数据
[aq,bq,cq,dq,eq,fq] = zh_qumiannihe( Data );