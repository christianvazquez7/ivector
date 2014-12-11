 [y,Fs] = wavread('ubm_training_files\frf01_f01_solo');
 mfc = featureExtract(y,Fs);
 invmfc = mfc';
 [y,Fs] = wavread('ubm_training_files\frf01_f02_solo');
 mfc2 = featureExtract(y,Fs);
 invmfc2 = mfc2';
 writehtk('a1',invmfc,0.25,6);
 writehtk('a2',invmfc2,0.25,6);
 
 gmm_em('tlist2',32,4, 1, 1,'ubm');


