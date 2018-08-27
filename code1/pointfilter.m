clc;clear;
K=input('请输入K值');
Fa_xiang=[];%用于储存法向量
zuobiaocha=[0,0,0];
C=zeros(3,3);
ptCloud = pcread('D:\Point\zaosheng_zhuiti3.ply');
%pcshow(ptCloud);
A = importdata('D:\Point\zaosheng_zhuiti3.txt');
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
sensorCenter = [0,0,-1];
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
%% 异向法矢平滑
sum_1=0;sum_2=0;
for ii=1:3
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
%% 法向重定向（MST）
% for i =1:length(A)
%     for j=1:K-1
%         if dot(Fa_xiang(L(i,j),:),Fa_xiang(L(i,j+1),:))<0
%             Fa_xiang(L(i,j+1),:)=-Fa_xiang(L(i,j+1),:);
%         end
%     end
% end
%max_z=max(A(:,3));
%n1=find(A(:,3)==max_z);
%sensorCenter = A(n1(1,1),:);
% a=zeros(length(A),length(A));
% for i =1:length(A)
%     for j =2:K
%         a(i,L(i,j))=1-abs(dot(Fa_xiang(i,:),Fa_xiang(L(i,j),:)))+abs(dot((A(L(i,j),:)-A(i,:)),Fa_xiang(i,:)));
%     end
% end


% temp=0;%用于储存判断最小的代价值
% sensorCenter=A(358,:);
% Hang=358;
% cishu=0;
% Biaohao=[];
% ii=0;
% while cishu<640
% %     Hang=find(A(:,1)==sensorCenter(1,1)&A(:,2)==sensorCenter(1,2)&A(:,3)==sensorCenter(1,3));
%     [indices,dists] = findNearestNeighbors(ptCloud,sensorCenter,K);
%     Daijia=[];
%     for i=2:K
%         cost=1-abs(dot(Fa_xiang(Hang,:),Fa_xiang(indices(i,1),:)));
%         Daijia=[Daijia;i,cost];
%     end
%     Biaohao=[Biaohao;Hang]; 
%     while ii~=length(Biaohao)
%         [min_cost,min_indices]=min(Daijia(:,2));
%         ii=0;
%         for i=1:length(Biaohao)
%             if indices(Daijia(min_indices,1),1)==Biaohao(i,1)
%                 Daijia(min_indices,:)=[];  
%                 break
%             end
%             ii=ii+1;
%         end
%     end
% %     [min_cost,min_indices]=min(Daijia(:,2));
% %     while ~isempty(Daijia)==0
% %         break
% %     end
%     K_indices=Daijia(min_indices,1);
%     if dot(Fa_xiang(Hang,:),Fa_xiang(indices(K_indices,1),:))<0
%         Fa_xiang(indices(K_indices,1),:)=-Fa_xiang(indices(K_indices,1),:);
%     end
%     sensorCenter=A(indices(K_indices,1),:);
% %     temp=min_cost;
% %     A(Hang,:)=[];%需要改
%     Hang=indices(K_indices,1);
%     cishu=cishu+1;
% end
%% 异向法矢平滑
% sum_1=0;sum_2=0;
% for ii=1:3
%     for i=1:length(A)
%         point=A(i,:);
%         [indices,dists] = findNearestNeighbors(ptCloud,point,K);
%         for j=2:K
%             X=norm(A(L(i,j),:)-point);
%             sum_1=sum_1+exp(-X^2/(dists(K,1)/9))*exp(-((1-Fa_xiang(i,:)*Fa_xiang(L(i,j),:)')/(1-cos(15/180*pi)))^2)*Fa_xiang(i,:);
%             sum_2=sum_2+exp(-X^2/(dists(K,1)/9))*exp(-((1-Fa_xiang(i,:)*Fa_xiang(L(i,j),:)')/(1-cos(15/180*pi)))^2);
% %             Fa_xiang(i,:)=sum_1./sum_2;
%         end
%         Fa_xiang(i,:)=sum_1./sum_2;
%         sum_1=0;sum_2=0;
%     end
% end
% for ii=1:2
%     for i=1:length(A)
%         point=A(i,:);
%         [indices,dists] = findNearestNeighbors(ptCloud,point,K);
%         n1=Fa_xiang(i,:);
%             for j=2:K
%                 X=norm(A(L(i,j),:)-point);
%                 n2=Fa_xiang(L(i,j),:);
%                 sum_1=sum_1+exp(-X^2/(dists(K,1)/9))*exp(-((1-n1*n2')/(1-cos(15/180*pi)))^2)*n2;
%                 sum_2=sum_2+exp(-X^2/(dists(K,1)/9))*exp(-((1-n1*n2')/(1-cos(15/180*pi)))^2);
%             end
%         Fa_xiang(i,:)=sum_1./sum_2;
%         sum_1=0;sum_2=0;
%     end
% end
%% 画出法向量
figure(1);
plot3(A(:,1),A(:,2),A(:,3),'.','markersize',5);
% hold on
% quiver3(A(1:end,1),A(1:end,2),A(1:end,3),Fa_xiang(1:end,1),Fa_xiang(1:end,2),Fa_xiang(1:end,3),2)
axis equal
% hold off
%% 双边滤波
%  for cishu=1:2
quan=0;
sum_quan1=0;
sum_quan2=0;
B=zeros(length(A),3);
% sum_touying=0;
M_touying=[];%用于存放投影差
for i=1:length(A)
    point=A(i,:);
    [indices,dists] = findNearestNeighbors(ptCloud,point,K);
    for j=1:length(indices)
        zuobiaocha=A(indices(j,1),:)-A(i,:);
%         zuobiaocha=A(i,:)-A(indices(j,1),:);
        touying=abs(dot(zuobiaocha,Fa_xiang(i,:)));
        M_touying=[M_touying;touying];
%         sum_touying=sum_touying+touying;
    end
%     Std_touying=sum(M_touying)/(K-1);
%     Std_touying=std(dists,1,1);
    Std_touying=1000;
    for j=2:length(indices)
%         zuobiaocha=A(indices(j,1),:)-[sum(A(L(i,:),1))/K,sum(A(L(i,:),2))/K,sum(A(L(i,:),3))/K];
        zuobiaocha=A(indices(j,1),:)-A(i,:);
%         zuobiaocha=A(i,:)-A(indices(j,1),:);
        sum_quan1=sum_quan1+Gaosi(norm(zuobiaocha),dists(K,1))*Gaosi(M_touying(j,:),Std_touying)*dot(zuobiaocha,Fa_xiang(i,:));
        sum_quan2=sum_quan2+Gaosi(norm(zuobiaocha),dists(K,1))*Gaosi(M_touying(j,:),Std_touying);
%         sum_quan1=sum_quan1+Gaosi(norm(zuobiaocha),1)*dot(zuobiaocha,Fa_xiang(i,:));
%         sum_quan2=sum_quan2+Gaosi(norm(zuobiaocha),1);
%         sum_quan1=sum_quan1+Gaosi(norm(zuobiaocha),dists(K,1))*exp(-((1-Fa_xiang(i,1)*Fa_xiang(indices(j,1),:)')/(1-cos(15/180*pi)))^2)*dot(zuobiaocha,Fa_xiang(i,:));
%         sum_quan2=sum_quan2+Gaosi(norm(zuobiaocha),dists(K,1))*exp(-((1-Fa_xiang(i,1)*Fa_xiang(indices(j,1),:)')/(1-cos(15/180*pi)))^2);
%         sum_quan1=sum_quan1+(1/norm(zuobiaocha))*(1/M_touying(j,:))*dot(zuobiaocha,Fa_xiang(i,:));
%         sum_quan2=sum_quan2+(1/norm(zuobiaocha))*(1/M_touying(j,:));
    end
    quan=sum_quan1/(sum_quan2);
    B(i,:)=A(i,:)+quan.*Fa_xiang(i,:);
    M_touying=[];
%     sum_touying=0;
end
%  end
%% 画出法向量
figure(2);
plot3(B(:,1),B(:,2),B(:,3),'.','markersize',5);
% hold on
% quiver3(A(1:end,1),A(1:end,2),A(1:end,3),Fa_xiang(1:end,1),Fa_xiang(1:end,2),Fa_xiang(1:end,3),2)
% quiver3(A(L(7,:),1),A(L(7,:),2),A(L(7,:),3),u(L(7,:)),v(L(7,:)),w(L(7,:)),2)
axis equal
% hold off