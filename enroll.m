function model = enroll( target,V,pla )

[y,Fs] = wavread(target);
mfc = featureExtract(y,Fs);
[N, F] = compute_bw_stats(mfc,'ubm');
model = extract_ivector([N; F], 'ubm', 'T');
model = V(:, 1 : 35)' * model;


end

