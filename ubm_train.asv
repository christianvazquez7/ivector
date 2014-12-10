function ubm = ubm_train(list,featNum,nmix,iter,ds_factor,nWorkers,filename)

files = textread(list, '%s', 'delimiter', '\n');
fid = fopen('tlist','w');

for i=1:1:length(files)-1
    
    C = strsplit(char(files(i)),'\\');
    l = length(C);
    s = strcat('ubm_data\',char(C(l)));
    fprintf(fid,'%s\n',s);      
    [y,Fs] = wavread(char(files(i)));
    mfc = featureExtract(y,Fs);
    writehtk(s,mfc(1:end,1:featNum),0.25,6);

end
fclose(fid);

gmm_em('tlist',nmix,iter, ds_factor, nWorkers,'ubm');


