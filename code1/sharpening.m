clc;clear;
K=input('请输入K值');
ptCloud=pcread('D:\Point\Point_zhuiti3.ply');
A=importdata('D:\Point\Point_zhuiti3.txt');
Fa_xiang=importdata('D:\Point\Fa_xiang_zhuiti3_25.txt');
%% 双边滤波
B=zeros(length(A),3);%储存调整后的点
features=[];
for i=1:length(A)
% i=1;
    point=A(i,:);
    number_1=0;%用于计算法向大于阈值的个数
%     M_touying=[];%用于存放投影差
    M_Fa_xiangAngle=[];%用于存放邻近法向角度
    [indices,dists] = findNearestNeighbors(ptCloud,point,K);
        for j=1:length(indices)
            Fa_xiangAngle=acos(dot(Fa_xiang(i,:),Fa_xiang(indices(j,1),:))/(norm(Fa_xiang(i,:))*norm(Fa_xiang(indices(j,1),:))))*180/pi;
            if Fa_xiangAngle>30
                number_1=number_1+1;
            end
            M_Fa_xiangAngle=[M_Fa_xiangAngle;Fa_xiangAngle];
        end
        pingjun_Angle=sum(M_Fa_xiangAngle)/(K-1);
        if number_1>(K-2)&&pingjun_Angle>30
            features=[features;i];
        else
            B(i,:)=A(i,:);
        end
end
for i=1:length(features)
    point=A(features(i,1),:);
    [indices,dists] = findNearestNeighbors(ptCloud,point,K);
        for j=2:length(indices)
            zuobiaocha=A(indices(j,1),:)-A(i,:);
            angle0=M_Fa_xiangAngle(j,1);anggle1=(acos(dot(Fa_xiang(i,:),zuobiaocha)/(norm(Fa_xiang(i,:))*norm(zuobiaocha)))*180/pi-0.5*pi);
%             if angle0<anggle1
               a=dot(zuobiaocha,Fa_xiang(indices(j,1),:));
               B(indices(j,1),:)= A(indices(j,1),:)-3*dot((-zuobiaocha),Fa_xiang(indices(j,1),:))*Fa_xiang(indices(j,1),:);
%             else
%                B(indices(j,1),:)= A(indices(j,1),:)+5*dot((-zuobiaocha),Fa_xiang(indices(j,1),:))*Fa_xiang(indices(j,1),:);
%             end
        end
end
%% 画出法向量
subplot(1,2,1);
plot3(A(:,1),A(:,2),A(:,3),'.','markersize',5);
% hold on
% quiver3(A(1:end,1),A(1:end,2),A(1:end,3),Fa_xiang(1:end,1),Fa_xiang(1:end,2),Fa_xiang(1:end,3),2)
axis equal
axis off
% hold off
subplot(1,2,2);
plot3(B(:,1),B(:,2),B(:,3),'.','markersize',5);
% hold on
% plot3(A(:,1),A(:,2),A(:,3),'.','markersize',5);
axis equal
axis off
% dlmwrite('ping2.txt',B,'delimiter',' ','newline','pc') 