%���������ڵ��Ƴ����ص�����
%���ӵ���ڰ˲������ɣ��ŵ��Ϊ����

%======================================================
clc;clear;
Data = importdata('D:\Point\zawu.txt');%��������
Fa_xiang = importdata('D:\Point\Fa_xiang_zawu2.txt');%����ʸƽ����ķ�����

N_class = importdata('D:\Point\zaodian.txt');

M_isnan=isnan(Fa_xiang);
n_isnan= find(M_isnan(:,1)==1);%��������ΪNaN�ĵ���Ҫȥ��
Data(n_isnan,:)=[];
Fa_xiang(n_isnan,:)=[];
numData=length(Data);


OT = OcTree(Data,'binCapacity',300); %���ɰ˲���
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

%% ɸѡ��ÿ�������������ӵ㷨����ͬ�ĵ�
tic;
supervoxel_cell = cell(numSeedpoints,1);  %���ڴ�ų������еĵ�
restofpoints =[];                        %���ÿ�������������ӵ㷨��ͬ�ĵ�
for i = 1:length(Indices)
    N0=bin_PointIndices{i,1};       
    M0=Data(N0(:,1)',:);             %����������е�����
    M0_Fa_xiang = Fa_xiang(N0(:,1)',:);
    [n_M0,m_M0]=size(M0);
    ir = seed_indices(i,1);  
    a = Fa_xiang(ir,:);
    for j = 1:n_M0
%         Fa_xiangAngle=acos(dot(a,Fa_xiang(N0(j,1),:))/(norm(a)*norm(Fa_xiang(N0(j,1),:))))*180/pi;
        Fa_xiangAngle=acos(dot(a,M0_Fa_xiang(j,:))/(norm(a)*norm(M0_Fa_xiang(j,:))))*180/pi;
        if Fa_xiangAngle<15
            supervoxel_cell{i,1} = [supervoxel_cell{i,1};Data(N0(j,1),:)];%�����ڸ����صĵ���ӵ���������
        else
            restofpoints = [restofpoints;[N0(j,1),Data(N0(j,1),:)]];
        end
    end   
end

% subplot(1,2,1);
% for i=1:length(Indices)
%     M1=supervoxel_cell{i,1};       %����������е����� 
%     plot3(M1(:,1),M1(:,2),M1(:,3),'.','markersize',10);
%     hold on
%     axis equal
% end

%% ��ʣ��Ϊ����ĵ�������·������
numrestofpoints = length(restofpoints);
K=4;
for i =1:numrestofpoints
    point = restofpoints(i,2:4);
    point_Fa_xiang = Fa_xiang(restofpoints(i,1),:);
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
%     M_supervoxel_cell = supervoxel_cell{distanceMin,1};
%     [hang_supervoxel,lie_supervoxel]=size(M_supervoxel_cell);
%     zhongxin=[sum(M_supervoxel_cell(:,1))/hang_supervoxel,sum(M_supervoxel_cell(:,2))/hang_supervoxel,sum(M_supervoxel_cell(:,3))/hang_supervoxel];
%     [idx,d]=knnsearch(M_supervoxel_cell,zhongxin); 
%     pointcenter=M_supervoxel_cell(idx,:);
%     seedpoints(distanceMin,:)=pointcenter;
end
toc

%% ��������
% % subplot(1,2,1);
for i=1:length(Indices)
    M1=supervoxel_cell{i,1};       %����������е����� 
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
%     [IDX,D] = knnsearch(seedpoints,point,'k',K);  %��X����Y�Ľ��ڵ㣬IDXΪ�о���
%     distanceMin = IDX(1,1);
%     for j = 2:K
%         p1 = Fa_xiang(seed_indices(distanceMin,1),:);
%         p2 = Fa_xiang(seed_indices(IDX(1,j),1),:);
%         if (norm(point_Fa_xiang-p1)>norm(point_Fa_xiang-p2))
%             distanceMin = IDX(1,j);
%         end    
%     end 
%     supervoxel_cell{distanceMin,1} = [supervoxel_cell{distanceMin,1};point];%�����ڸ����صĵ���ӵ���������
%     M_supervoxel_cell = supervoxel_cell{distanceMin,1};
%     [hang_supervoxel,lie_supervoxel]=size(M_supervoxel_cell);
%     zhongxin=[sum(M_supervoxel_cell(:,1))/hang_supervoxel,sum(M_supervoxel_cell(:,2))/hang_supervoxel,sum(M_supervoxel_cell(:,3))/hang_supervoxel];
%     [idx,d]=knnsearch(M_supervoxel_cell,zhongxin); 
%     pointcenter=M_supervoxel_cell(idx,:);
%     seedpoints(distanceMin,:)=pointcenter;
% end
% 
% %% ��������
% subplot(1,2,2);
% for i=1:length(Indices)
%     M1=supervoxel_cell{i,1};       %����������е����� 
%     plot3(M1(:,1),M1(:,2),M1(:,3),'.','markersize',10);
%     hold on
%     axis equal
% end
% plot3(Data(:,1),Data(:,2),Data(:,3),'.','markersize',3);
% hold on
% axis equal
% M1=supervoxel_cell{1,1};       %����������е����� 
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

