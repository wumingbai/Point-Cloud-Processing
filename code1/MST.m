clc;clear;
K=input('请输入K值');
Fa_xiang=[];%用于储存法向量
zuobiaocha=[0,0,0];
C=zeros(3,3);
ptCloud = pcread('D:\Point\test2.ply');
%pcshow(ptCloud);
A = importdata('D:\Point\test2.txt');
L=zeros(length(A),K);%用于储存邻近点索引号
%% 求法向量
for i=1:length(A)
    point=A(i,:);
    [indices,dists] = findNearestNeighbors(ptCloud,point,K);
    L(i,:)=indices';
    for j=1:length(indices)
        zuobiaocha=A(indices(j,1),:)-[sum(A(L(i,:),1))/K,sum(A(L(i,:),2))/K,sum(A(L(i,:),3))/K];%传统PCA
        C=C+(1/K).*zuobiaocha'*zuobiaocha;%传统PCA
%         zuobiaocha=A(indices(j,1),:)-A(i,:);
%         weight_distance=exp(-(zuobiaocha(1,1)^2+zuobiaocha(1,2)^2+zuobiaocha(1,3)^2))/(dists(K,1)/9);%高斯权重
%         C=C+weight_distance.*zuobiaocha'*zuobiaocha;
    end
    [V,D] = eig(C);%V返回C的特征向量，D返回C的特征值
    eigenvalue=diag(D);
    min_D=min(eigenvalue);
    n=find(eigenvalue'==min_D);
    min_V=V(:,n(1,1))';
    Fa_xiang=[Fa_xiang;min_V];
    C=zeros(3,3);
end
%% 法向重定向(MSL)
sensorCenter=A(1,:);
Hang=1;
cishu=0;
Biaohao=[];
A_biaohao=[];%储存已经调整好的点
% while cishu<511
while length(A_biaohao)<length(A)
%     Hang=find(A(:,1)==sensorCenter(1,1)&A(:,2)==sensorCenter(1,2)&A(:,3)==sensorCenter(1,3));
    Biaohao=[Biaohao;Hang];
    A_biaohao=[A_biaohao;A(Hang,:)];
    [indices,dists] = findNearestNeighbors(ptCloud,sensorCenter,K);
    Daijia=[];
    for i=2:K
        cost=1-abs(dot(Fa_xiang(Hang,:),Fa_xiang(indices(i,1),:)));
        Daijia=[Daijia;indices(i,1),cost];
    end
%     Biaohao=[Biaohao;Hang];
    ii=0;
    while ii~=length(Biaohao)
        ii=0;
        [min_cost,min_indices]=min(Daijia(:,2));
        for jj=1:length(Biaohao)
            if Biaohao(jj,1)==Daijia(min_indices,1)
                Daijia(min_indices,:)=[];  
                break
            end
            ii=ii+1;
        end
        if isempty(Daijia)==1
            %这里调整sensorCenter
            Hang=indices(K,1);
            sensorCenter=A(Hang,:);
            [indices,dists] = findNearestNeighbors(ptCloud,sensorCenter,K);
            Daijia=[];
            for i=2:K
            cost=1-abs(dot(Fa_xiang(Hang,:),Fa_xiang(indices(i,1),:)));
            Daijia=[Daijia;indices(i,1),cost];
            end
%             continue
         end
    end
    K_indices=Daijia(min_indices,1);
    if dot(Fa_xiang(Hang,:),Fa_xiang(K_indices,:))<0
        Fa_xiang(K_indices,:)=-Fa_xiang(K_indices,:);
    end
    sensorCenter=A(K_indices,:);
    Hang=K_indices;
    cishu=cishu+1;
end
%% 画出法向量
figure(1);
% subplot(1,2,1);
plot3(A(:,1),A(:,2),A(:,3),'.','markersize',3);
hold on
quiver3(A(1:end,1),A(1:end,2),A(1:end,3),Fa_xiang(1:end,1),Fa_xiang(1:end,2),Fa_xiang(1:end,3),2)
% quiver3(A(L(7,:),1),A(L(7,:),2),A(L(7,:),3),u(L(7,:)),v(L(7,:)),w(L(7,:)),2)
axis equal
hold off