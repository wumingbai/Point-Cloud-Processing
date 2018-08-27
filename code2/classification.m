%���������ڵ��Ʒָ��Ҫ�ǽ��������ںϣ�������ʽ��������С������
%==========================================

clc;clear;
seedpoints = importdata('D:\Point\seedpoints.txt');%���ӵ�
Data = importdata('D:\Point\ping.txt');%��������
Fa_xiang = importdata('D:\Point\Fa_xiang_ping2.txt');%����ʸƽ����ķ�����

M_isnan=isnan(Fa_xiang);
n_isnan= find(M_isnan(:,1)==1);%��������ΪNaN�ĵ���Ҫȥ��
Data(n_isnan,:)=[];
Fa_xiang(n_isnan,:)=[];
numData=length(Data);

N=length(seedpoints);%�������
jiedian=cell(N,1);%��С���Ľڵ�
N_Seedpoints=[(1:N)',seedpoints];
M_weibiaoji=N_Seedpoints;%���û�б���ǵĵ�
M_biaoji=[];%����Ѿ�����ǵĵ�

%% ������С��
%��ʼ��
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

%% �ҵ����ӵ���ԭʼ�����е����к�
seed_indices=[];   %���ڴ������к�
for i=1:N
    ir = find(Data(:,1)==seedpoints(i,1)&Data(:,2)==seedpoints(i,2)&Data(:,3)==seedpoints(i,3));  %�������ӵ���ԭʼ���ݵ�������
    seed_indices = [seed_indices;ir];
end

%% �ں�
restofclass_indices = (1:N)';     %δ����ǵ�
next_search = [];                 %���ڴ����һ�ε����������ӵ�
class_indices = cell(N,1);        %ÿһ�д��һ������ӵ�������
x_search = [];                    %������ʱ��ŵ�ǰ�������ӵĵ�

numclass=1;                       %��һ��
next_search = [next_search;1];    %�ȴӵ�һ���㿪ʼ 
class_indices{1,1} = [class_indices{1,1};1];     %����һ��������һ�൱��
restofclass_indices(1,:)=[];      %��δ����ǵ��еĵ�һ����ɾ��

while (~isempty(restofclass_indices)==1)
    for i=1:length(next_search) 
        irr = next_search(i,1);  %�������ӵ��������
        if (~isempty(jiedian{irr,1})==1)
            a1 = Fa_xiang(seed_indices(irr,1),:);
            B=jiedian{irr,1};     %�ýڵ����������������ڵ�ż�������
            [hang,lie]=size(B);
         
            for j = 1:hang
                indicesofData=seed_indices(B(j,1),1);%���ӵ���������������е�����
                 Fa_xiangAngle=acos(dot(a1,Fa_xiang(indicesofData,:))/(norm(a1)*norm(Fa_xiang(indicesofData,:))))*180/pi;
                 if Fa_xiangAngle<30
                     x_search = [x_search;B(j,1)]; 
                     n_biaoji = find(restofclass_indices==B(j,1));%�ҵ����ںϵ��������
                     restofclass_indices(n_biaoji,:) = [];    %ɾ���Ѿ����ںϵĵ�
                 end
            end
            
        end
    end
    
        next_search = x_search;    %��һ����Ҫ����������
        class_indices{numclass,1} = [class_indices{numclass,1};next_search]; %�����ڸ�������ӵ��ں�
        x_search = [];
        
        if (isempty(next_search)==1)
           for ii = 1:length(restofclass_indices)
               if (~isempty(jiedian{restofclass_indices(ii,1),1})==1)
                   next_search = restofclass_indices(ii,1);
                   numclass = numclass+1;
                   class_indices{numclass,1} = [class_indices{numclass,1};next_search];
                   restofclass_indices(ii,:) = [];    %ɾ���Ѿ����ںϵĵ�
                   break;
               end
           end
        end
        
        if (length(restofclass_indices)==12)
            break
        end      
end


M_class_indices = class_indices{2,1};
dlmwrite('M_class_indices.txt',M_class_indices,'delimiter',' ','newline','pc') 


% %% ��ͼ
% for i=1:N
%     if (~isempty(jiedian{i,1})==1)
%         [hang,lie]=size(jiedian{i,1});
%         a=Seedpoints(i,:);
%         B=jiedian{i,1};
%         for j=1:hang
%             plot3([a(1,1),B(j,2)],[a(1,2),B(j,3)],[a(1,3),B(j,4)]);
%             axis equal
%             hold on
%         end
%     end    
% end
