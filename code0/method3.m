%˵����
%������Ϊy�ᣬ������Ϊx��

clc;
clear;
tic;
m=[];
x=1:0.2:10;
y=1:0.2:10;
for i=1:length(x)
    for j=1:length(y)
        points=[x(i),y(j)];
        m=[m;points];
    end
end
% m=load('E:\����\��ά����\����\alpha\data\477.txt');
x=m(:,1);
y=m(:,2);
%plot(x,y,'.');
%hold on;
number=size(m);
xmin=min(x);
xmax=max(x);
ymin=min(y);
ymax=max(y);
%������С����ı߳�
nn=size(m);
n=nn(1,1);
p=sqrt((xmax-xmin)*(ymax-ymin)/number(1,1));
len=p*1.5;
%floor����ȡ��
%ceil����ȡ��
%�����ݵı߽����������չһ��(��)�ķ�����Ϊ�˱�����ѭ��ʱ����Χ�˸������Ǵ��ڵ�
newxmin=(floor(xmin/len)-6)*len;%��չ5������
newymin=(floor(ymin/len)-6)*len;%��չ5������
newxmax=(ceil(xmax/len)+6)*len;%��չ5������
newymax=(ceil(ymax/len)+6)*len;%��չ5������
hang=fix((newymax-newymin)/len)+1;
lie=fix((newxmax-newxmin)/len)+1;

%����Ԫ�����飬��ʼ��ȫ��Ϊ[]
%A=[x,y]
A={};
for i=1:hang
    for j=1:lie
        A{i,j}=[];
    end
end

%N1�������ÿ������С������Լ�����
%N1=[x,y,hang,lie]
N1=[];
for i=1:n
    k=fix((y(i)-newymin)/len)+1;%�к�
    j=fix((x(i)-newxmin)/len)+1;%�к�
    A{k,j}=[A{k,j};x(i),y(i)];%������ͬһ�������ڵĵ����һ������
    %N1=[N1;x(i),y(i),k,j];
end

%N2������Ű�����ķ������к�
%N2=[i,j]
N2=[];
%I=[];
for i=1:hang
    for j=1:lie
        if(isempty(A{i,j})==0)      %ʵ�ķ���
            N2=[N2;i,j];
            %I(i,j)=1;
        %else                %���ķ���
            %N2=N2;
            %I(i,j)=0;
        end
    end
end
%imshow(I);

%���ݷ���ĵ㣬�������Χ25(9)�������ڵĵ�����ж�
%N�����洢����ĸ���
%N4�����洢��ʱ25(9)�������ڵĵ�
N4=[];
N=[];
%N2����������к�
%N2=[i,j]
mm=size(N2);
mm1=mm(1,1);



for k=1:mm1     %for1
    i=N2(k,1);
    j=N2(k,2);
    a1=A{i+1,j-1};
    a2=A{i+1,j};
    a3=A{i+1,j+1};
    a4=A{i,j-1};
    a5=A{i,j+1};
    a6=A{i-1,j-1};
    a7=A{i-1,j};
    a8=A{i-1,j+1};
    %(i,j)���ھ����ڵĵ�
    
   a9=A{i,j};
   
   a10=A{i+2,j-2};
   a11=A{i+2,j-1};
   a12=A{i+2,j};
   a13=A{i+2,j+1};
   a14=A{i+2,j+2};
   a15=A{i+1,j-2};
   a16=A{i+1,j+2};
   a17=A{i,j-2};
   a18=A{i,j+2};
   a19=A{i-1,j-2};
   a20=A{i-1,j+2};
   a21=A{i-2,j-2};
   a22=A{i-2,j-1};
   a23=A{i-2,j};
   a24=A{i-2,j+1};
   a25=A{i-2,j+2};
   
   nn1=size(a9);
   n1=nn1(1,1);
   %�����ʽN4=[x,y]
% N4=[a9;a1;a2;a3;a4;a5;a6;a7;a8];
 N4=[a9;a1;a2;a3;a4;a5;a6;a7;a8;a10;a11;a12;a13;a14;a15;a16;a17;a18;a19;a20;a21;a22;a23;a24;a25];
  nn2=size(N4);
  n2=nn2(1,1);
  for kk=1:n1   %ֻ��Կո�ĵ�����жϾͿ�����   for2
      %�жϱ߽緽���ڵ��Ƿ�Ϊ�߽�㣬������Ϊx��y
      x1=a9(kk,1);
      y1=a9(kk,2);
      n4=N4;
      %���жϵ����ڵ���һ������ɾ����Ϊ��
      n4(kk,:)=[];
      %%%%%%%%%%%%%%%%%%%
      a=0.5;
      %��ȡС��2*a��Χ�ڵĵ�
      NN=[];
      for i=1:n2-1
          xxx=n4(i,1);
          yyy=n4(i,2);
          d=sqrt((xxx-x1)*(xxx-x1)+(yyy-y1)*(yyy-y1));
          if(d<2*a)
              NN=[NN;xxx,yyy];
          end
      end
      nnn2=size(NN);
      nn2=nnn2(1,1);
      for kkk=1:nn2%Ѱ��һ������Բ��  for3
          n44=NN;
          x2=n44(kkk,1);
          y2=n44(kkk,2);
          s2=(x1-x2)*(x1-x2)+(y1-y2)*(y1-y2);
           H=sqrt(a*a/s2-0.25);
           x3=0.5*(x1+x2)+H*(y2-y1);
           y3=0.5*(y1+y2)+H*(x1-x2);
           x31=0.5*(x1+x2)-H*(y2-y1);
           y31=0.5*(y1+y2)-H*(x1-x2);
           %������Բ�ĵĵ�������ɾ��
           n44(kkk,:)=[];
           count=0;
           count1=0;
           for kkkk=1:nn2-1;%�����жϳ�ȥ�жϵ�͹���Բ�ĵĵ�֮���n-2���� %for4
               x4=n44(kkkk,1);
               y4=n44(kkkk,2);
               d1=sqrt((x4-x3)*(x4-x3)+(y4-y3)*(y4-y3));
               d2=sqrt((x4-x31)*(x4-x31)+(y4-y31)*(y4-y31));
               if(d1>a)
                 count=count+1;
             elseif(d2>a)
                 count1=count1+1;
             else
                 count=count;
                 count1=count1;
             end
         end %for4
         
         if(count==nn2-1 || count1==n2-1)
             N=[N;x1,y1];
             break;%����for3ѭ��
         end
         
      end%for3
	  
	  
  end%for2
end%for1
t1=toc
X=N(:,1);
Y=N(:,2);
plot(X,Y,'*')
          
      
      
      
      
      
      
      
      
      
      
      
      
      %{
      for kkk=1:n2-1        %Ѱ��һ��������Բ�� for3
          n44=n4;
          x2=n44(kkk,1);
          y2=n44(kkk,2);
          s2=(x1-x2)*(x1-x2)+(y1-y2)*(y1-y2);
          
          
          

          
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          a=0.001;%�뾶
          H=sqrt(a*a/s2-0.25);
          x3=0.5*(x1+x2)+H*(y2-y1);
          y3=0.5*(y1+y2)+H*(x1-x2);
          x31=0.5*(x1+x2)-H*(y2-y1);
          y31=0.5*(y1+y2)-H*(x1-x2);
          %������Բ�ĵĵ����ڵ���ɾ��
          n44(kkk,:)=[];
          count=0;
          count1=0;
          for kkkk=1:n2-2       %�����жϳ�ȥ�жϵ�͹���Բ�ĵĵ�֮���n-2���� %for4
              x4=n44(kkkk,1);
             y4=n44(kkkk,2);
             d1=sqrt((x4-x3)*(x4-x3)+(y4-y3)*(y4-y3));
             d2=sqrt((x4-x31)*(x4-x31)+(y4-y31)*(y4-y31));
             
             
             
             if(d1>a)
                 count=count+1;
             elseif(d2>a)
                 count1=count1+1;
             else
                 count=count;
                 count1=count1;
             end
         end %for4
         
         
         if(count==n2-2 || count1==n2-2)
             N=[N;x1,y1];
             break;%����for3ѭ��
         end
         
      end%for3
  end%for2
end%for1
t1=toc
X=N(:,1);
Y=N(:,2);
plot(X,Y,'*')
%}

