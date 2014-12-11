function lscore = score(model,target,V,pla)

[y,Fs] = wavread(target);
mfc = featureExtract(y,Fs);
[N, F] = compute_bw_stats(mfc,'ubm');
vector = extract_ivector([N; F], 'ubm', 'T');
vector = V(:, 1 : 35)' * vector;
lscore = score_gplda_trials(pla, model, vector);

end

