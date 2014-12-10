function [EL,alphal,GL,k]=lattice(xc,N,p)
% lattice solution to lpc equations
%
% follow 10 step solution
% step 1--set e(0)(m)=b(0)(m)=s(m)
% step 2--compute k1=alpha(1,1) from basic lattice reflection coefficient
% equation 8.89
% step 3--determine forward and backward errors e(1)(m) and b(1)(m) from
% eqns 8.84 and 8.87
% step 4--set i=2
% step 5--determine ki=alpha(i,i) from eqn 8.89
% step 6--determine alpha(j,i) for j-1,2,...,i-1 from eqn 8.70
% step 7--determine e(i)(m) and b(i)(m) from eqns. 8.84 and 8.87
% step 8--set i=i+1
% step 9--if i<=p, go to step 5
% step 10--finished
e(:,1)=xc;
b(:,1)=xc;
k(1)=sum(e(p+1:p+N,1).*b(p:p+N-1,1))/sqrt((sum(e(p+1:p+N,1).^2)*sum(b(p:p+N-1,1).^2)));
alphal(1,1)=k(1);
btemp=[0 b(:,1)']';
e(1:N+p,2)=e(1:N+p,1)-k(1)*btemp(1:N+p);
b(1:N+p,2)=btemp(1:N+p)-k(1)*e(1:N+p,1);
for i=2:p
k(i)=sum(e(p+1:p+N,i).*b(p:p+N-1,i))/sqrt((sum(e(p+1:p+N,i).^2)*sum(b(p:p+N-1,i).^2)));
alphal(i,i)=k(i);
for j=1:i-1
alphal(j,i)=alphal(j,i-1)-k(i)*alphal(i-j,i-1);
end
btemp=[0 b(:,i)']';
e(1:N+p,i+1)=e(1:N+p,i)-k(i)*btemp(1:N+p);
b(1:N+p,i+1)=btemp(1:N+p)-k(i)*e(1:N+p,i);
end
EL=sum(xc(p+1:p+N).^2);
for i=1:p
EL=EL*(1-k(i).^2);
end
GL=sqrt(EL);