clc;clear;
format long g
Data=load('ping_1.txt');%读取点云数据
x=Data(:,1);
y=Data(:,2);
z=Data(:,3);
A=[x,y,z];
Point_number_size= size(x);
Point_number=Point_number_size(1);
A1=sortrows(A);
A2=[A1,(1:Point_number)'];
X_xuhao=A2(:,4);
%x排序
A3=sortrows(A2,2);
A4=[A3,(1:Point_number)'];
A5=sortrows(A4,4);
Y_xuhao=A5(:,5);
%y排序
A6=sortrows(A2,3);
A7=[A6,(1:Point_number)'];
A8=sortrows(A7,4);
Z_xuhao=A8(:,5);
Point_xuhao=[X_xuhao,Y_xuhao,Z_xuhao];
%求出点对应的x,y，z排序
Point=[A,Point_xuhao];
l=input('搜索距离：')
pingjunqulvH=zeros(Point_number,2);
for i= 1:Point_number
    [row,col]=find(Point(:,4)>=Point(i,4)-l&Point(:,4)<=Point(i,4)+l&Point(:,5)>=Point(i,5)-l&Point(:,5)<=Point(i,5)+l&Point(:,6)>=Point(i,6)-l&Point(:,6)<=Point(i,6)+l);
    a=size(row);
    linjin_number=a(1);
    linjin_piont=Point(row',1:3);
    %[a,b,c,d,e,f]= zh_qumiannihe(Point(row',1:3));
    gg=1;
    [V,D]=eig(cov(Point(row',1:3)));%  cov：求协方差阵，eig:返回矩阵特征值D,和特征向量V
    [minx  inde]=min(diag(D));
     a=V(1,inde);
     b=V(2,inde);
     c=V(3,inde);
     %通过函数极值的拉格朗日乘数法求得，可参考文献：一种稳健的点云数据平面拟合方法2008 官云兰
    % d=V(1,inde)*mean(x1)+V(2,inde)*mean(y1)+V(3,inde)*mean(z1);

% %通过计算得到的平面参数可得到拟合的平面的法向量，通过坐标转换方法，将矩阵进行两次平移
%旋转矩阵的元素计算
     cosA=b/sqrt(a^2+b^2);
     sinA=a/sqrt(a^2+b^2);
     cosB=c/sqrt(a^2+b^2+c^2);
     sinB=sqrt(a^2+b^2)/sqrt(a^2+b^2+c^2); 
 %旋转矩阵Rz,Rx
Rz=[cosA sinA 0 0;-sinA cosA 0 0;0 0 1 0;0 0 0 1];
Rx=[1 0 0 0;0 cosB sinB 0;0 -sinB cosB 0;0 0 0 1];
%坐标转换计算
x1=linjin_piont(:,1);
y1=linjin_piont(:,2);
z1=linjin_piont(:,3);
siz1=length(x1);
%坐标转换计算
newdd=[x1,y1,z1,ones(siz1,1)]*...
    [1 0 0 0;0 1 0 0;0 0 1 0;-x1(gg) -y1(gg) -z1(gg) 1]*Rz*Rx;
%组成平差系数阵
AA(1:siz1-1,1)=newdd(2:siz1,1).^2;
AA(1:siz1-1,2)=newdd(2:siz1,1).*newdd(2:siz1,2);
AA(1:siz1-1,3)=newdd(2:siz1,2).^2;
AA(1:siz1-1,4)=newdd(2:siz1,1);
AA(1:siz1-1,5)=newdd(2:siz1,2);
AA(1:siz1-1,6)=ones(siz1-1,1);
%常数阵
l=newdd(2:siz1,3);
% 平差求解
V=(AA'*AA)\AA'*l;
aq=V(1); bq=V(2); cq=V(3);dq=V(4); eq=V(5);
fq=V(6);
%求平均曲率
%pingjunqulvH(i,1:2)=[(aq+cq+aq*eq^2+cq*dq^2-bq*dq*eq)/(dq^2+eq^2+1)^(3/2),i]
end
%qulvfa_pingjun=sortrows(abs(pingjunqulvH),1)








