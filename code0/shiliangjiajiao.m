clc;clear;
format long 
 Data=load('ping_1.txt');%读取点云数据
 %Data=load('F:\test.txt');%读取点云数据
Coordx=Data(:,1)-min(Data(:,1));
Coordy=Data(:,2)-min(Data(:,2));
Coordz=Data(:,3)-min(Data(:,3));

siz=size(Coordx);
dx=0.09;
xn=ceil((max(Coordx)-min(Coordx))/dx);
dy=(max(Coordy)-min(Coordy))/xn;
dz=(max(Coordz)-min(Coordz))/xn;
yn=xn;
zn=xn;
hhe=zeros(siz(1),3);
for i=1:siz(1)
    hhe(i,1)=ceil((Coordx(i)-min(Coordx))/dx)+1;
    hhe(i,2)=ceil((Coordy(i)-min(Coordy))/dy)+1;
    hhe(i,3)=ceil((Coordz(i)-min(Coordz))/dz)+1;
end
mm=0;
cifang=floor(log10(xn))+1;
ka=hhe(:,1)*10^(cifang*2)+hhe(:,2)*10^(cifang*1)+hhe(:,3);
kaaa=[ka,(1:siz(1))'];
kaa=sortrows(kaaa,1);
g=0;
for i=1:siz(1)
    if kaa(i+1)-kaa(i)==0
        f=num2str(kaa(i,1));
        g=g+1;
        x(str2double(f(1:end-2*cifang))).y(str2double(f(end-...
            2*cifang+1:end-cifang))).z(str2double(f(end-cifang+1:end))).data(1,g)=kaa(i,2);
    else
        g=g+1;
        f=num2str(kaa(i,1));
        x(str2double(f(1:end-2*cifang))).y(str2double(f(end-...
            2*cifang+1:end-cifang))).z(str2double(f(end-cifang+1:end))).data(1,g)=kaa(i,2);
        g=0;
    end
    
end

 gg=0;
 K=input('领域为：')
for ii=1:siz(1)
for i=hhe(ii,1)-1:hhe(ii,1)+1
    for j=hhe(ii,2)-1:hhe(ii,2)+1
        for k=hhe(ii,3)-1:hhe(ii,3)+1
            try
                if ~isempty(x(i).y(j).z(k).data)
                    gg=gg+1;
                    coo=size(x(i).y(j).z(k).data');
                    countt(gg)=coo(1);
                    d(ii).distance(gg).distan=[S_dis(Data(x(i).y(j).z(k).data,1),...
                        Data(x(i).y(j).z(k).data,2),Data(x(i).y(j).z(k).data,3),...
                        Data(ii,1),Data(ii,2),Data(ii,3)),x(i).y(j).z(k).data'];
%                     ladata=[d(ii).distance(gg).distan;d(ii).distance(gg).distan]
                end
            catch
                continue
            end
        end
    end
end
lingyudata=[];
for i=1:gg
    lingyudata=[lingyudata;d(ii).distance(i).distan];
end
paixulingyudata=sortrows(lingyudata,1);
klinyu(ii).data(1:K,1:2)=[paixulingyudata(1:K,1),paixulingyudata(1:K,2)];
chang=max(Coordz(klinyu(ii).data(:,2)))-min(Coordz(klinyu(ii).data(:,2)));
kuan=max(Coordx(klinyu(ii).data(:,2)))-min(Coordx(klinyu(ii).data(:,2)));
gao=max(Coordy(klinyu(ii).data(:,2)))-min(Coordy(klinyu(ii).data(:,2)));



A(1:K,1)=Coordx(klinyu(ii).data(:,2));
A(1:K,2)=Coordy(klinyu(ii).data(:,2));
A(1:K,3)=Coordz(klinyu(ii).data(:,2));
[V,D]=eig(cov(A));
[minx inde]=min(diag(D));
xishu(ii).a(1)=V(1,inde);
xishu(ii).b(1)=V(2,inde);
xishu(ii).c(1)=V(3,inde);
xishu(ii).d(1)=V(1,inde)*mean(Coordx(klinyu(ii).data(:,2)))+V(2,inde)*...
    mean(Coordy(klinyu(ii).data(:,2)))+V(3,inde)*mean(Coordz(klinyu(ii).data(:,2)));
ii
gg=0;
end

baifenbi=0.1;
ii=1;
    jiaodu(ii).data(1:K,1:5)=[abs(fashijajiaojs(xishu(ii).a,xishu(ii).b,xishu(ii).c,...
        [xishu(klinyu(ii).data(:,2)).a]',[xishu(klinyu(ii).data(:,2)).b]',[xishu(klinyu(ii).data(:,2)).c]')),...
   klinyu(ii).data(:,2),Coordx(klinyu(ii).data(:,2)),Coordy(klinyu(ii).data(:,2)),...
        Coordz(klinyu(ii).data(:,2))];%夹角余弦值绝对值的结构体
    jiaodupaixu(ii).data=sortrows( jiaodu(ii).data,1);
    zuihoudian(1+ceil(baifenbi*K)*(ii-1):ceil(baifenbi*K)*ii,1:2)=[ jiaodupaixu(ii).data(1:ceil(K*baifenbi),2),ones(ceil(baifenbi*K),1)];
    
    zuihoudiansanchu(1+floor((1-baifenbi)*K)*(ii-1):floor((1-baifenbi)*K)*ii,1:2)=...
        [ jiaodupaixu(ii).data(1:floor(K*(1-baifenbi)),2),zeros(floor(K*(1-baifenbi)),1)];
    
    
for ii=1:siz(1)
%     while  ismember(ii,zuihoudiansanchu(:,1))==0
%     if  ismember(ii,zuihoudiansanchu(:,1))==1
%          continue
%     else
        
    jiaodu(ii).data(1:K,1:5)=[abs(fashijajiaojs(xishu(ii).a,xishu(ii).b,xishu(ii).c,...
        [xishu(klinyu(ii).data(:,2)).a]',[xishu(klinyu(ii).data(:,2)).b]',[xishu(klinyu(ii).data(:,2)).c]')),...
   klinyu(ii).data(:,2),Coordx(klinyu(ii).data(:,2)),Coordy(klinyu(ii).data(:,2)),...
        Coordz(klinyu(ii).data(:,2))];%夹角余弦值绝对值的结构体
    bioapzhuncha(ii,1:2)=[std( jiaodu(ii).data(:,1)),ii];
    
%     jiaodupaixu(ii).data=sortrows( jiaodu(ii).data,1);
%     zuihoudian(1+ceil(baifenbi*K)*(ii-1):ceil(baifenbi*K)*ii,1:2)=[ jiaodupaixu(ii).data(1:ceil(K*baifenbi),2),ones(ceil(baifenbi*K),1)];
%     
%     zuihoudiansanchu(1+floor((1-baifenbi)*K)*(ii-1):floor((1-baifenbi)*K)*ii,1:2)=...
%         [ jiaodupaixu(ii).data(1:floor(K*(1-baifenbi)),2),zeros(floor(K*(1-baifenbi)),1)];

%     end
    ii
%     plot3( Coordx(jiaodupaixu(ii).data(ceil(K*baifenbi):end,2)),Coordy(jiaodupaixu(ii).data(ceil(K*baifenbi):end,2)),...
%         Coordz(jiaodupaixu(ii).data(ceil(K*baifenbi):end,2)),'r.')
%     plot3( Coordx(jiaodupaixu(ii).data(1:ceil(K*baifenbi),2)),Coordy(jiaodupaixu(ii).data(1:ceil(K*baifenbi),2)),...
%         Coordz(jiaodupaixu(ii).data(1:ceil(K*baifenbi),2)),'r.')
%     axis equal 
%     hold on
%     pause(0.01)
end
% zuihoudian1=unique(zuihoudian(:,1));





%     plot3(Coordx(as),Coordy(as),Coordz(as),'r.')
%     axis equal 

    bzcpaixu=sortrows(bioapzhuncha,1);
    
%     
%      as=intersect(bzcpaixu(10000:end,2),K_julipaixu(10000:end,2));
     endd=22339;
     qian=19000;
     jg=1;
         plot3(Coordx(bzcpaixu(qian:jg:endd,2)),Coordy(bzcpaixu(qian:jg:endd,2)),Coordz(bzcpaixu(qian:jg:endd,2)),'r.')
    axis equal 
    
    disp('数据压缩比为：')
    (endd-qian)/length(Data)
% unique(zuihoudiansanchu)
% unique(zuihoudian(:,1))

 [aq,bq,cq,dq,eq,fq] = paowumian_nh(Data)





% 
% baifenbi=0.1;
% ii=1;
%     jiaodu(ii).data(1:K,1:5)=[abs(fashijajiaojs(xishu(ii).a,xishu(ii).b,xishu(ii).c,...
%         [xishu(klinyu(ii).data(:,2)).a]',[xishu(klinyu(ii).data(:,2)).b]',[xishu(klinyu(ii).data(:,2)).c]')),...
%    klinyu(ii).data(:,2),Coordx(klinyu(ii).data(:,2)),Coordy(klinyu(ii).data(:,2)),...
%         Coordz(klinyu(ii).data(:,2))];%夹角余弦值绝对值的结构体
%     jiaodupaixu(ii).data=sortrows( jiaodu(ii).data,1);
%     zuihoudian(1+ceil(baifenbi*K)*(ii-1):ceil(baifenbi*K)*ii,1:2)=...
%         [ jiaodupaixu(ii).data(1:ceil(K*baifenbi),2),ones(ceil(baifenbi*K),1)];
%     zuihoudiansanchu(1+floor((1-baifenbi)*K)*(ii-1):floor((1-baifenbi)*K)*ii,1:2)=...
%         [ jiaodupaixu(ii).data(1:floor(K*(1-baifenbi)),2),zeros(floor(K*(1-baifenbi)),1)];
%     
% for ii=1:siz(1)
%     jiaodu(ii).data(1:K,1:5)=[abs(fashijajiaojs(xishu(ii).a,xishu(ii).b,xishu(ii).c,...
%         [xishu(klinyu(ii).data(:,2)).a]',[xishu(klinyu(ii).data(:,2)).b]',[xishu(klinyu(ii).data(:,2)).c]')),...
%    klinyu(ii).data(:,2),Coordx(klinyu(ii).data(:,2)),Coordy(klinyu(ii).data(:,2)),...
%         Coordz(klinyu(ii).data(:,2))];%夹角余弦值绝对值的结构体
%     bioapzhuncha(ii,1:2)=[std( jiaodu(ii).data(:,1)),ii];
% end



















