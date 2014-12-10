%=================================================
%Demo Mfcc
%=================================================
%fmin: min frequency=300
%fmax: max frequency=8000
%i: 10 filterbanks
%nftt=256
%samplerate=8000
%=================================================
fmin=0;
fmax=4000;
i=1;
n=10;
h=[];
f=[];
nfft=256;
samplerate=8000;
F_bank=[];

  mi = 1125 * log(1+fmin/700);
  ma = 1125 * log(1+fmax/700);

d=(ma-mi)/(n+1);

m = [mi:d:ma];

h=700*(exp(m/1125) - 1);

f = floor((nfft+1)*h/samplerate);

k=1;i=2;

 for i = 2%:11
    for  k=1:1:256 
        if k < f(1,i-1)
            F_bank(i,k)=0;
        end
        if ((k >= f(1,i-1))&(k<=f(1,i)))
            F_bank(i,k)=(k - f(1,i-1))/(f(1,i)-f(1,i-1));               
        else
            if ((k >= f(1,i))&(k<=f(1,i+1)))
                F_bank(i,k)=(f(1,i) - k )/(f(1,i+1)-f(1,i));
            end
        end
        if k > f(1,i+1)
            F_bank(i,k)=0;               
        end       
    end   
 end
 
 
plot(F_bank(2,:)) 
% k = 10;
%hilbert = zeros(k,k);      % Preallocate matrix

%for m = 1:k
 %   for n = 1:k
  %      hilbert(m,n) = 1/(m+n -1);
   % end
%end

