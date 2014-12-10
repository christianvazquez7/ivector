function [mfc] = featureExtract(y, Fs)
    [validFrames,frames,spf] = SAD(y,Fs);
    [row col] = size(validFrames);
    [row2 col2] = size(frames);
    index = 1;
    usableindex = 1;
    usable = zeros(row2,1);
    for(i=1:1:row)
            streakt = validFrames(i,1);
            streakLength  = validFrames(i,2);
            if (streakt == 1)
                origcols =   [index:index+streakLength];
                gframes = frames(:, origcols);
                %col by col
                for(j=1:1:streakLength)
                    for(k=1:1:row2)
                        usable(k,usableindex)=gframes(k,j);  
                    end
                    usableindex=usableindex+1;
                end

            end
            index=index+streakLength;
    end
    [a b] = size(usable);
    largevector = zeros(a*b,1);
    i=1;
    for(j=1:1:row2)
        for(k=1:1:b)
            largevector(i,1) = usable(j,k);
            i=i+1;
        end
    end
    %we should now have speech frame data.  
    %we will calculate the mfcc from this data

    mfc = melfcc(largevector, Fs);
    invmfc = invmelfcc(mfc);
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