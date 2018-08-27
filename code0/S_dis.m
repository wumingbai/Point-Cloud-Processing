function s_dis= S_dis(a, b, c, d ,e, f)
%求空间两点距离
%   两点六个坐标值作为输入参数，位置对应x1,y1,z1,x2,y2,z2 
s_dis=sqrt((a-d).^2+(b-e).^2+(c-f).^2);
end

