tic
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
N0=[];%搜索空间
N1=[];%用于储存平均距离
N2=[];%用于储存方差
N3=[];%用于储存孤立点
g=0;
for i= 1:Point_number
    if Point(i,4)-l<=0
        N0=Point(1:(Point(i,4)+l),1:6);
    elseif Point(i,4)+l<Point_number
        N0=Point((Point(i,4)-l):(Point(i,4)+l),1:6);
    else
        N0=Point((Point(i,4)-l):Point_number,1:6);
    end
    [row,col]=find(N0(:,4)>=Point(i,4)-l&N0(:,4)<=Point(i,4)+l&N0(:,5)>=Point(i,5)-l&N0(:,5)<=Point(i,5)+l&N0(:,6)>=Point(i,6)-l&N0(:,6)<=Point(i,6)+l);
    a=size(row);
    linjin_number=a(1);
    linjin_piont=Point(row',1:3);
    N0=[];
    %平面拟合参数函数：输入参数为点云数据坐标矩阵，输出为该平面的四个系数：a b c d :   a*x+b*x+c*y=d
    %try
    if linjin_number>3
        [V,D]=eig(cov(Point(row',1:3)));%  cov：求协方差阵，eig:返回矩阵特征值D,和特征向量V
        [minx  inde]=min(diag(D));
        a=V(1,inde);
        b=V(2,inde);
        c=V(3,inde);
        d=V(1,inde)*mean(linjin_piont(:,1))+V(2,inde)*...
        mean(linjin_piont(:,2))+V(3,inde)*mean(linjin_piont(:,3));
    %catch
        %continue
    %end
        D=abs(a.*linjin_piont(:,1)+b.*linjin_piont(:,2)+c.*linjin_piont(:,3)-d)./(a^2+b^2+c^2)^(0.5);
        D_pingjun=mean(D(:));
        Fangcha=((D-D_pingjun)'*(D-D_pingjun)/(linjin_number-1))^(0.5);
        N1=[N1;D_pingjun,i];
        N2=[N2;Fangcha];
    else
        g=g+1;
        N3=[N3;A(i,1:3)];
    end
end
N4=[N2,N1];
N5=sortrows(N4);
N6=N5(ceil(0.84*length(N5)):end,3);
%N6=N5(1:ceil(0.2*(Point_number-g)),:);
N7=N5(1:ceil(0.84*length(N5)),3);
%New_data=[A(N6',:);A((suijihanshu(N7,7))',:)];
gg=0;
M1=[];
%jiange=ceil(length(N7)/(0.1*length(N5)));
jiange=5;
for sta=1:jiange :length(N7)
    gg=gg+1;
M1=[M1;N7(sta,:)];
end
New_data=[A(N6',:);A(M1',:)];
New_data_number=length(New_data)
plot3(New_data(:,1),New_data(:,2),New_data(:,3),'.','markersize',3)
%plot3(N3(:,1),N3(:,2),N3(:,3),'.')
axis equal
toc
dlmwrite('New_data.txt',New_data,'delimiter',',','newline','pc')


%floor(length(N7)/(0.1*length(N5)))