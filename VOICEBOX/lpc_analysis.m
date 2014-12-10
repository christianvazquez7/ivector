function [Afile,Gfile,nframes,excx,exct]=lpc_analysis(xin,ss,es,L,R,p,win);

% routine to perform autocorrelation method of lpc analysis on original
% speech file

% INPUTS
%   xin: original speech file (usually in range -32768-to-32767)
%   ss: starting sample of first analysis frame
%   es: ending sample of speech file
%   L: analysis frame length in samples
%   R: analysis frame shift in samples
%   p: lpc order
%   win: analysis window for lpc analysis (forced to Hamming window)

% OUTPUTS
%   Afile: array with lpc coefficient vectors for each analysis frame
%   Gfile: array with lpc gains
%   nframes: number of frames in lpc analysis
%   excx: single frame lpc error signal
%   exct: sequence of frames of lpc error signal

% overlap-add gain term: R/W(e^{j0})
    gain=R/sum(win);
    
% process file in frames from ss to es
    Afile=[]; % stored lpc frames of A=[1 -a1 -a2 ... -ap]; Afile=[p+1,nframes]
    Gfile=[]; % stored lpc gains; Gfile=[1,nframes]
    exct=[];  % stored lpc error signal; exct[length(xin),1]
    nframes=0;
    n=ss;
    
    while (n+L-1 <= es)
        x=xin(n:n+L-1);       
        xw=x.*hamming(L);
        [A,G,a,r]=autolpc(xw,p);
        Afile=[Afile A];
        Gfile=[Gfile G];
        n=n+R;
        nframes=nframes+1;
        excx=filter(A,1,x);
        exct=[exct; excx(1:R)];
    end
end