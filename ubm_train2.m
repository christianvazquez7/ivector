function ubm = ubm_train2(list,featNum,nmix,iter,ds_factor,nWorkers,filename)

files = textread(list, '%s', 'delimiter', '\n');
fid = fopen('tlist','w');


for i=1:1:length(files)-1
    
    C = strsplit(char(files(i)),'\\');
    l = length(C);
    s = strcat('ubm_data\',char(C(l)));
    v = strcat('ubm_training_files\',char(files(i)));

    [y,Fs] = wavread(v);
    mfc = featureExtract(y,Fs);
    mfc = mfc';
    cs = length(mfc);
    y = 1;
    
  %  while cs >= featNum 
   %     name = strcat(s,num2str(y));
    %    a = (y-1)*(featNum)+y-1;
     %   b = y*featNum + y - 2;
      %  if (y == 1 )
       %     a = 1;
        %    b = 200;
  %      end
   %     if b > length(mfc)
    %        break;
     %   end
        writehtk(s,mfc,0.25,6);
        fprintf(fid,'%s\n',s); 
  %      cs = cs - featNum;
   %     y = y+1;
        fprintf('Finished file :%d: %s\n',i,s);
end
   
fclose(fid);
gmm_em('tlist',nmix,iter, ds_factor, nWorkers,'ubm');


