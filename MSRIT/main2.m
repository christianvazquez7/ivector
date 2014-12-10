clear;
%Read first 10 samples for speaker 1
[y,Fs] = wavread('OSR_us_000_0010_8k');
[s10]   = featureExtract(y, Fs) 
[y,Fs] = wavread('OSR_us_000_0011_8k');
[s11]   = featureExtract(y, Fs) 
[y,Fs] = wavread('OSR_us_000_0012_8k');
[s12]   = featureExtract(y, Fs) 
[y,Fs] = wavread('OSR_us_000_0013_8k');
[s13]   = featureExtract(y, Fs)
[y,Fs] = wavread('OSR_us_000_0014_8k');
[s14]   = featureExtract(y, Fs) 
[y,Fs] = wavread('OSR_us_000_0015_8k');
[s15]   = featureExtract(y, Fs) 
[y,Fs] = wavread('OSR_us_000_0016_8k');
[s16]   = featureExtract(y, Fs)
[y,Fs] = wavread('OSR_us_000_0017_8k');
[s17]   = featureExtract(y, Fs) 
[y,Fs] = wavread('OSR_us_000_0018_8k');
[s18]   = featureExtract(y, Fs) 
[y,Fs] = wavread('OSR_us_000_0019_8k');
[s19]   = featureExtract(y, Fs) 
