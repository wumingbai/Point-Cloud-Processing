%本程序用于点云法向的求取
%本程序需在MATLAB2015b之后的版本运行

%============================
%读取文件
clc;clear;
K=input('请输入K值');
Fa_xiang=[];%用于储存法向量
zuobiaocha=[0,0,0];
C=zeros(3,3);
ptCloud = pcread('D:\Point\Point_zhuiti3.ply');
%pcshow(ptCloud);
A = importdata('D:\Point\Point_zhuiti3.txt');
L=zeros(length(A),K);%用于储存邻近点索引号
%% 求法向量
for i=1:length(A)
    point=A(i,:);
    [indices,dists] = findNearestNeighbors(ptCloud,point,K);
    L(i,:)=indices';
    for j=1:length(indices)
        zuobiaocha=A(indices(j,1),:)-[sum(A(L(i,:),1))/K,sum(A(L(i,:),2))/K,sum(A(L(i,:),3))/K];%传统PCA
%         C=C+(1/K).*zuobiaocha'*zuobiaocha;%传统PCA
%         zuobiaocha=A(indices(j,1),:)-A(i,:);
        weight_distance=exp(-(zuobiaocha(1,1)^2+zuobiaocha(1,2)^2+zuobiaocha(1,3)^2))/(dists(K,1)/9);%高斯权重
        C=C+weight_distance.*zuobiaocha'*zuobiaocha;
    end
    [V,D] = eig(C);%V返回C的特征向量，D返回C的特征值
    eigenvalue=diag(D);
    min_D=min(eigenvalue);
    n=find(eigenvalue'==min_D);
    min_V=V(:,n(1,1))';
    Fa_xiang=[Fa_xiang;min_V];
    C=zeros(3,3);
end
%% 法向重定向
u = Fa_xiang(:,1);
v = Fa_xiang(:,2);
w = Fa_xiang(:,3);
sensorCenter = [0,0,-0.2];
for k = 1 : length(A)
   p1 = sensorCenter - A(k,:);
   p2 = [u(k),v(k),w(k)];
   % Flip the normal vector if it is not pointing towards the sensor.
   angle = atan2(norm(cross(p1,p2)),p1*p2');
   if angle > pi/2 || angle < -pi/2
       u(k) = -u(k);
       v(k) = -v(k);
       w(k) = -w(k);
   end
end
for k = 1 : length(A)
    u(k) = -u(k);
    v(k) = -v(k);
    w(k) = -w(k);
    Fa_xiang(k,:)=[u(k),v(k),w(k)];
end
%% 画出法向量
figure(1);
% subplot(1,2,1);
plot3(A(:,1),A(:,2),A(:,3),'.','markersize',5);
hold on
quiver3(A(1:end,1),A(1:end,2),A(1:end,3),Fa_xiang(1:end,1),Fa_xiang(1:end,2),Fa_xiang(1:end,3),2)
% quiver3(A(L(7,:),1),A(L(7,:),2),A(L(7,:),3),u(L(7,:)),v(L(7,:)),w(L(7,:)),2)
axis equal
hold off
%% 异向法矢平滑
sum_1=0;sum_2=0;
for ii=1:2
    for i=1:length(A)
        point=A(i,:);
        [indices,dists] = findNearestNeighbors(ptCloud,point,K);
        n1=Fa_xiang(i,:);
            for j=2:K
                X=norm(A(L(i,j),:)-point);
                n2=Fa_xiang(L(i,j),:);
                sum_1=sum_1+exp(-X^2/(dists(K,1)/9))*exp(-((1-n1*n2')/(1-cos(15/180*pi)))^2)*n2;
                sum_2=sum_2+exp(-X^2/(dists(K,1)/9))*exp(-((1-n1*n2')/(1-cos(15/180*pi)))^2);
%                 sum_1=sum_1+exp(-X^2/(dists(K,1)/9))*n2;
%                 sum_2=sum_2+exp(-X^2/(dists(K,1)/9));
            end
        Fa_xiang(i,:)=sum_1./sum_2;
        sum_1=0;sum_2=0;
    end
end
dlmwrite('Fa_xiang_zhuiti3_25.txt',Fa_xiang,'delimiter',' ','newline','pc')  
%% 画出法向量
% subplot(1,2,2);
figure(2);
plot3(A(:,1),A(:,2),A(:,3),'.','markersize',3);
hold on
quiver3(A(1:end,1),A(1:end,2),A(1:end,3),Fa_xiang(1:end,1),Fa_xiang(1:end,2),Fa_xiang(1:end,3),2)
% quiver3(A(L(7,:),1),A(L(7,:),2),A(L(7,:),3),u(L(7,:)),v(L(7,:)),w(L(7,:)),2)
axis equal
hold off
%==========================================