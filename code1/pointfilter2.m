%本程序为双边滤波算法
%本程序需在MATLAB2015b之后的版本运行

%============================
%读取文件
clc;clear;
K=input('请输入K值');
ptCloud = pcread('D:\Point\zaosheng_zhuiti4.ply');
A = importdata('D:\Point\zaosheng_zhuiti4.txt');
Fa_xiang=importdata('D:\Point\Fa_xiang_zhuiti.txt');
%% 双边滤波
B=zeros(length(A),3);
for i=1:length(A)
    M_touying=[];%用于存放投影差
    sum_quan1=0;
    sum_quan2=0;
    point=A(i,:);
    [indices,dists] = findNearestNeighbors(ptCloud,point,K);
    Std_touying=std(dists,0);
    for j=2:length(indices)
        zuobiaocha=A(indices(j,1),:)-A(i,:);
        touying=abs(dot(zuobiaocha,Fa_xiang(i,:)));
%         M_touying=[M_touying;touying];
        sum_quan1=sum_quan1+Gaosi(norm(zuobiaocha),dists(K,1))*Gaosi(touying,Std_touying)*dot(zuobiaocha,Fa_xiang(i,:));
        sum_quan2=sum_quan2+Gaosi(norm(zuobiaocha),dists(K,1))*Gaosi(touying,Std_touying);
    end
    quan=sum_quan1/(sum_quan2);
    B(i,:)=A(i,:)+quan.*Fa_xiang(i,:);
end
%% 画出法向量
subplot(1,2,1);
plot3(A(:,1),A(:,2),A(:,3),'.','markersize',5);
% hold on
% quiver3(A(1:end,1),A(1:end,2),A(1:end,3),Fa_xiang(1:end,1),Fa_xiang(1:end,2),Fa_xiang(1:end,3),2)
axis equal
% hold off
subplot(1,2,2);
plot3(B(:,1),B(:,2),B(:,3),'.','markersize',5);
% hold on
% quiver3(A(1:end,1),A(1:end,2),A(1:end,3),Fa_xiang(1:end,1),Fa_xiang(1:end,2),Fa_xiang(1:end,3),2)
% quiver3(A(L(7,:),1),A(L(7,:),2),A(L(7,:),3),u(L(7,:)),v(L(7,:)),w(L(7,:)),2)
axis equal
%==========================================