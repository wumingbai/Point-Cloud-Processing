clc;clear;
format long g
Data=load('ping_1.txt');%��ȡ��������
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
pingjunqulvH=zeros(Point_number,2);
for i= 1:Point_number
    [row,col]=find(Point(:,4)>=Point(i,4)-l&Point(:,4)<=Point(i,4)+l&Point(:,5)>=Point(i,5)-l&Point(:,5)<=Point(i,5)+l&Point(:,6)>=Point(i,6)-l&Point(:,6)<=Point(i,6)+l);
    a=size(row);
    linjin_number=a(1);
    linjin_piont=Point(row',1:3);
    %[a,b,c,d,e,f]= zh_qumiannihe(Point(row',1:3));
    gg=1;
    [V,D]=eig(cov(Point(row',1:3)));%  cov����Э������eig:���ؾ�������ֵD,����������V
    [minx  inde]=min(diag(D));
     a=V(1,inde);
     b=V(2,inde);
     c=V(3,inde);
     %ͨ��������ֵ���������ճ�������ã��ɲο����ף�һ���Ƚ��ĵ�������ƽ����Ϸ���2008 ������
    % d=V(1,inde)*mean(x1)+V(2,inde)*mean(y1)+V(3,inde)*mean(z1);

% %ͨ������õ���ƽ������ɵõ���ϵ�ƽ��ķ�������ͨ������ת���������������������ƽ��
%��ת�����Ԫ�ؼ���
     cosA=b/sqrt(a^2+b^2);
     sinA=a/sqrt(a^2+b^2);
     cosB=c/sqrt(a^2+b^2+c^2);
     sinB=sqrt(a^2+b^2)/sqrt(a^2+b^2+c^2); 
 %��ת����Rz,Rx
Rz=[cosA sinA 0 0;-sinA cosA 0 0;0 0 1 0;0 0 0 1];
Rx=[1 0 0 0;0 cosB sinB 0;0 -sinB cosB 0;0 0 0 1];
%����ת������
x1=linjin_piont(:,1);
y1=linjin_piont(:,2);
z1=linjin_piont(:,3);
siz1=length(x1);
%����ת������
newdd=[x1,y1,z1,ones(siz1,1)]*...
    [1 0 0 0;0 1 0 0;0 0 1 0;-x1(gg) -y1(gg) -z1(gg) 1]*Rz*Rx;
%���ƽ��ϵ����
AA(1:siz1-1,1)=newdd(2:siz1,1).^2;
AA(1:siz1-1,2)=newdd(2:siz1,1).*newdd(2:siz1,2);
AA(1:siz1-1,3)=newdd(2:siz1,2).^2;
AA(1:siz1-1,4)=newdd(2:siz1,1);
AA(1:siz1-1,5)=newdd(2:siz1,2);
AA(1:siz1-1,6)=ones(siz1-1,1);
%������
l=newdd(2:siz1,3);
% ƽ�����
V=(AA'*AA)\AA'*l;
aq=V(1); bq=V(2); cq=V(3);dq=V(4); eq=V(5);
fq=V(6);
%��ƽ������
%pingjunqulvH(i,1:2)=[(aq+cq+aq*eq^2+cq*dq^2-bq*dq*eq)/(dq^2+eq^2+1)^(3/2),i]
end
%qulvfa_pingjun=sortrows(abs(pingjunqulvH),1)








