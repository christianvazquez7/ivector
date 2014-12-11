function [listoflabels] = write_labels( vectorList )

fid = fopen(vectorList, 'rt');
C = textscan(fid, '%s');
C = C{1};
fclose(fid);

fid = fopen('labellist','w');


for file = 1 : length(C),
    n = char(C(file));
    name = n(9:13);
    fprintf(fid,'%s\n',name); 
end

fclose(fid);
fid = fopen('labellist', 'rt');
C = textscan(fid, '%s');
listoflabels = C{1};

end

