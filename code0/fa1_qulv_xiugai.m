tic
clc;clear;
format long
Data=load('ping_1.txt');%��ȡ��������
%  Data=load('F:\test.txt');%��ȡ��������
Coordx=Data(:,1)-min(Data(:,1));
Coordy=Data(:,2)-min(Data(:,2));
Coordz=Data(:,3)-min(Data(:,3));

siz=length(Data);
K=input('����������')
 klinyu= K_treejisuan(Data,K);
 gaosiqulvK=zeros(siz,2);
  pingjunqulvH=zeros(siz,2);
  
  for ii=1:siz
      [a,b,c,d,e,f]= zh_qumiannihe(klinyu(ii).data(:,3:5));
      %���˹����
      %gaosiqulvK(ii,1:2)=[(4*a*c-b^2)/(d^2+e^2+1)^2,ii];
      %��ƽ������
      pingjunqulvH(ii,1:2)=[(a+c+a*e^2+c*d^2-b*d*e)/(d^2+e^2+1)^(3/2),ii];
  end
 
 %���ʴ�С����
% qulvfa_gao=sortrows(abs(gaosiqulvK),1);%��˹����
qulvfa_pingjun=sortrows(abs(pingjunqulvH));%ƽ������

% zcha=qulvfa_gao;
zcha=qulvfa_pingjun;



%%%%%%%%%%%%%%%%%%%%%%%**********��ͼ��ʾ

%��
figure(4)
bilii=0.67;
%plot3(Coordx(zcha(ceil(siz*bilii):siz,2)),...
    %Coordy(zcha(ceil(siz*bilii):siz,2)),...
    %Coordz(zcha(ceil(siz*bilii):siz,2)),'b.')
New_data=[Coordx(zcha(ceil(siz*bilii):siz,2)),...
    Coordy(zcha(ceil(siz*bilii):siz,2)),...
    Coordz(zcha(ceil(siz*bilii):siz,2))];
plot3(New_data(:,1),New_data(:,2),New_data(:,3),'.','markersize',3)
axis equal
toc
dlmwrite('New_data.txt',New_data,'delimiter',',','newline','pc')
% %ǰ
% bili=0.3;
% plot3(Coordx(zcha(1:ceil(siz1*bili),2)),...
%     Coordy(zcha(1:ceil(siz1*bili),2)),...
%     Coordz(zcha(1:ceil(siz1*bili),2)),'b.')
% axis equal

% %��������
% hold on
% plot3(Coordx(1:30:siz(1)),Coordy(1:30:siz(1)),Coordz(1:30:siz(1)),'b.')
% axis equal

% %ȫ��
% plot3(Coordx(1:siz(1)),Coordy(1:siz(1)),Coordz(1:siz(1)),'b.')
% axis equal

disp('����ѹ����Ϊ��')
(1-bilii)*siz/length(Coordx)








