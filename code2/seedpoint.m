% 本程序根据八叉树求取区域生长的种子点
%========================================
clc;clear;
Data = importdata('D:\Point\zawu.txt');%导入数据
Fa_xiang = importdata('D:\Point\Fa_xiang_zawu2.txt');%异向法矢平滑后的法向量

tic
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
    seedpoints=[seedpoints;pointcenter];
end
toc


% dlmwrite('seedpoints_zawu.txt',seedpoints,'delimiter',' ','newline','pc') 
% dlmwrite('Fa_xiang_ping2.txt',Fa_xiang,'delimiter',' ','newline','pc')  

% M=bin_PointIndices{1,1};%存在第一个格子里的所有索引号
% N=Data(M(:,1),:);%第一个格子里的所有坐标
% plot3(Data(:,1),Data(:,2),Data(:,3),'.','markersize',3);
% hold on
% plot3(N(:,1),N(:,2),N(:,3),'.','markersize',6);
% hold on

%% 画种子点分布图
plot3(seedpoints(:,1),seedpoints(:,2),seedpoints(:,3),'.','markersize',10);
axis equal
axis off


% 画出体素
% for i=1:length(Indices)
%     N0=bin_PointIndices{i,1};       %体素里的所有点坐标 
%     M0=Data(N0(:,1)',:);
%     plot3(M0(:,1),M0(:,2),M0(:,3),'.','markersize',3);
%     hold on
%     axis equal
% end
%===========================================