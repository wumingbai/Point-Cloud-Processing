%本程序需在MATLAB2015b之后的版本运行
clc;clear;
K=input('请输入K值');
A=importdata('D:\Point\zawu.txt');
% ptCloud = pcread('D:\Point\guan.ply');
B=zeros(length(A),3);%储存调整后的点
M_zaodian=[];%用于储存离群点的标号
for i=1:length(A)
    point=A(i,:);
%     [indices,dists] = findNearestNeighbors(ptCloud,point,K);
    [indices,dists] = knnsearch(A,point,'k',K);
    a=std(dists,1);%标准偏差
    b=sum(dists)/(K-1);%平均距离
    if a<0.0018&&b<0.0058
            B(i,:)=A(i,:);
    else
        M_zaodian=[M_zaodian;i];
    end
end
 B(M_zaodian,:)=[];
subplot(1,2,1);
plot3(A(:,1),A(:,2),A(:,3),'.','markersize',5);
axis equal
subplot(1,2,2);
plot3(B(:,1),B(:,2),B(:,3),'.','markersize',5);
axis equal