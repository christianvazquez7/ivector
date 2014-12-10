function [R,E,k,alpha,G]=durbin(xf,N,p,wtype)

% function [R,E,k,alpha,G]=durbin(xf,N,p,wtype)
%
% compute window based on wtype; wtype=1 for Hamming window, wtype=0 for
% Rectangular window
%
% compute R(0:p) from windowed xf
%
% solve Durbin recursion fo E,k,alpha in 8 easy steps
% step 1--E(0)=R(0)
% step 2--k(1)=R(1)/E(0)
% step 3--alpha(1,1)=k(1)
% step 4--E(1)=(1-k(1).^2)E(0)
% steps 5-8--for i=2,3,...,p;
% step 5--k(i)=[R(i)-sum from j=1 to i-1 alpha(j,i-1).*R(i-j)]/E(i-1)
% step 6--alpha(i,i)=k(i)
% step 7--for j=1,2,...,i-1
% alpha(j,i)=alpha(j,i-1)-k(i)alpha(i-j,i-1)
% step 8--E(i)=(1-k(i).^2)E(i-1)
%
if wtype==1
win=hamming(N);
else
win=boxcar(N);
end

% window frame for autocorrelation method
xf=xf.*win;
% compute autocorrelation
for k=0:p
R(k+1)=sum(xf(1:N-k).*xf(k+1:N));
end

% solve for lpc coefficients using Durbin's method
E=zeros(1,p);
k=zeros(1,p);
alpha=zeros(p,p);
E(1)=R(1);
ind=1;
k(ind)=R(ind+1)/E(ind);
alpha(ind,ind)=k(ind);
E(ind+1)=(1-k(ind).^2)*E(ind);
for ind=2:p
k(ind)=(R(ind+1)-sum(alpha(1:ind-1,ind-1)'.*R(ind:-1:2)))/E(ind);
alpha(ind,ind)=k(ind);
for jnd=1:ind-1
alpha(jnd,ind)=alpha(jnd,ind-1)-k(ind)*alpha(ind-jnd,ind-1);
end
E(ind+1)=(1-k(ind).^2)*E(ind);
end
G=sqrt(E(p+1));
