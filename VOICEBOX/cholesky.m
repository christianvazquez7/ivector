function [phim,phiv,EC,alphac,GC]=cholesky(xc,L,p)
%
% The function cholesky is used to solve the covariance method of linear
% prediction analysis
%
%  function [phim,phiv,EC,alphac,GC]=cholesky(xc,L,p)
%
% Inputs:
%   xc: extended speech window of duration L+p samples; first p samples
%   used to compute modified correlation function
%   L: length of analysis frame in samples (not including the extra p
%   samples required for modified correlation function)
%   p: lpc system order for solution
% Outputs:
%   phim: p x p array storing the symmetric correlation matrix
%   phiv: p x 1 row vector of correlations
%   EC: scalar residual energy of prediction
%   alphac: p x 1 array of lpc coefficients of solution
%   GC: scalar gain of resulting lpc polynomial

%  first compute phim(1,1)...phim(p,p)
%  next compute phiv(1,0)...phiv(p,0)
    for i=1:p
        for k=1:p
            phim(i,k)=sum(xc(p+1-i:p+L-i).*xc(p+1-k:p+L-k));
        end
    end
    
    for i=1:p
        phiv(i)=sum(xc(p+1-i:p+L-i).*xc(p+1:p+L));
        phiz(i)=sum(xc(p+1:p+L).*xc(p+1-i:p+L-i));
    end
    phi0=sum(xc(p+1:p+L).^2);
    
%  use simple matrix inverse to solve equations--come back to Cholesky 
%  decomposition later   
    phiv=phiv';
    
%  solve using matrix inverse,  phim*alphac=phiv    
%  alphac=inv(phim)*phiv
    alphac=inv(phim)*phiv;
    
% wrap up with computation of EC and GC
    EC=phi0-sum(alphac'.*phiz);
    GC=sqrt(EC);
end
