X=rand(4)
%dlmwrite('X.txt', X, 'precision', '%5f', 'delimiter', '\t')
dlmwrite('X.txt',X,'delim iter',',','newline','pc')