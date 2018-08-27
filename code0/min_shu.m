clc, clear;  
%% 做连接图  
a = zeros(7);  
a(1,2)=3; a(1,3)=4; a(1,4)=7;  
a(2,3)=3; a(2,4)=2; a(2,5)=4;  
a(3,5)=5; a(3,6)=7;  
a(4,5)=2; a(4,7)=6;  
a(5,6)=1; a(5,7)=4;  
a(6,7)=2;  
  
%% Kruskal算法  
[i,j,b]=find(a);  
data=[i';j';b']; k=max(size(data));           %data三行k列，k为所有联通边的数量  
index=data(1:2,:);                            %取出所有边的起点和终点  
n=max(size(a));  
result=[];  
while length(result)<n-1  
    temp=min(data(3,:));  
    flag=find(data(3,:)==temp);  
    flag=flag(1);  
    v1=data(1,flag);v2=data(2,flag);  
    if index(1,flag)~=index(2,flag)  
        result=[result,data(:,flag)];   
    end  
   index==v2;
   index
    index(index==v2)=v1;        %此处是算法精髓，把树上串联边的顶点改成同一个数字，避免出现环。  
    data(:,flag)=[];             %剔除该边  
    index(:,flag)=[];  
end  
Wt=sum(result(3,:));  
disp(['最短架设电线总长度：', int2str(Wt)]);  
%% 画最小树  
axis equal;            %画最小生成树     
hold on  
[x,y]=cylinder(1,n);   %画出顶点，均匀画圆  
xm=min(x(1,:));  
ym=min(y(1,:));  
xx=max(x(1,:));  
yy=max(y(1,:));  
axis([xm-abs(xm)*0.15,xx+abs(xx)*0.15,ym-abs(ym)*0.15,yy+abs(yy)*0.15]);  
plot(x(1,:),y(1,:),'ko');  
for i=1:n  
    temp=['v',int2str(i)];  
    text(x(1,i),y(1,i),temp);  
end  
for i=1:k-n+1 %画出不在树内的边  
    plot(x(1,data(1:2,i)),y(1,data(1:2,i)),'b');  
end  
for i=1:n-1  %画出树内的边  
    plot(x(1,result(1:2,i)),y(1,result(1:2,i)),'r');  
end  
text(-0.35,-1.2,['最小生成树的权为','',num2str(Wt)]);  
title('红色连线为最小生成树');  
axis off;  
hold off