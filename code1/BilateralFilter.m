%本程序为双边滤波改进算法
%本程序需在MATLAB2015b之后的版本运行

%============================
%读取文件
clc;clear;
K=input('请输入K值');
ptCloud=pcread('D:\Point\ping.ply');
A=importdata('D:\Point\ping.txt');
Fa_xiang=importdata('D:\Point\Fa_xiang_ping2.txt');
%% 双边滤波
% tic
B=zeros(length(A),3);%储存调整后的点
M_zaodian=[];%用于储存离群点的标号
for i=1:length(A)
    sum_quan1=0;
    sum_quan2=0;
    point=A(i,:);
%     number=0;%用于计算在球内的个数
    number_1=0;%用于计算法向大于阈值的个数
    M_touying=[];%用于存放投影差
    M_Fa_xiangAngle=[];%用于存放邻近法向角度
    [indices,dists] = findNearestNeighbors(ptCloud,point,K);
    Std_touying=std(dists,1);
%     for j=2:length(indices)
%         zuobiaocha=A(indices(j,1),:)-A(i,:);
%         R=(zuobiaocha*zuobiaocha')^(0.5);
%         judge_D=sum(dists)/(K-1);
%         if R<judge_D
%             number=number+1;
%         end
%     end
    pingjun_l=sum(dists)/(K-1);
    if Std_touying<0.01&&pingjun_l<0.005
        for j=1:length(indices)
            zuobiaocha=A(indices(j,1),:)-A(i,:);
            touying=abs(dot(zuobiaocha,Fa_xiang(i,:)));
            Fa_xiangAngle=acos(dot(Fa_xiang(i,:),Fa_xiang(indices(j,1),:))/(norm(Fa_xiang(i,:))*norm(Fa_xiang(indices(j,1),:))))*180/pi;
            M_Fa_xiangAngle=[M_Fa_xiangAngle;Fa_xiangAngle];
            M_touying=[M_touying;touying];
        end
        for j=2:length(indices)
            zuobiaocha=A(indices(j,1),:)-A(i,:);
            if M_Fa_xiangAngle(j,1)<30
                Juli_quan=Gaosi(norm(zuobiaocha),dists(K,1));
                tongying_quan=Gaosi(dot(zuobiaocha,Fa_xiang(i,:)),Std_touying);
            else
                number_1=number_1+1;
                Juli_quan=0;
                tongying_quan=0;
            end
            sum_quan1=sum_quan1+Juli_quan*tongying_quan*dot(zuobiaocha,Fa_xiang(i,:));
            sum_quan2=sum_quan2+Juli_quan*tongying_quan;
        end
        if number_1>=(K-1)
            B(i,:)=A(i,:);
        else
        quan=sum_quan1/sum_quan2;
        B(i,:)=A(i,:)+quan*Fa_xiang(i,:);
        end
    else
        M_zaodian=[M_zaodian;i];
    end
end
 B(M_zaodian,:)=[];
%  toc
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
dlmwrite('ping2.txt',B,'delimiter',' ','newline','pc') 
%==========================================