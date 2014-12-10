function    [A,G,a,r]=autolpc(x,p)
%
% function to computer the autocorrelation method solution
%
% Inputs:
%   x is the signal frame (usually speech weighted by a window)
%   p is the lpc model order
%
% Outputs:
%   A is the denominator vector for the lpc solution, i.e.,
%   A=1-a1z^{-1}-a2z^{-2}-...-apz^{-p}
%   G is the lpc model gain (rms prediction error)
%   a is the lpc polynomial (without the 1 term)
%   r is the vector of autocorrelation coefficients
%         see also ATOK, KTOA, RTOA

% solve for the lpc polynomial using a simple matrix inversion method
    L=length(x);
    r=[];
    for i=0:p
        r=[r; sum(x(1:L-i).*x(1+i:L))];
    end
    R=toeplitz(r(1:p));
    a=inv(R)*r(2:p+1);
    A=[1; -a];
    G=sqrt(sum(A.*r));
end