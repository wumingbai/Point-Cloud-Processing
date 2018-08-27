function klinyu= K_treejisuan(Data,K )
%输入参数为 点云坐标数据，和K值
%   求一个点云的每个点的K近邻

format long g
Coordx=Data(:,1)-min(Data(:,1));
Coordy=Data(:,2)-min(Data(:,2));
Coordz=Data(:,3)-min(Data(:,3));

siz=size(Coordx);
dx=0.02;
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
%  K=input('领域为：')
% K=200;
for ii=1:siz(1)
for i=hhe(ii,1)-1:hhe(ii,1)+1
    for j=hhe(ii,2)-1:hhe(ii,2)+1
        for k=hhe(ii,3)-1:hhe(ii,3)+1
            try
                if ~isempty(x(i).y(j).z(k).data)
                    gg=gg+1;
                    d(ii).distance(gg).distan=[S_dis(Data(x(i).y(j).z(k).data,1),...
                        Data(x(i).y(j).z(k).data,2),Data(x(i).y(j).z(k).data,3),...
                        Data(ii,1),Data(ii,2),Data(ii,3)),x(i).y(j).z(k).data'];
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
klinyu(ii).data(1:K,1:5)=[paixulingyudata(1:K,1),...
    paixulingyudata(1:K,2),Coordx(paixulingyudata(1:K,2))...
    Coordy(paixulingyudata(1:K,2)),Coordz(paixulingyudata(1:K,2))];
gg=0;
end
end

