%���������ڵ��Ƴ����ص�����
%���ӵ���ڰ˲������ɣ��ŵ��Ϊ����

%======================================================
clc;clear;
Data = importdata('D:\Point\ping.txt');%��������
Fa_xiang = importdata('D:\Point\Fa_xiang_ping2.txt');%����ʸƽ����ķ�����

% N_class = importdata('D:\Point\M_class_indices.txt');

M_isnan=isnan(Fa_xiang);
n_isnan= find(M_isnan(:,1)==1);%��������ΪNaN�ĵ���Ҫȥ��
Data(n_isnan,:)=[];
Fa_xiang(n_isnan,:)=[];
numData=length(Data);

OT = OcTree(Data,'binCapacity',400); %���ɰ˲���
Bin_number=OT.BinCount;%���ָ��ӵ�����
D=OT.BinBoundaries;%ÿ�����ӵı߽�㣨�Խǵ㣩
A=OT.PointBins;%ÿ����������ǰ���ӵ�������
B=(1:numData)';%������
C=[B,A];
PointIndices=sortrows(C,2);
Indices = unique(A);%�ڲ��е�ĸ���������
bin_PointIndices=cell(length(Indices),1);%���ÿ�������ڲ����е��������

%�ҵ�ÿ��������ĵ���������
for i=1:length(Indices)
    [hang,lie]=find(PointIndices(:,2)==Indices(i,1));
    bin_PointIndices{i,1}=PointIndices(hang,:);
end

seedpoints=[];%��ȡ���ӵ�
for i=1:length(Indices)
    N=bin_PointIndices{i,1};
    bin_Boundaries=D(N(1,2),:);
    bincenter=[0.5*(bin_Boundaries(1,1)+bin_Boundaries(1,4)),...
               0.5*(bin_Boundaries(1,2)+bin_Boundaries(1,5)),...
               0.5*(bin_Boundaries(1,3)+bin_Boundaries(1,6))];
    M=Data(N(:,1),:);%ÿ�������еĵ�
    [IDX,dists]=knnsearch(M,bincenter); 
    pointcenter=M(IDX,:);
    seedpoints =[seedpoints;pointcenter];
end

%% �ҵ����ӵ���ԭʼ�����е����к�
numSeedpoints = length(Indices);
seed_indices=[];   %���ڴ������к�
for i=1:numSeedpoints
    ir = find(Data(:,1)==seedpoints(i,1)&Data(:,2)==seedpoints(i,2)&Data(:,3)==seedpoints(i,3));  %�������ӵ���ԭʼ���ݵ�������
    seed_indices = [seed_indices;ir];
end


%% ��ʣ��Ϊ����ĵ�������·������
tic;
supervoxel_cell = cell(numSeedpoints,1);  %���ڴ�ų������еĵ�
N_Data=[(1:numData)',Data];
K=2;
for i =1:numData
    point = N_Data(i,2:4);
    point_Fa_xiang = Fa_xiang(N_Data(i,1),:);
    [IDX,D] = knnsearch(seedpoints,point,'k',K);  %��X����Y�Ľ��ڵ㣬IDXΪ�о���
    distanceMin = IDX(1,1);
    for j = 2:K
        p1 = Fa_xiang(seed_indices(distanceMin,1),:);
        p2 = Fa_xiang(seed_indices(IDX(1,j),1),:);
        if (norm(point_Fa_xiang-p1)>norm(point_Fa_xiang-p2))
            distanceMin = IDX(1,j);
        end    
    end 
    supervoxel_cell{distanceMin,1} = [supervoxel_cell{distanceMin,1};point];%�����ڸ����صĵ���ӵ���������
    %�������ӵ�
    M_supervoxel_cell = supervoxel_cell{distanceMin,1};
    [hang_supervoxel,lie_supervoxel]=size(M_supervoxel_cell);
    zhongxin=[sum(M_supervoxel_cell(:,1))/hang_supervoxel,sum(M_supervoxel_cell(:,2))/hang_supervoxel,sum(M_supervoxel_cell(:,3))/hang_supervoxel];
    [idx,d]=knnsearch(M_supervoxel_cell,zhongxin); 
    pointcenter=M_supervoxel_cell(idx,:);
    seedpoints(distanceMin,:)=pointcenter;
end
toc

%% ��������
% subplot(1,2,2);
for i=1:length(Indices)
    M1=supervoxel_cell{i,1};       %����������е����� 
    plot3(M1(:,1),M1(:,2),M1(:,3),'.','markersize',10);
    hold on
    axis equal
end
axis off