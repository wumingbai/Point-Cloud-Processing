%本程序用于点云超体素的生成
%种子点基于八叉树生成，优点较为均匀

%======================================================
clc;clear;
Data = importdata('D:\Point\zawu.txt');%导入数据
Fa_xiang = importdata('D:\Point\Fa_xiang_zawu2.txt');%异向法矢平滑后的法向量

N_class = importdata('D:\Point\zaodian.txt');

M_isnan=isnan(Fa_xiang);
n_isnan= find(M_isnan(:,1)==1);%法向中有为NaN的点需要去除
Data(n_isnan,:)=[];
Fa_xiang(n_isnan,:)=[];
numData=length(Data);


OT = OcTree(Data,'binCapacity',300); %生成八叉树
Bin_number=OT.BinCount;%划分格子的数量
D=OT.BinBoundaries;%每个格子的边界点（对角点）
A=OT.PointBins;%每个点所属当前格子的索引号
B=(1:numData)';%索引号
C=[B,A];
PointIndices=sortrows(C,2);
Indices = unique(A);%内部有点的格子索引号
bin_PointIndices=cell(length(Indices),1);%存放每个格子内部所有点的索引号

%找到每个格子里的点云索引号
for i=1:length(Indices)
    [hang,lie]=find(PointIndices(:,2)==Indices(i,1));
    bin_PointIndices{i,1}=PointIndices(hang,:);
end

seedpoints=[];%求取种子点
for i=1:length(Indices)
    N=bin_PointIndices{i,1};
    bin_Boundaries=D(N(1,2),:);
    bincenter=[0.5*(bin_Boundaries(1,1)+bin_Boundaries(1,4)),...
               0.5*(bin_Boundaries(1,2)+bin_Boundaries(1,5)),...
               0.5*(bin_Boundaries(1,3)+bin_Boundaries(1,6))];
    M=Data(N(:,1),:);%每个格子中的点
    [IDX,dists]=knnsearch(M,bincenter); 
    pointcenter=M(IDX,:);
    seedpoints =[seedpoints;pointcenter];
end

%% 找到种子点在原始数据中的序列号
numSeedpoints = length(Indices);
seed_indices=[];   %用于储存序列号
for i=1:numSeedpoints
    ir = find(Data(:,1)==seedpoints(i,1)&Data(:,2)==seedpoints(i,2)&Data(:,3)==seedpoints(i,3));  %返回种子点在原始数据的行索引
    seed_indices = [seed_indices;ir];
end

%% 筛选出每个格子中与种子点法向相同的点
tic;
supervoxel_cell = cell(numSeedpoints,1);  %用于存放超体素中的点
restofpoints =[];                        %存放每个格子中与种子点法向不同的点
for i = 1:length(Indices)
    N0=bin_PointIndices{i,1};       
    M0=Data(N0(:,1)',:);             %格子里的所有点坐标
    M0_Fa_xiang = Fa_xiang(N0(:,1)',:);
    [n_M0,m_M0]=size(M0);
    ir = seed_indices(i,1);  
    a = Fa_xiang(ir,:);
    for j = 1:n_M0
%         Fa_xiangAngle=acos(dot(a,Fa_xiang(N0(j,1),:))/(norm(a)*norm(Fa_xiang(N0(j,1),:))))*180/pi;
        Fa_xiangAngle=acos(dot(a,M0_Fa_xiang(j,:))/(norm(a)*norm(M0_Fa_xiang(j,:))))*180/pi;
        if Fa_xiangAngle<15
            supervoxel_cell{i,1} = [supervoxel_cell{i,1};Data(N0(j,1),:)];%将属于该体素的点添加到该体素中
        else
            restofpoints = [restofpoints;[N0(j,1),Data(N0(j,1),:)]];
        end
    end   
end

% subplot(1,2,1);
% for i=1:length(Indices)
%     M1=supervoxel_cell{i,1};       %体素里的所有点坐标 
%     plot3(M1(:,1),M1(:,2),M1(:,3),'.','markersize',10);
%     hold on
%     axis equal
% end

%% 将剩下为分配的点进行重新分配聚类
numrestofpoints = length(restofpoints);
K=4;
for i =1:numrestofpoints
    point = restofpoints(i,2:4);
    point_Fa_xiang = Fa_xiang(restofpoints(i,1),:);
    [IDX,D] = knnsearch(seedpoints,point,'k',K);  %在X中找Y的近邻点，IDX为行矩阵
    distanceMin = IDX(1,1);
    for j = 2:K
        p1 = Fa_xiang(seed_indices(distanceMin,1),:);
        p2 = Fa_xiang(seed_indices(IDX(1,j),1),:);
        if (norm(point_Fa_xiang-p1)>norm(point_Fa_xiang-p2))
            distanceMin = IDX(1,j);
        end    
    end 
    supervoxel_cell{distanceMin,1} = [supervoxel_cell{distanceMin,1};point];%将属于该体素的点添加到该体素中
%     M_supervoxel_cell = supervoxel_cell{distanceMin,1};
%     [hang_supervoxel,lie_supervoxel]=size(M_supervoxel_cell);
%     zhongxin=[sum(M_supervoxel_cell(:,1))/hang_supervoxel,sum(M_supervoxel_cell(:,2))/hang_supervoxel,sum(M_supervoxel_cell(:,3))/hang_supervoxel];
%     [idx,d]=knnsearch(M_supervoxel_cell,zhongxin); 
%     pointcenter=M_supervoxel_cell(idx,:);
%     seedpoints(distanceMin,:)=pointcenter;
end
toc

%% 画出体素
% % subplot(1,2,1);
for i=1:length(Indices)
    M1=supervoxel_cell{i,1};       %体素里的所有点坐标 
    if (~isempty(M1)==1)
    plot3(M1(:,1),M1(:,2),M1(:,3),'.','markersize',10);
    hold on
    axis equal
    end
end
axis off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% for i =1:numrestofpoints
%     point = restofpoints(i,2:4);
%     point_Fa_xiang = Fa_xiang(restofpoints(i,1),:);
%     [IDX,D] = knnsearch(seedpoints,point,'k',K);  %在X中找Y的近邻点，IDX为行矩阵
%     distanceMin = IDX(1,1);
%     for j = 2:K
%         p1 = Fa_xiang(seed_indices(distanceMin,1),:);
%         p2 = Fa_xiang(seed_indices(IDX(1,j),1),:);
%         if (norm(point_Fa_xiang-p1)>norm(point_Fa_xiang-p2))
%             distanceMin = IDX(1,j);
%         end    
%     end 
%     supervoxel_cell{distanceMin,1} = [supervoxel_cell{distanceMin,1};point];%将属于该体素的点添加到该体素中
%     M_supervoxel_cell = supervoxel_cell{distanceMin,1};
%     [hang_supervoxel,lie_supervoxel]=size(M_supervoxel_cell);
%     zhongxin=[sum(M_supervoxel_cell(:,1))/hang_supervoxel,sum(M_supervoxel_cell(:,2))/hang_supervoxel,sum(M_supervoxel_cell(:,3))/hang_supervoxel];
%     [idx,d]=knnsearch(M_supervoxel_cell,zhongxin); 
%     pointcenter=M_supervoxel_cell(idx,:);
%     seedpoints(distanceMin,:)=pointcenter;
% end
% 
% %% 画出体素
% subplot(1,2,2);
% for i=1:length(Indices)
%     M1=supervoxel_cell{i,1};       %体素里的所有点坐标 
%     plot3(M1(:,1),M1(:,2),M1(:,3),'.','markersize',10);
%     hold on
%     axis equal
% end
% plot3(Data(:,1),Data(:,2),Data(:,3),'.','markersize',3);
% hold on
% axis equal
% M1=supervoxel_cell{1,1};       %体素里的所有点坐标 
% M2=supervoxel_cell{57,1}; 
% plot3(M1(:,1),M1(:,2),M1(:,3),'.','markersize',10);
% hold on
% plot3(M2(:,1),M2(:,2),M2(:,3),'.','markersize',10);

% M_class=[];
% for i=1:length(N_class)
%     M_class=[M_class;supervoxel_cell{N_class(i),1}];
% end
% plot3(Data(:,1),Data(:,2),Data(:,3),'.','markersize',3);
% hold on
% plot3(M_class(:,1),M_class(:,2),M_class(:,3),'.','markersize',10);
% axis equal
% axis off
%==========================================================

