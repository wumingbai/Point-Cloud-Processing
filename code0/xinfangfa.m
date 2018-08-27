clc;clear;
format long g
Data=load('ping_1.txt');%读取点云数据
x=Data(:,1);
y=Data(:,2);
z=Data(:,3);
Point_number_size= size(x);
Point_number=Point_number_size(1);

len=0.04;
xn=ceil((max(x)-min(x))/len)+1;
yn=ceil((max(y)-min(y))/len)+1;
zn=ceil((max(z)-min(z))/len)+1;
%划分包围盒
%Box_suoyin=zeros(Point_number,3);
%for i=1:Point_number
    %Box_suoyin(i,1)=ceil((Coordx(i)-min(Coordx))/dx)+1;
    %Box_suoyin(i,2)=ceil((Coordy(i)-min(Coordy))/dy)+1;
    %Box_suoyin(i,3)=ceil((Coordz(i)-min(Coordz))/dz)+1;
%end
%求出每个点的索引号
%cifang=floor(log10(xn))+1;
%Sum_box=Box_suoyin(:,1)*10^(cifang*2)+Box_suoyin(:,2)*10^(cifang*1)+Box_suoyin(:,3);
%A=[Sum_box,(1:Point_number)'];
%B=sortrows(A);%默认依据第一列的数值按升序移动每一行，如果第一列的数值有相同的，依次往右比较。
%g=0;
%for i=1:Point_number
    %if B(i+1)-B(i)==0;
A={};
for i=1:xn
    for j=1:yn
        for k=1:zn
            A{i,j,k}=[];
        end
    end
end
%创建元包数组
for i=1:Point_number
    hang=ceil((x(i)-min(x))/len)+1;
    lie=ceil((y(i)-min(y))/len)+1;
    gao=ceil((z(i)-min(z))/len)+1;
    A{hang,lie,gao}=[A{hang,lie,gao};x(i),y(i),z(i)];
end
%将属于同一个包围盒内的点放在一个矩阵
Box_xuliehao=[];
for i=1:xn
    for j=1:yn
        for k=1:zn
            if(isempty(A{i,j,k})==0)      %实心方格
                Box_xuliehao=[Box_xuliehao;i,j,k];
            end
        end
    end    
end
%查找实心方格的序列号
K=input('领域为：')
Box_xuliehao_number=size(Box_xuliehao);










