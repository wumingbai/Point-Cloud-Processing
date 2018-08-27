function [aq,bq,cq,dq,eq,fq] = zh_qumiannihe( Data )
%����ת�������������Ϻ�������������Ϻ���������Ϊ ����֯������������x,y,z;���Ϊ��ϵĿռ��������6������
%  aq,bq,cq,dq,eq,fq������Ϊ��z=aq.*x.^2+bq.*x.*y+cq.*y.^2+dq.*x+eq.*y+fq
%  ��һ��������ƽ���������ϣ�������ķ���Ϊ��z=aq.*x.^2+bq.*x.*y+cq.*y.^2+dq.*x+eq.*y+fq

%ע��˵��������������ע��Ϊ�ô����ע��

 format long g
 gg=1;%����ת����������Ըĵ��Ϊ����ԭ��
x1=Data(:,1);
y1=Data(:,2);
z1=Data(:,3);%����¼�룬�ֳ�x,y,z
siz1=length(x1);


%ƽ����ϣ���������ֵ������ƽ��Ĳ��ĸ�ϵ����a b c d :   a*x+b*x+c*y=d
%ͨ���������þ���Data��Э���������С����ֵ����Ӧ������������Ϊ��ϵ�ƽ���a,b,c����ʱ a^2+b^2+c^2=1;
[V,D]=eig(cov(Data));%  cov����Э������eig:���ؾ�������ֵD,����������V.
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

%������ϵ������ɢ��ͼ

 plot3(newdd(:,1),newdd(:,2),newdd(:,3),'r.')
 axis equal
 
hold on
[x,y]=meshgrid(-.05:0.002:.05);
z=a.*x.^2+b.*x.*y+c.*y.^2+d.*x+e.*y+f;
mesh(x,y,z)
axis equal

end