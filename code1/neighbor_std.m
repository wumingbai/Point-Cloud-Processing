%本程序为计算近邻点的平均距离与方差
clc;clear;
K=input('请输入K值');
A=importdata('D:\Point\ping.txt');
ptCloud = pcread('D:\Point\ping.ply');
sum_l=0;
sum_std_l=0;
n=length(A);
for i=1:n
     point=A(i,:);
    [indices,dists] = findNearestNeighbors(ptCloud,point,K);
    l=sum(dists)/(K-1);
    std_l=std(dists,1);
    sum_l=sum_l+l;
    sum_std_l=sum_std_l+std_l;
end
pingjun_l=sum_l/n;
pingjun_std_l=sum_std_l/n;