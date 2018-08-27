%本程序为在在点云法向上添加噪声
clc;clear;
K=input('请输入K值');
A=importdata('D:\Point\Point_zhuiti.txt');
B=importdata('D:\Point\Fa_xiang_zhuiti.txt');
ptCloud = pcread('D:\Point\Point_zhuiti.ply');
figure(1);
plot3(A(:,1),A(:,2),A(:,3),'.','markersize',5);
axis equal
n=length(A);
m=2:20:n;
C=randn(length(m),1);
sum_l=0;
sum_std_l=0;
for i=1:n
     point=A(i,:);
    [indices,dists] = findNearestNeighbors(ptCloud,point,16);
    l=sum(dists)/(K-1);
    std_l=std(dists,1);
    sum_l=sum_l+l;
    sum_std_l=sum_std_l+std_l;
end
pingjun_l=sum_l/n;
pingjun_std_l=sum_std_l/n;
for i=1:length(m)
    A(m(1,i),:)=A(m(1,i),:)+0.01*C(i,1)*B(m(1,i),:);
end
%  dlmwrite('zaosheng_Point_zhuiti3.txt',A,'delimiter',' ','newline','pc')  
figure(2);
plot3(A(:,1),A(:,2),A(:,3),'.','markersize',5);
axis equal





