function [aq,bq,cq,dq,eq,fq] = zh_qumiannihe( Data )
%坐标转换后进行曲面拟合函数，该曲面拟合函数的输入为 非组织点云坐标数据x,y,z;输出为拟合的空间抛物面的6个参数
%  aq,bq,cq,dq,eq,fq，方程为：z=aq.*x.^2+bq.*x.*y+cq.*y.^2+dq.*x+eq.*y+fq
%  对一组无序点云进行曲面拟合，该曲面的方程为：z=aq.*x.^2+bq.*x.*y+cq.*y.^2+dq.*x+eq.*y+fq

%注释说明：与代码最近的注释为该代码的注释

 format long g
 gg=1;%控制转换后的数据以改点号为坐标原点
x1=Data(:,1);
y1=Data(:,2);
z1=Data(:,3);%数据录入，分成x,y,z
siz1=length(x1);


%平面拟合，利用特征值法，该平面的参四个系数：a b c d :   a*x+b*x+c*y=d
%通过分析，该矩阵Data的协方差阵的最小特征值所对应的特征向量即为拟合的平面的a,b,c，此时 a^2+b^2+c^2=1;
[V,D]=eig(cov(Data));%  cov：求协方差阵，eig:返回矩阵特征值D,和特征向量V.
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

%绘制拟合的曲面和散点图

 plot3(newdd(:,1),newdd(:,2),newdd(:,3),'r.')
 axis equal
 
hold on
[x,y]=meshgrid(-.05:0.002:.05);
z=a.*x.^2+b.*x.*y+c.*y.^2+d.*x+e.*y+f;
mesh(x,y,z)
axis equal

end