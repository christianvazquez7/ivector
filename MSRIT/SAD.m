function [validFrames,sadFrames,spf] = SAD(y,Fs)

lenghtOfFrame_s = 10*1E-3;
samplesPerFrame =  floor(lenghtOfFrame_s * Fs) ;
trailSamples = mod(length(y),samplesPerFrame);
sampleFrames = reshape (y(1:end-trailSamples),samplesPerFrame,[]);
spf = samplesPerFrame;
plot(y);
frequency_domain =  fft(y);

prim_threshE = 40;
prim_threshF = 185;
prim_threshSF = 5;

w_sam = samplesPerFrame;
lsf = length(sampleFrames);
win = hamming(w_sam);

wintype = 'rectwin';
winlen = length(w_sam);
winamp = [0.5,1]*(1/winlen);

[a b] = size(sampleFrames);
parameters = zeros(4,1);
for i=1:1:b ,

    frame = sampleFrames(:,i);
    E = energy(frame.',wintype,winamp(2),10);
    energia = sum(E);
    sample = fft(sampleFrames(:,i));
    ssample = abs(sample);
    gmean = geomean(abs(sample));
    tmean = mean(ssample);
    SFM = 10*log10(gmean/tmean);
    
    [maxi, in] = max(ssample);
    
    f = in*(Fs/length(sample));
    
    parameters(1,i) = energia;
    parameters(2,i) = f;
    parameters(3,i) = abs(SFM);
end
%Zero crossing rate calc
o_sam=0;
ZTh = 40; %Zero crossing comparison rate for threshold
w_sam=a;
for t = 1:1:b
    ZCRCounter = 0; 
    nextIndex = (t-1)+1;
    for r = nextIndex+1:(nextIndex+w_sam-1)
        if (y(r) >= 0) && (y(r-1) >= 0)
         
        elseif (y(r) >= 0) && (y(r-1) < 0)
         ZCRCounter = ZCRCounter + 1;
        elseif (y(r) < 0) && (y(r-1) < 0)
         
        elseif (y(r) < 0) && (y(r-1) >= 0)
         ZCRCounter = ZCRCounter + 1;
        end
    end
    parameters(4,t) = ZCRCounter;
end
IZC = mean(parameters(4,(1:30))); %mean zero crossing rate for silence region
stdev = std(parameters(4,(1:30))); %standard deviation of crossing rate for silence region
IZCT = min(ZTh,IZC+2*stdev); %Zero crossing rate threshold
%--------------------------------------------------------------------------

minE = min(parameters(1:1,[1:30]));
minF = min(parameters(2:2,[1:30]));
minSFM =min(parameters(3:3,[1:30]));

aa = abs(log10(minE))*prim_threshE;
check = zeros(2,1);
silence = 0;
count = 0;
for i=1:1:b,
    if(i==88)
        int =3100
    end
    if(parameters(1,i) - minE >= aa)
        count = count + 1;
    end
    if (parameters(2,i) - minF >= prim_threshF)
       count = count + 1;
    end
    if(parameters(4,i)>ZTh)
        %count = count +1;
    end
    if (parameters(3,i) - minSFM >= prim_threshSF)
        count = count + 1;
    end
    if(count > 1)
       check(i,1) = 1; 
    else
       minE = ((silence*minE)+ parameters(1,i))/(silence+1);
       silence = silence + 1;
       aa = abs(log10(minE)) * prim_threshE;

    end
    count = 0;
end
streakType = check(1);
streak = 0;
formatted = zeros(2,2);
j = 1;
prevType = streakType;
total = 0;
zeroStreak = 0;
oneStreak = 0;
for i=1:length(check)
    if (check(i) == streakType)
        streak = streak + 1;
        total = total + 1;
    else
        if( streakType == 1 && streak >=10)
            formatted(j,1) = 1;
            formatted(j,2) = total;
            streak = 1;
            streakType = check(i);
            j = j+1;
            total = 1;
        elseif ( streakType == 0 && streak >= 5)
            formatted(j,1) = 0;
            formatted(j,2) = total;
            streak = 1;
            streakType = check(i);
            j = j+1;
            total = 1;
        else     
            streakType = check(i);
            streak = 1;            
            total = total + 1;
        end
    end 
end
time = 0;
total = 0;
streakt = formatted(1,1);
k = 1;
semiFinal = zeros(1,1);
for j=1:length(formatted)
    if (formatted(j,1) == streakt)
       total = total + formatted(j,2);
    else
        semiFinal(k,1) = streakt;
        semiFinal(k,2) = total;
        total = formatted(j,2); 
        streakt = formatted(j,1);
        k = k + 1;
    end   
end

if (total ~= 0)
    semiFinal(k,2) = total;
    semiFinal(k,1) = streakt;
end

final = zeros(1,1);
minimum = 500E-3;
k = 2;
final(1,1) = semiFinal(1,1);
final(1,2) = semiFinal(1,2);
skip = false;
[m n] = size(semiFinal);

for j = 2: m
   if(skip) 
       skip = false;
   else
    if (semiFinal(j,1) == 1)
        final(k,1) = 1;
        final(k,2) = semiFinal(j,2);
        k = k+1;
    else
        if(semiFinal(j,2)*10E-3 <= minimum)
           if (j+1<= length(semiFinal))
           final(k-1,2) = final(k-1,2) + semiFinal(j,2) + semiFinal(j+1,2);
           else
           final(k-1,2) = final(k-1,2) + semiFinal(j,2);
           end
           skip = true;
        else
            final(k,2) = semiFinal(j,2);
            final(k,1) = semiFinal(j,1);
            k = k+1;
        end
    end
   end
end
[m n] = size(final)
for j=1:m 
    
        total = final(j,2); 
        streakt = final(j,1);
        if (streakt == 0)
        fprintf('Silence from %1f --> %1f \n',time, time +total*10E-3);
        else
        fprintf('Speech from %1f --> %1f \n',time, time +total*10E-3);
        end
        time = time + total*10E-3;
end
validFrames = final;
sadFrames = sampleFrames;