%本程序用于点云超体素的生成
%种子点基于八叉树生成，优点较为均匀

%======================================================
% clc;clear;
% zaodian_zhongzi = importdata('D:\Point\chushi2.txt');

% numzaodian_zhongzi = length(zaodian_zhongzi);
% zaodian_zhongzi_indices=[];   %用于储存序列号
% for i=1:numzaodian_zhongzi
%     ir = find(Seedpoints(:,1)==zaodian_zhongzi(i,1)&Seedpoints(:,2)==zaodian_zhongzi(i,2)&Seedpoints(:,3)==zaodian_zhongzi(i,3));  %返回种子点在原始数据的行索引
%     zaodian_zhongzi_indices = [zaodian_zhongzi_indices;ir];
% end

% ir = find(Seedpoints(:,3)==zaodian_zhongzi(1,3));
% Seedpoints = importdata('D:\Point\seedpoints_zawu.txt');%种子点
% ir = find(Seedpoints(:,3)==-0.76835);


%% 画图
% for i=1:N
%     if (~isempty(jiedian{i,1})==1)
%         [hang,lie]=size(jiedian{i,1});
%         a=Seedpoints(i,:);
%         B=jiedian{i,1};
%         for j=1:hang
%             plot3([a(1,1),B(j,2)],[a(1,2),B(j,3)],[a(1,3),B(j,4)]);
% %             axis equal
%             hold on
%         end
%     end    
% end
% axis equal
% axis off







