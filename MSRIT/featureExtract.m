function [mfc] = featureExtract(y, Fs)
   

    mfc = melfcc(y, Fs, 'lifterexp',-22, 'nbands', 20,'maxfreq', 4000,'sumpower', 0,'fbtype', 'htkmel','dcttype', 3);
    
    %invmfc = invmelfcc(mfc,Fs);
    %now we will normalize each parameter with mean and variance
    mfcmean = mean(mfc);
    mfcvar = var(mfc);
    [a b] = size (mfc);
    normmfc = zeros(a,b);
    for(i=1:1:b)
        for(j=1:1:a)
            normmfc(j,i) = (mfc(j,i)-mfcmean)/mfcvar;
        end
    end
    %now we build gmm based on this