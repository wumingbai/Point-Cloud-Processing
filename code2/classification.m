%本程序用于点云分割，主要是将超体素融合，搜索方式是依据最小树搜索
%==========================================

clc;clear;
seedpoints = importdata('D:\Point\seedpoints.txt');%种子点
Data = importdata('D:\Point\ping.txt');%导入数据
Fa_xiang = importdata('D:\Point\Fa_xiang_ping2.txt');%异向法矢平滑后的法向量

M_isnan=isnan(Fa_xiang);
n_isnan= find(M_isnan(:,1)==1);%法向中有为NaN的点需要去除
Data(n_isnan,:)=[];
Fa_xiang(n_isnan,:)=[];
numData=length(Data);

N=length(seedpoints);%点的数量
jiedian=cell(N,1);%最小树的节点
N_Seedpoints=[(1:N)',seedpoints];
M_weibiaoji=N_Seedpoints;%存放没有被标记的点
M_biaoji=[];%存放已经被标记的点

%% 生成最小树
%初始化
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

%% 找到种子点在原始数据中的序列号
seed_indices=[];   %用于储存序列号
for i=1:N
    ir = find(Data(:,1)==seedpoints(i,1)&Data(:,2)==seedpoints(i,2)&Data(:,3)==seedpoints(i,3));  %返回种子点在原始数据的行索引
    seed_indices = [seed_indices;ir];
end

%% 融合
restofclass_indices = (1:N)';     %未被标记点
next_search = [];                 %用于存放下一次的搜索的种子点
class_indices = cell(N,1);        %每一列存放一类的种子点索引号
x_search = [];                    %用于临时存放当前符合种子的点

numclass=1;                       %第一类
next_search = [next_search;1];    %先从第一个点开始 
class_indices{1,1} = [class_indices{1,1};1];     %将第一个点加入第一类当中
restofclass_indices(1,:)=[];      %将未被标记点中的第一个点删除

while (~isempty(restofclass_indices)==1)
    for i=1:length(next_search) 
        irr = next_search(i,1);  %其中种子点的索引号
        if (~isempty(jiedian{irr,1})==1)
            a1 = Fa_xiang(seed_indices(irr,1),:);
            B=jiedian{irr,1};     %该节点中所包含的其他节点号及其坐标
            [hang,lie]=size(B);
         
            for j = 1:hang
                indicesofData=seed_indices(B(j,1),1);%种子点在整体点云数据中的索引
                 Fa_xiangAngle=acos(dot(a1,Fa_xiang(indicesofData,:))/(norm(a1)*norm(Fa_xiang(indicesofData,:))))*180/pi;
                 if Fa_xiangAngle<30
                     x_search = [x_search;B(j,1)]; 
                     n_biaoji = find(restofclass_indices==B(j,1));%找到被融合点的索引号
                     restofclass_indices(n_biaoji,:) = [];    %删除已经被融合的点
                 end
            end
            
        end
    end
    
        next_search = x_search;    %下一次需要搜索的种子
        class_indices{numclass,1} = [class_indices{numclass,1};next_search]; %将属于该类的种子点融合
        x_search = [];
        
        if (isempty(next_search)==1)
           for ii = 1:length(restofclass_indices)
               if (~isempty(jiedian{restofclass_indices(ii,1),1})==1)
                   next_search = restofclass_indices(ii,1);
                   numclass = numclass+1;
                   class_indices{numclass,1} = [class_indices{numclass,1};next_search];
                   restofclass_indices(ii,:) = [];    %删除已经被融合的点
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


% %% 画图
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
