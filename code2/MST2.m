%本程序用于最小生成树的生成
%依据法向相似
%=================================================

% clc;clear;
Data = importdata('D:\Point\zawu.txt');%导入数据
Seedpoints = importdata('D:\Point\seedpoints_zawu.txt');%种子点
Fa_xiang = importdata('D:\Point\Fa_xiang_zawu2.txt');

M_isnan=isnan(Fa_xiang);
n_isnan= find(M_isnan(:,1)==1);%法向中有为NaN的点需要去除
Data(n_isnan,:)=[];
Fa_xiang(n_isnan,:)=[];
numData=length(Data);

N=length(Seedpoints);%点的数量
jiedian=cell(N,1);%最小树的节点
N_Seedpoints=[(1:N)',Seedpoints];
M_weibiaoji=N_Seedpoints;%存放没有被标记的点
M_biaoji=[];%存放已经被标记的点

%% 找到种子点在原始数据中的序列号
numSeedpoints = N;
seed_indices=[];   %用于储存序列号
for i=1:numSeedpoints
    ir = find(Data(:,1)==Seedpoints(i,1)&Data(:,2)==Seedpoints(i,2)&Data(:,3)==Seedpoints(i,3));  %返回种子点在原始数据的行索引
    seed_indices = [seed_indices;ir];
end

%% 生成最小树
%初始化
Seedpoint_faxiang = Fa_xiang(seed_indices,:);
M_biaoji=[M_biaoji;N_Seedpoints(1,:)];
M_weibiaoji(1,:)=[];
M_Fa_xiangAngle=[];
tic
while (~isempty(M_weibiaoji)==1)
    [hang_biaoji,lie_biaoji]=size(M_biaoji);
    for i=1:hang_biaoji
%         [idx,dists]= knnsearch(M_weibiaoji(:,2:4),M_biaoji(i,2:4),'k',3);%idx为行矩阵
        [IDX,D] = rangesearch(M_weibiaoji(:,2:4),M_biaoji(i,2:4),0.1502); 
        idx = IDX{1,1};
        p=Fa_xiang(M_biaoji(i,1),:);
        if (~isempty(idx)==1)
            for j = 1:length(idx)
                indices = idx(1,j);
                Fa_xiangAngle=acos(dot(p,Seedpoint_faxiang(M_weibiaoji(indices,1),:))/(norm(p)*norm(Seedpoint_faxiang(M_weibiaoji(indices,1),:))))*180/pi;
                M_Fa_xiangAngle=[M_Fa_xiangAngle;[M_biaoji(i,1),M_weibiaoji(indices,1),Fa_xiangAngle]];
            end
        else
            continue;
        end
    end

    [x,m]=min(M_Fa_xiangAngle(:,3));                      %x为最小值，m为最小值中的序号，dists中点的序号对应的是M_biaoji中点的序号
    idx_biaoji=M_Fa_xiangAngle(m(1,1),2);                 %以上两步是为了找到当前距离已标记点最短距离的点
    
    jiedian_biaohao=M_Fa_xiangAngle(m(1,1),1);
    jiedian{jiedian_biaohao,1}=[jiedian{jiedian_biaohao,1};N_Seedpoints(idx_biaoji,:)];
    
    M_biaoji=[M_biaoji;N_Seedpoints(idx_biaoji,:)];  
    n_shanchu=find(M_weibiaoji(:,1)==idx_biaoji);
    M_weibiaoji(n_shanchu,:)=[];
    M_Fa_xiangAngle=[];
end
toc
%% 画图
for i=1:N
    if (~isempty(jiedian{i,1})==1)
        [hang,lie]=size(jiedian{i,1});
        a=Seedpoints(i,:);
        B=jiedian{i,1};
        for j=1:hang
            plot3([a(1,1),B(j,2)],[a(1,2),B(j,3)],[a(1,3),B(j,4)]);
%             axis equal
            hold on
        end
    end    
end
axis equal
axis off
%=============================================