clc, clear;  
%% ������ͼ  
a = zeros(7);  
a(1,2)=3; a(1,3)=4; a(1,4)=7;  
a(2,3)=3; a(2,4)=2; a(2,5)=4;  
a(3,5)=5; a(3,6)=7;  
a(4,5)=2; a(4,7)=6;  
a(5,6)=1; a(5,7)=4;  
a(6,7)=2;  
  
%% Kruskal�㷨  
[i,j,b]=find(a);  
data=[i';j';b']; k=max(size(data));           %data����k�У�kΪ������ͨ�ߵ�����  
index=data(1:2,:);                            %ȡ�����бߵ������յ�  
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
    index(index==v2)=v1;        %�˴����㷨���裬�����ϴ����ߵĶ���ĳ�ͬһ�����֣�������ֻ���  
    data(:,flag)=[];             %�޳��ñ�  
    index(:,flag)=[];  
end  
Wt=sum(result(3,:));  
disp(['��̼�������ܳ��ȣ�', int2str(Wt)]);  
%% ����С��  
axis equal;            %����С������     
hold on  
[x,y]=cylinder(1,n);   %�������㣬���Ȼ�Բ  
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
for i=1:k-n+1 %�����������ڵı�  
    plot(x(1,data(1:2,i)),y(1,data(1:2,i)),'b');  
end  
for i=1:n-1  %�������ڵı�  
    plot(x(1,result(1:2,i)),y(1,result(1:2,i)),'r');  
end  
text(-0.35,-1.2,['��С��������ȨΪ','',num2str(Wt)]);  
title('��ɫ����Ϊ��С������');  
axis off;  
hold off