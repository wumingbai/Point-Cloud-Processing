clc;clear;
K=8;
A=importdata('D:\Point\zawu.txt');
Fa_xiang=importdata('D:\Point\Fa_xiang_zawu.txt');
ptCloud = pcread('D:\Point\zawu.ply');
figure(1);
% subplot(1,2,1);
plot3(A(:,1),A(:,2),A(:,3),'.','markersize',5);
hold on
quiver3(A(1:end,1),A(1:end,2),A(1:end,3),Fa_xiang(1:end,1),Fa_xiang(1:end,2),Fa_xiang(1:end,3),2)
% quiver3(A(L(7,:),1),A(L(7,:),2),A(L(7,:),3),u(L(7,:)),v(L(7,:)),w(L(7,:)),2)
axis equal
hold off
%% 异向法矢平滑
L=zeros(length(A),K);%用于储存邻近点索引号
sum_1=0;sum_2=0;
for ii=1:2
    for i=1:length(A)
        point=A(i,:);
        [indices,dists] = findNearestNeighbors(ptCloud,point,K);
%         [indices,dists] = knnsearch(A,point,'k',K);
        L(i,:)=indices';
        n1=Fa_xiang(i,:);
            for j=2:K
                X=norm(A(L(i,j),:)-point);
                n2=Fa_xiang(L(i,j),:);
                sum_1=sum_1+exp(-X^2/(dists(K,1)/9))*exp(-((1-n1*n2')/(1-cos(25/180*pi)))^2)*n2;
                sum_2=sum_2+exp(-X^2/(dists(K,1)/9))*exp(-((1-n1*n2')/(1-cos(25/180*pi)))^2);
%                 sum_1=sum_1+exp(-X^2/(dists(K,1)/9))*n2;
%                 sum_2=sum_2+exp(-X^2/(dists(K,1)/9));
            end
        Fa_xiang(i,:)=sum_1./sum_2;
        sum_1=0;sum_2=0;
    end
end
dlmwrite('Fa_xiang_zawu2.txt',Fa_xiang,'delimiter',' ','newline','pc')  
%% 画出法向量
% subplot(1,2,2);
figure(2);
plot3(A(:,1),A(:,2),A(:,3),'.','markersize',3);
hold on
quiver3(A(1:end,1),A(1:end,2),A(1:end,3),Fa_xiang(1:end,1),Fa_xiang(1:end,2),Fa_xiang(1:end,3),2)
% quiver3(A(L(7,:),1),A(L(7,:),2),A(L(7,:),3),u(L(7,:)),v(L(7,:)),w(L(7,:)),2)
axis equal
hold off