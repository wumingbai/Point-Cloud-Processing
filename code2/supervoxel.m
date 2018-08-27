%本程序用于点云超体素的生成
%种子点基于八叉树生成，优点较为均匀

%======================================================
clc;clear;
Data = importdata('D:\Point\ping.txt');
Seedpoints = importdata('D:\Point\seedpoints.txt');%种子点
numSeedpoints = length(Seedpoints);%种子点的数量
Fa_xiang = importdata('D:\Point\Fa_xiang_ping2.txt');
supervoxel_cell = cell(numSeedpoints,1);
% K=100;%近邻点的数量

M_isnan=isnan(Fa_xiang);
n_isnan= find(M_isnan(:,1)==1);%法向中有为NaN的点需要去除
Data(n_isnan,:)=[];
Fa_xiang(n_isnan,:)=[];
numData=length(Data);
Data_n=[(1:numData)',Data,Fa_xiang];


%% 找到种子点在原始数据中的序列号
seed_indices=[];   %用于储存序列号
for i=1:numSeedpoints
    ir = find(Data(:,1)==Seedpoints(i,1)&Data(:,2)==Seedpoints(i,2)&Data(:,3)==Seedpoints(i,3));  %返回种子点在原始数据的行索引
    seed_indices = [seed_indices;ir];
end

% Data_n(seed_indices,:)=[];


%% 生成超体素
for i=1:numSeedpoints
    point = Seedpoints(i,:);
%     [IDX,D] = knnsearch(Data_n(:,2:4),point,'k',K);  %在X中找Y的近邻点，IDX为行矩阵
    [IDX,D] = rangesearch(Data_n(:,2:4),point,0.015); 
    [n_IDX,m_IDX] = size(IDX{1,1});
    N=Data_n(IDX{1,1},2:4);%第一个格子里的所有坐标
    N_faxiang = Data_n(IDX{1,1},5:7);

%     j_indices =[];
%     ir = seed_indices(i,1);  
%     a = Fa_xiang(ir,:);

    for j=1:m_IDX
%         indices = IDX{1,1}';%将IDX转化为列矩阵
%         Fa_xiangAngle=acos(dot(a,Data_n(indices(j,1),5:7))/(norm(a)*norm(Data_n(indices(j,1),5:7))))*180/pi;
        N_point = N(j,:);
        N_point_Fa_xiang = N_faxiang(j,:);
        [idx,d] = rangesearch(Seedpoints,N_point,0.015);  %在X中找Y的近邻点，IDX为行矩阵
        idx_M = idx{1,1};
        [n_idx,m_idx] = size(idx_M);
        distanceMin = idx_M(1,1);
%         if Fa_xiangAngle<15
%             supervoxel_cell{i,1} = [supervoxel_cell{i,1};Data_n(indices(j,1),:)];%将属于该体素的点添加到该体素中
%             j_indices=[j_indices;j];
%         end
        for jj = 2:m_idx
            p1 = Fa_xiang(seed_indices(distanceMin,1),:);
            p2 = Fa_xiang(seed_indices(idx(1,jj),1),:);
            if (norm(point_Fa_xiang-p1)>norm(point_Fa_xiang-p2))
                distanceMin = idx(1,jj);
            end    
        end 
        supervoxel_cell{distanceMin,1} = [supervoxel_cell{distanceMin,1};point];%将属于该体素的点添加到该体素中
    end 
%     M = supervoxel_cell{i,1};   %提取元胞中的体素坐标点
    Data_n(IDX,:)=[]; 

end

%     for j =1:m_IDX
%         point = N(i,:);
%         point_Fa_xiang = Fa_xiang(restofpoints(i,1),:);
%         [IDX,D] = knnsearch(seedpoints,point,'k',K);  %在X中找Y的近邻点，IDX为行矩阵
%         distanceMin = IDX(1,1);
%         for jj = 2:K
%             p1 = Fa_xiang(seed_indices(distanceMin,1),:);
%             p2 = Fa_xiang(seed_indices(IDX(1,j),1),:);
%             if (norm(point_Fa_xiang-p1)>norm(point_Fa_xiang-p2))
%                 distanceMin = IDX(1,j);
%             end    
%         end 
%         supervoxel_cell{distanceMin,1} = [supervoxel_cell{distanceMin,1};point];%将属于该体素的点添加到该体素中
%     end











% N=supervoxel_cell{332,1};
% plot3(Data(:,1),Data(:,2),Data(:,3),'.','markersize',3);
% hold on
% plot3(N(:,2),N(:,3),N(:,4),'.','markersize',6);
% axis equal



% 画出体素
for i=1: numSeedpoints
    N=supervoxel_cell{i,1};       %体素里的所有点坐标 
    if (~isempty(N)==1)
    plot3(N(:,2),N(:,3),N(:,4),'.','markersize',3);
    hold on
    axis equal
    end
end



% N=Data(IDX,:);%第一个格子里的所有坐标   
% plot3(Data(:,1),Data(:,2),Data(:,3),'.','markersize',3);
% hold on
% plot3(N(:,1),N(:,2),N(:,3),'.','markersize',6);
% axis equal
