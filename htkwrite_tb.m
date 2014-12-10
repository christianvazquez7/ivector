clear;

[y,Fs] = wavread('ubm_training_files\t1');
[z,Fs2] = wavread('t2');
mfc = featureExtract(y,Fs);
writehtk('ubm_data\t1',mfc(1:13,1:3000),0.25,6);

mfc2 = featureExtract(z,Fs2);
writehtk('ubm_data\t2',mfc2(1:13,1:3000),0.25,6);
nmix = 64;
nWorkers = 8;           % Number of parfor workers, if available
final_niter = 10;
ds_factor = 1;


gmm_em('list.txt', nmix, final_niter, ds_factor, nWorkers, 'ubm');
