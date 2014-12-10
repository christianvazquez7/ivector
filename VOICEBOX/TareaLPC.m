% LPC Homework
% read in speech file, chooses section of speech and solve for set of
% lpc coefficients using the autocorrelation method, the covariance
% method and the lattice method and the brute force
filename= 'Test';
[xin,fs] = wavread('tester.wav');

% normalize input to [-1,1] range and play out sound file
[nrows, ncol]=size(xin);
m=18;
N=100;
p=4;
wtype=1;%input('window type(1=Hamming, 0=Rectangular):');
stitle=sprintf('file: %s, ss: %d N: %d p: %d',filename,m,N,p);

% print out number of samples in file, read in plotting parameters
fprintf(' number of samples in file: %7.0f \n', nrows);

% autocorrelation method--choose section of speech, window using Hamming
% window, compute autocorrelation for i=0,1,...,p
% get original spectrum
xino=[(xin(m:m+N-1).*hamming(N))' zeros(1,512-N)];
h0=fft(xino,512);
f=0:fs/512:fs-fs/512;
plot(f(1:257),20*log10(abs(h0(1:257)))),title(stitle),ylabel('log magnitude (dB)'),...
xlabel('frequency in Hz');
hold on;

% autocorrelation method
xf=xin(m:m+N-1);
[R,E,k,alpha,G]=durbin(xf,N,p,wtype);
alphap=alpha(1:p,p);
num=[1 -alphap'];
[ha,f]=freqz(G,num,512,fs);
plot(f,20*log10(abs(ha)),'y-');

%BF Autoco
[A,G,a,r]=autolpc(xino,p)
num2=[1 -a'];
[hl2,f]=freqz(G,num2,512,fs);
plot(f,20*log10(abs(hl2)),'m-.');


% covariance method--choose section of speech, compute correlation matrix
% and covariance vector
xc=xin(m-p:m+N-1);
[phim,phiv,EC,alphac,GC]=cholesky(xc,N,p);
numc=[1 -alphac'];
[hc,f]=freqz(GC,numc,512,fs);
plot(f,20*log10(abs(hc)),'c--');

%BF Autocov
[ar,e,dc]=lpccovar(xc,p)
[hc,f]=freqz(GC,numc,512,fs);
plot(f,20*log10(abs(hc)),'k-.');


% lattice method--choose section of speech, compute forward and backward
% errors
xl=xin(m-p:m+N-1);
[EL,alphal,GL,k]=lattice(xl,N,p);
alphalat=alphal(:,p);
numl=[1 -alphalat'];
[hl,f]=freqz(GL,numl,512,fs);
plot(f,20*log10(abs(hl)),'g-.');
legend('windowed speech','autocorrelation method(-)','BF Autocorrelation(-.)','covariance method(-)','BF covariance method(-.)','lattice method')% fvtool(GL,numl);

