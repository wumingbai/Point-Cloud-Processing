%本程序用于最小生成树的生成
%依据法向相似
%=================================================

% clc;clear;
Data = importdata('D:\Point\zawu.txt');%导入数据
Seedpoints = importdata('D:\Point\seedpoints_zawu.txt');%种子点
Fa_xiang = importdata('D:\Point\Fa_xiang_zawu2.txt');
zaodian_zhongzi = importdata('D:\Point\chushi.txt');

M_isnan=isnan(Fa_xiang);
n_isnan= find(M_isnan(:,1)==1);%法向中有为NaN的点需要去除
Data(n_isnan,:)=[];
Fa_xiang(n_isnan,:)=[];
numData=length(Data);

%% 噪点检测
tic
numzaodian_zhongzi = length(zaodian_zhongzi);
zaodian_zhongzi_indices=[];   %用于储存序列号
for i=1:numzaodian_zhongzi
    ir = find(Seedpoints(:,1)==zaodian_zhongzi(i,1)&Seedpoints(:,2)==zaodian_zhongzi(i,2)&Seedpoints(:,3)==zaodian_zhongzi(i,3));  %返回种子点在原始数据的行索引
    zaodian_zhongzi_indices = [zaodian_zhongzi_indices;ir];
end

zaodian=[];
zaodian=[zaodian;zaodian_zhongzi_indices];
for i =1:numzaodian_zhongzi
    ir_jiedian = zaodian_zhongzi_indices(i,1);
    M_jiedian = jiedian{ir_jiedian,1};
    if (~isempty(M_jiedian)==1)
        [n_M_jiedian,m_M_jiedian]=size(M_jiedian);
        for j =1:n_M_jiedian
            a1= Seedpoint_faxiang(ir_jiedian,:);
            a2= Seedpoint_faxiang(M_jiedian(j,1),:);
            Fa_xiangAngle=acos(dot(a1,a2)/(norm(a1)*norm(a2)))*180/pi;
            if (Fa_xiangAngle<25)
                zaodian =[zaodian;M_jiedian(j,1)]
            end
        end
    end
end
toc

N_class = zaodian;
M_class=[];
for i=1:length(N_class)
    M_class=[M_class;supervoxel_cell{N_class(i),1}];
end
plot3(Data(:,1),Data(:,2),Data(:,3),'.','markersize',3);
hold on
plot3(M_class(:,1),M_class(:,2),M_class(:,3),'.','markersize',10);
axis equal
axis off
% dlmwrite('zaodian.txt',zaodian,'delimiter',' ','newline','pc') 


% m_class=[];
% n_supervoxel_cell=557;
% indices_n_supervoxel_cell=(1:n_supervoxel_cell)';
% indices_n_supervoxel_cell(zaodian,:)=[];
% for i=1:length(indices_n_supervoxel_cell)
% %     if (isempty(supervoxel_cell{N_class(i),1})==0)
%     m_class=[m_class;supervoxel_cell{indices_n_supervoxel_cell(i),1}];
% %     end
% end
% plot3(m_class(:,1),m_class(:,2),m_class(:,3),'.','markersize',10);
% axis equal
% axis off













