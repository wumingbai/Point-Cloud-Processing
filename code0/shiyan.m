clc;clear;
format long g
Data=load('bunny.txt');%��ȡ��������
x=Data(:,1);
y=Data(:,2);
z=Data(:,3);
A=[x,y,z];
Point_number_size= size(x);
Point_number=Point_number_size(1);
A1=sortrows(A);
A2=[A1,(1:Point_number)'];
X_xuhao=A2(:,4);
%x����
A3=sortrows(A2,2);
A4=[A3,(1:Point_number)'];
A5=sortrows(A4,4);
Y_xuhao=A5(:,5);
%y����
A6=sortrows(A2,3);
A7=[A6,(1:Point_number)'];
A8=sortrows(A7,4);
Z_xuhao=A8(:,5);
Point_xuhao=[X_xuhao,Y_xuhao,Z_xuhao];
%������Ӧ��x,y��z����
Point=[A,Point_xuhao];
l=input('�������룺')
N0=[];%�����ռ�
N1=[];%���ڴ���ƽ������
N2=[];%���ڴ��淽��
N3=[];%���ڴ��������
N=[];
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
    N=[N;a(1)];  
end
zuixiao=min(N)
zuida=max(N)
pingjun=mean(N)
  
    
    
    