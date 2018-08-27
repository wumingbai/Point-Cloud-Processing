clc;clear;
% ptCloud=pcread('D:\Point\ping.ply');
% A=importdata('D:\Point\ping.txt');
% % B=importdata('D:\Point\faxiangping.txt');
% % Fa_xiang=B(1:end,4:6);
% Fa_xiang=importdata('D:\Point\Fa_xiang_ping.txt');
% % dlmwrite('Fa_xiang_ping.txt',Fa_xiang,'delimiter',' ','newline','pc')  

Datan = importdata('D:\Point\zawu2.txt');%导入数据
A = Datan(:,1:3);
Fa_xiang =Datan(:,4:6);%异向法矢平滑后的法向量

u = Fa_xiang(:,1);
v = Fa_xiang(:,2);
w = Fa_xiang(:,3);
for k = 1 : length(A)
    u(k) = -u(k);
    v(k) = -v(k);
    w(k) = -w(k);
    Fa_xiang(k,:)=[u(k),v(k),w(k)];
end

dlmwrite('zawu.txt',A,'delimiter',' ','newline','pc') 
% dlmwrite('Fa_xiang_zawu.txt',Fa_xiang,'delimiter',' ','newline','pc') 
plot3(A(:,1),A(:,2),A(:,3),'.','markersize',3);
hold on
quiver3(A(1:end,1),A(1:end,2),A(1:end,3),Fa_xiang(1:end,1),Fa_xiang(1:end,2),Fa_xiang(1:end,3),3)
% quiver3(A(L(7,:),1),A(L(7,:),2),A(L(7,:),3),u(L(7,:)),v(L(7,:)),w(L(7,:)),2)
axis equal
hold off
axis off








