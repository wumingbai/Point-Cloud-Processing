%������������С������������
%������̾���
%=================================================

clc;clear;
Seedpoints = importdata('D:\Point\seedpoints_zawu.txt');%���ӵ�
N=length(Seedpoints);%�������
jiedian=cell(N,1);%��С���Ľڵ�
N_Seedpoints=[(1:N)',Seedpoints];
M_weibiaoji=N_Seedpoints;%���û�б���ǵĵ�
M_biaoji=[];%����Ѿ�����ǵĵ�

%��ʼ��
tic;
M_biaoji=[M_biaoji;N_Seedpoints(1,:)];
M_weibiaoji(1,:)=[];
while (~isempty(M_weibiaoji)==1)
    [idx,dists]= knnsearch(M_weibiaoji(:,2:4),M_biaoji(:,2:4));
    [x,m]=min(dists);                         %xΪ��Сֵ��mΪ��Сֵ�е���ţ�dists�е����Ŷ�Ӧ����M_biaoji�е�����
    idx_biaoji=idx(m(1,1),1);                 %����������Ϊ���ҵ���ǰ�����ѱ�ǵ���̾���ĵ�
    
    jiedian_biaohao=M_biaoji(m,1);
    jiedian{jiedian_biaohao,1}=[jiedian{jiedian_biaohao,1};M_weibiaoji(idx_biaoji,:)];
    
    M_biaoji=[M_biaoji;M_weibiaoji(idx_biaoji,:)];  
    M_weibiaoji(idx_biaoji,:)=[];
end
toc

%% ��ͼ
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
