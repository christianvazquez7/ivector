%Training UBM
dataList = 'ubm.lst';
nmix        = 256;
final_niter = 10;
ds_factor   = 1;
ubm = gmm_em(dataList, nmix, final_niter, ds_factor, 1,'ubm1');