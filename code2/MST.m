%本程序用于最小生成树的生成
%依据最短距离
%=================================================

clc;clear;
Seedpoints = importdata('D:\Point\seedpoints_zawu.txt');%种子点
N=length(Seedpoints);%点的数量
jiedian=cell(N,1);%最小树的节点
N_Seedpoints=[(1:N)',Seedpoints];
M_weibiaoji=N_Seedpoints;%存放没有被标记的点
M_biaoji=[];%存放已经被标记的点

%初始化
tic;
M_biaoji=[M_biaoji;N_Seedpoints(1,:)];
M_weibiaoji(1,:)=[];
while (~isempty(M_weibiaoji)==1)
    [idx,dists]= knnsearch(M_weibiaoji(:,2:4),M_biaoji(:,2:4));
    [x,m]=min(dists);                         %x为最小值，m为最小值中的序号，dists中点的序号对应的是M_biaoji中点的序号
    idx_biaoji=idx(m(1,1),1);                 %以上两步是为了找到当前距离已标记点最短距离的点
    
    jiedian_biaohao=M_biaoji(m,1);
    jiedian{jiedian_biaohao,1}=[jiedian{jiedian_biaohao,1};M_weibiaoji(idx_biaoji,:)];
    
    M_biaoji=[M_biaoji;M_weibiaoji(idx_biaoji,:)];  
    M_weibiaoji(idx_biaoji,:)=[];
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
% [IDX, D] = knnsearch(X,Y,'k',5)
