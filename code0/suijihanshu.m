function M1[] = suijihanshu(M0, jiange )

gg=0;
for sta=1:jiange :length(M0)
    gg=gg+1;
M1=[M1;M0(sta,:)];
end

end
