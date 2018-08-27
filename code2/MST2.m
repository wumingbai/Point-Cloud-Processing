%������������С������������
%���ݷ�������
%=================================================

% clc;clear;
Data = importdata('D:\Point\zawu.txt');%��������
Seedpoints = importdata('D:\Point\seedpoints_zawu.txt');%���ӵ�
Fa_xiang = importdata('D:\Point\Fa_xiang_zawu2.txt');

M_isnan=isnan(Fa_xiang);
n_isnan= find(M_isnan(:,1)==1);%��������ΪNaN�ĵ���Ҫȥ��
Data(n_isnan,:)=[];
Fa_xiang(n_isnan,:)=[];
numData=length(Data);

N=length(Seedpoints);%�������
jiedian=cell(N,1);%��С���Ľڵ�
N_Seedpoints=[(1:N)',Seedpoints];
M_weibiaoji=N_Seedpoints;%���û�б���ǵĵ�
M_biaoji=[];%����Ѿ�����ǵĵ�

%% �ҵ����ӵ���ԭʼ�����е����к�
numSeedpoints = N;
seed_indices=[];   %���ڴ������к�
for i=1:numSeedpoints
    ir = find(Data(:,1)==Seedpoints(i,1)&Data(:,2)==Seedpoints(i,2)&Data(:,3)==Seedpoints(i,3));  %�������ӵ���ԭʼ���ݵ�������
    seed_indices = [seed_indices;ir];
end

%% ������С��
%��ʼ��
Seedpoint_faxiang = Fa_xiang(seed_indices,:);
M_biaoji=[M_biaoji;N_Seedpoints(1,:)];
M_weibiaoji(1,:)=[];
M_Fa_xiangAngle=[];
tic
while (~isempty(M_weibiaoji)==1)
    [hang_biaoji,lie_biaoji]=size(M_biaoji);
    for i=1:hang_biaoji
%         [idx,dists]= knnsearch(M_weibiaoji(:,2:4),M_biaoji(i,2:4),'k',3);%idxΪ�о���
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

    [x,m]=min(M_Fa_xiangAngle(:,3));                      %xΪ��Сֵ��mΪ��Сֵ�е���ţ�dists�е����Ŷ�Ӧ����M_biaoji�е�����
    idx_biaoji=M_Fa_xiangAngle(m(1,1),2);                 %����������Ϊ���ҵ���ǰ�����ѱ�ǵ���̾���ĵ�
    
    jiedian_biaohao=M_Fa_xiangAngle(m(1,1),1);
    jiedian{jiedian_biaohao,1}=[jiedian{jiedian_biaohao,1};N_Seedpoints(idx_biaoji,:)];
    
    M_biaoji=[M_biaoji;N_Seedpoints(idx_biaoji,:)];  
    n_shanchu=find(M_weibiaoji(:,1)==idx_biaoji);
    M_weibiaoji(n_shanchu,:)=[];
    M_Fa_xiangAngle=[];
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