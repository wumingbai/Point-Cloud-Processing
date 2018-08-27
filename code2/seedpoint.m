% ��������ݰ˲�����ȡ�������������ӵ�
%========================================
clc;clear;
Data = importdata('D:\Point\zawu.txt');%��������
Fa_xiang = importdata('D:\Point\Fa_xiang_zawu2.txt');%����ʸƽ����ķ�����

tic
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
    seedpoints=[seedpoints;pointcenter];
end
toc


% dlmwrite('seedpoints_zawu.txt',seedpoints,'delimiter',' ','newline','pc') 
% dlmwrite('Fa_xiang_ping2.txt',Fa_xiang,'delimiter',' ','newline','pc')  

% M=bin_PointIndices{1,1};%���ڵ�һ�������������������
% N=Data(M(:,1),:);%��һ�����������������
% plot3(Data(:,1),Data(:,2),Data(:,3),'.','markersize',3);
% hold on
% plot3(N(:,1),N(:,2),N(:,3),'.','markersize',6);
% hold on

%% �����ӵ�ֲ�ͼ
plot3(seedpoints(:,1),seedpoints(:,2),seedpoints(:,3),'.','markersize',10);
axis equal
axis off


% ��������
% for i=1:length(Indices)
%     N0=bin_PointIndices{i,1};       %����������е����� 
%     M0=Data(N0(:,1)',:);
%     plot3(M0(:,1),M0(:,2),M0(:,3),'.','markersize',3);
%     hold on
%     axis equal
% end
%===========================================