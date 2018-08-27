%说明：
%纵坐标为y轴，横坐标为x轴

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
% m=load('E:\文献\三维激光\方向\alpha\data\477.txt');
x=m(:,1);
y=m(:,2);
%plot(x,y,'.');
%hold on;
number=size(m);
xmin=min(x);
xmax=max(x);
ymin=min(y);
ymax=max(y);
%设置最小方格的边长
nn=size(m);
n=nn(1,1);
p=sqrt((xmax-xmin)*(ymax-ymin)/number(1,1));
len=p*1.5;
%floor向下取整
%ceil向上取整
%将数据的边界向外进行扩展一行(列)的方格，是为了保障在循环时，周围八个方格是存在的
newxmin=(floor(xmin/len)-6)*len;%扩展5个方格
newymin=(floor(ymin/len)-6)*len;%扩展5个方格
newxmax=(ceil(xmax/len)+6)*len;%扩展5个方格
newymax=(ceil(ymax/len)+6)*len;%扩展5个方格
hang=fix((newymax-newymin)/len)+1;
lie=fix((newxmax-newxmin)/len)+1;

%创建元胞数组，初始化全部为[]
%A=[x,y]
A={};
for i=1:hang
    for j=1:lie
        A{i,j}=[];
    end
end

%N1用来存放每个点的行、列数以及坐标
%N1=[x,y,hang,lie]
N1=[];
for i=1:n
    k=fix((y(i)-newymin)/len)+1;%行号
    j=fix((x(i)-newxmin)/len)+1;%列号
    A{k,j}=[A{k,j};x(i),y(i)];%将属于同一个方格内的点放在一个矩阵
    %N1=[N1;x(i),y(i),k,j];
end

%N2用来存放包含点的方格行列号
%N2=[i,j]
N2=[];
%I=[];
for i=1:hang
    for j=1:lie
        if(isempty(A{i,j})==0)      %实心方格
            N2=[N2;i,j];
            %I(i,j)=1;
        %else                %空心方格
            %N2=N2;
            %I(i,j)=0;
        end
    end
end
%imshow(I);

%根据方格的点，结合其周围25(9)个方格内的点进行判断
%N用来存储最后点的个数
%N4用来存储临时25(9)个方格内的点
N4=[];
N=[];
%N2用来存放序列号
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
    %(i,j)所在矩阵内的点
    
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
   %存放形式N4=[x,y]
% N4=[a9;a1;a2;a3;a4;a5;a6;a7;a8];
 N4=[a9;a1;a2;a3;a4;a5;a6;a7;a8;a10;a11;a12;a13;a14;a15;a16;a17;a18;a19;a20;a21;a22;a23;a24;a25];
  nn2=size(N4);
  n2=nn2(1,1);
  for kk=1:n1   %只需对空格的点进行判断就可以了   for2
      %判断边界方格内点是否为边界点，其坐标为x、y
      x1=a9(kk,1);
      y1=a9(kk,2);
      n4=N4;
      %将判断点所在的那一行数据删掉，为空
      n4(kk,:)=[];
      %%%%%%%%%%%%%%%%%%%
      a=0.5;
      %获取小于2*a范围内的点
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
      for kkk=1:nn2%寻找一点用于圆心  for3
          n44=NN;
          x2=n44(kkk,1);
          y2=n44(kkk,2);
          s2=(x1-x2)*(x1-x2)+(y1-y2)*(y1-y2);
           H=sqrt(a*a/s2-0.25);
           x3=0.5*(x1+x2)+H*(y2-y1);
           y3=0.5*(y1+y2)+H*(x1-x2);
           x31=0.5*(x1+x2)-H*(y2-y1);
           y31=0.5*(y1+y2)-H*(x1-x2);
           %将构造圆心的点所在行删掉
           n44(kkk,:)=[];
           count=0;
           count1=0;
           for kkkk=1:nn2-1;%用于判断除去判断点和构造圆心的点之外的n-2个点 %for4
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
             break;%跳出for3循环
         end
         
      end%for3
	  
	  
  end%for2
end%for1
t1=toc
X=N(:,1);
Y=N(:,2);
plot(X,Y,'*')
          
      
      
      
      
      
      
      
      
      
      
      
      
      %{
      for kkk=1:n2-1        %寻找一点用于求圆心 for3
          n44=n4;
          x2=n44(kkk,1);
          y2=n44(kkk,2);
          s2=(x1-x2)*(x1-x2)+(y1-y2)*(y1-y2);
          
          
          

          
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          a=0.001;%半径
          H=sqrt(a*a/s2-0.25);
          x3=0.5*(x1+x2)+H*(y2-y1);
          y3=0.5*(y1+y2)+H*(x1-x2);
          x31=0.5*(x1+x2)-H*(y2-y1);
          y31=0.5*(y1+y2)-H*(x1-x2);
          %将构造圆心的点所在的行删掉
          n44(kkk,:)=[];
          count=0;
          count1=0;
          for kkkk=1:n2-2       %用于判断除去判断点和构造圆心的点之外的n-2个点 %for4
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
             break;%跳出for3循环
         end
         
      end%for3
  end%for2
end%for1
t1=toc
X=N(:,1);
Y=N(:,2);
plot(X,Y,'*')
%}

