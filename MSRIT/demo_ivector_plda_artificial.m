%{ 

This is a demo on how to use the Identity Toolbox for i-vector based speaker
recognition. A small scale task has been designed using artificially
generated features for 20 speakers. Each speaker has 10 sessions
(channels) and each session is 1000 frames long (10 seconds assuming 10 ms
frame increments).

There are 5 steps involved:
 
 1. training a UBM from background data
 2. learning a total variability subspace from background statistics
 3. training a Gaussian PLDA model with development i-vectors
 4. scoring verification trials with model and test i-vectors
 5. computing the performance measures (e.g., EER and confusion matrix)

Note: given the relatively small size of the task, we can load all the data 
and models into memory. This, however, may not be practical for large scale 
tasks (or on machines with a limited memory). In such cases, the parameters 
should be saved to the disk.

Malcolm Slaney <mslaney@microsoft.com>
Omid Sadjadi <s.omid.sadjadi@gmail.com>
Microsoft Research, Conversational Systems Research Center

%}

%% 
% Step0: Set the parameters of the experiment
nSpeakers = 3;
nDims = 13;             % dimensionality of feature vectors
nMixtures = 32;         % How many mixtures used to generate data
nChannels = 19;         % Number of channels (sessions) per speaker
nFrames = 129;         % Frames per speaker (10 seconds assuming 100 Hz)
nWorkers = 1;           % Number of parfor workers, if available

% Pick random centers for all the mixtures.
mixtureVariance = .10;
channelVariance = .05;
mixtureCenters = randn(nDims, nMixtures, nSpeakers);
channelCenters = randn(nDims, nMixtures, nSpeakers, nChannels)*.1;
testSpeakerData = cell(nSpeakers, nChannels);
testSpeakerData = cell(nSpeakers, nChannels);
speakerID = zeros(nSpeakers, nChannels);

% Create the random data. Both training and testing data have the same
% layout.
for s=1:nSpeakers
    trainSpeechData = zeros(nDims, nMixtures);
    testSpeechData = zeros(nDims, nMixtures);
    for c=1:nChannels
        for m=1:nMixtures
            % Create data from mixture m for speaker s
            frameIndices = m:nMixtures:nFrames;
            nMixFrames = length(frameIndices);
            trainSpeechData(:,frameIndices) = ...
                randn(nDims, nMixFrames)*sqrt(mixtureVariance) + ...
                repmat(mixtureCenters(:,m,s),1,nMixFrames) + ...
                repmat(channelCenters(:,m,s,c),1,nMixFrames);
            testSpeechData(:,frameIndices) = ...
                randn(nDims, nMixFrames)*sqrt(mixtureVariance) + ...
                repmat(mixtureCenters(:,m,s),1,nMixFrames) + ...
                repmat(channelCenters(:,m,s,c),1,nMixFrames);
        end
        testSpeakerData{s, c} = trainSpeechData;
        testSpeakerData{s, c} = testSpeechData;
        speakerID(s,c) = s;                 % Keep track of who this is
    end
end
[y,Fs] = wavread('frf01_f01_solo');
[s10]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_f02_solo');
[s11]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_f03_solo');
[s12]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_f04_solo');
[s13]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s05_solo');
[s14]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s06_solo');
[s15]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s07_solo');
[s16]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s08_solo');
[s17]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s09_solo');
[s18]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s10_solo');
[s19]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s11_solo');
[s110]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s12_solo');
[s111]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s13_solo');
[s112]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s14_solo');
[s113]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s15_solo');
[s114]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s16_solo');
[s115]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s17_solo');
[s116]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s18_solo');
[s117]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s19_solo');
[s118]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf01_s20_solo');
[s119]   = featureExtract(y, Fs) 

trainSpeakerData{1,1} = s10(1:end,1:nFrames);
trainSpeakerData{1,2} = s11(1:end,1:nFrames);
trainSpeakerData{1,3} = s12(1:end,1:nFrames);
trainSpeakerData{1,4} = s13(1:end,1:nFrames);
trainSpeakerData{1,5} = s14(1:end,1:nFrames);
trainSpeakerData{1,6} = s15(1:end,1:nFrames);
trainSpeakerData{1,7} = s16(1:end,1:nFrames);
trainSpeakerData{1,8} = s17(1:end,1:nFrames);
trainSpeakerData{1,9} = s18(1:end,1:nFrames);
trainSpeakerData{1,10} = s19(1:end,1:nFrames);
trainSpeakerData{1,11} = s110(1:end,1:nFrames);
trainSpeakerData{1,12} = s111(1:end,1:nFrames);
trainSpeakerData{1,13} = s112(1:end,1:nFrames);
trainSpeakerData{1,14} = s113(1:end,1:nFrames);
trainSpeakerData{1,15} = s114(1:end,1:nFrames);
trainSpeakerData{1,16} = s115(1:end,1:nFrames);
trainSpeakerData{1,17} = s116(1:end,1:nFrames);
trainSpeakerData{1,18} = s117(1:end,1:nFrames);
trainSpeakerData{1,19} = s118(1:end,1:nFrames);
trainSpeakerData{1,20} = s119(1:end,1:nFrames);

[y,Fs] = wavread('frf02_f01_solo');
[s10]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_f02_solo');
[s11]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_f03_solo');
[s12]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_f04_solo');
[s13]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s05_solo');
[s14]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s06_solo');
[s15]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s07_solo');
[s16]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s08_solo');
[s17]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s09_solo');
[s18]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s10_solo');
[s19]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s11_solo');
[s110]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s12_solo');
[s111]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s13_solo');
[s112]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s14_solo');
[s113]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s15_solo');
[s114]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s16_solo');
[s115]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s17_solo');
[s116]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s18_solo');
[s117]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s19_solo');
[s118]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf02_s20_solo');
[s119]   = featureExtract(y, Fs) 

trainSpeakerData{2,1} = s10(1:end,1:nFrames);
trainSpeakerData{2,2} = s11(1:end,1:nFrames);
trainSpeakerData{2,3} = s12(1:end,1:nFrames);
trainSpeakerData{2,4} = s13(1:end,1:nFrames);
trainSpeakerData{2,5} = s14(1:end,1:nFrames);
trainSpeakerData{2,6} = s15(1:end,1:nFrames);
trainSpeakerData{2,7} = s16(1:end,1:nFrames);
trainSpeakerData{2,8} = s17(1:end,1:nFrames);
trainSpeakerData{2,9} = s18(1:end,1:nFrames);
trainSpeakerData{2,10} = s19(1:end,1:nFrames);
trainSpeakerData{2,11} = s110(1:end,1:nFrames);
trainSpeakerData{2,12} = s111(1:end,1:nFrames);
trainSpeakerData{2,13} = s112(1:end,1:nFrames);
trainSpeakerData{2,14} = s113(1:end,1:nFrames);
trainSpeakerData{2,15} = s114(1:end,1:nFrames);
trainSpeakerData{2,16} = s115(1:end,1:nFrames);
trainSpeakerData{2,17} = s116(1:end,1:nFrames);
trainSpeakerData{2,18} = s117(1:end,1:nFrames);
trainSpeakerData{2,19} = s118(1:end,1:nFrames);
trainSpeakerData{2,20} = s119(1:end,1:nFrames);

[y,Fs] = wavread('frf03_f01_solo');
[s10]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_f02_solo');
[s11]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_f03_solo');
[s12]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_f04_solo');
[s13]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s05_solo');
[s14]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s06_solo');
[s15]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s07_solo');
[s16]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s08_solo');
[s17]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s09_solo');
[s18]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s10_solo');
[s19]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s11_solo');
[s110]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s12_solo');
[s111]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s13_solo');
[s112]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s14_solo');
[s113]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s15_solo');
[s114]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s16_solo');
[s115]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s17_solo');
[s116]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s18_solo');
[s117]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s19_solo');
[s118]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf03_s20_solo');
[s119]   = featureExtract(y, Fs) 
trainSpeakerData{3,1} = s10(1:end,1:nFrames);
trainSpeakerData{3,2} = s11(1:end,1:nFrames);
trainSpeakerData{3,3} = s12(1:end,1:nFrames);
trainSpeakerData{3,4} = s13(1:end,1:nFrames);
trainSpeakerData{3,5} = s14(1:end,1:nFrames);
trainSpeakerData{3,6} = s15(1:end,1:nFrames);
trainSpeakerData{3,7} = s16(1:end,1:nFrames);
trainSpeakerData{3,8} = s17(1:end,1:nFrames);
trainSpeakerData{3,9} = s18(1:end,1:nFrames);
trainSpeakerData{3,10} = s19(1:end,1:nFrames);
trainSpeakerData{3,11} = s110(1:end,1:nFrames);
trainSpeakerData{3,12} = s111(1:end,1:nFrames);
trainSpeakerData{3,13} = s112(1:end,1:nFrames);
trainSpeakerData{3,14} = s113(1:end,1:nFrames);
trainSpeakerData{3,15} = s114(1:end,1:nFrames);
trainSpeakerData{3,16} = s115(1:end,1:nFrames);
trainSpeakerData{3,17} = s116(1:end,1:nFrames);
trainSpeakerData{3,18} = s117(1:end,1:nFrames);
trainSpeakerData{3,19} = s118(1:end,1:nFrames);
trainSpeakerData{3,20} = s119(1:end,1:nFrames);

[y,Fs] = wavread('frf04_s01_solo');
[s10]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s02_solo');
[s11]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s03_solo');
[s12]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s04_solo');
[s13]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s05_solo');
[s14]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s06_solo');
[s15]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s07_solo');
[s16]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s08_solo');
[s17]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s09_solo');
[s18]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s10_solo');
[s19]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s11_solo');
[s110]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s12_solo');
[s111]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s13_solo');
[s112]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s14_solo');
[s113]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s15_solo');
[s114]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s16_solo');
[s115]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s17_solo');
[s116]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s18_solo');
[s117]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s19_solo');
[s118]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frf04_s20_solo');
[s119]   = featureExtract(y, Fs) 

testSpeakerData{1,1} = s10(1:end,1:nFrames);
testSpeakerData{1,2} = s11(1:end,1:nFrames);
testSpeakerData{1,3} = s12(1:end,1:nFrames);
testSpeakerData{1,4} = s13(1:end,1:nFrames);
testSpeakerData{1,5} = s14(1:end,1:nFrames);
testSpeakerData{1,6} = s15(1:end,1:nFrames);
testSpeakerData{1,7} = s16(1:end,1:nFrames);
testSpeakerData{1,8} = s17(1:end,1:nFrames);
testSpeakerData{1,9} = s18(1:end,1:nFrames);
testSpeakerData{1,10} = s19(1:end,1:nFrames);
testSpeakerData{1,11} = s110(1:end,1:nFrames);
testSpeakerData{1,12} = s111(1:end,1:nFrames);
testSpeakerData{1,13} = s112(1:end,1:nFrames);
testSpeakerData{1,14} = s113(1:end,1:nFrames);
testSpeakerData{1,15} = s114(1:end,1:nFrames);
testSpeakerData{1,16} = s115(1:end,1:nFrames);
testSpeakerData{1,17} = s116(1:end,1:nFrames);
testSpeakerData{1,18} = s117(1:end,1:nFrames);
testSpeakerData{1,19} = s118(1:end,1:nFrames);
testSpeakerData{1,20} = s119(1:end,1:nFrames);

[y,Fs] = wavread('frm01_s01_solo');
[s10]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s02_solo');
[s11]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s03_solo');
[s12]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s04_solo');
[s13]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s05_solo');
[s14]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s06_solo');
[s15]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s07_solo');
[s16]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s08_solo');
[s17]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s09_solo');
[s18]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s10_solo');
[s19]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s11_solo');
[s110]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s12_solo');
[s111]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s13_solo');
[s112]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s14_solo');
[s113]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s15_solo');
[s114]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s16_solo');
[s115]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s17_solo');
[s116]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s18_solo');
[s117]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s19_solo');
[s118]   = featureExtract(y, Fs) 
[y,Fs] = wavread('frm01_s20_solo');
[s119]   = featureExtract(y, Fs) 

testSpeakerData{2,1} = s10(1:end,1:nFrames);
testSpeakerData{2,2} = s11(1:end,1:nFrames);
testSpeakerData{2,3} = s12(1:end,1:nFrames);
testSpeakerData{2,4} = s13(1:end,1:nFrames);
testSpeakerData{2,5} = s14(1:end,1:nFrames);
testSpeakerData{2,6} = s15(1:end,1:nFrames);
testSpeakerData{2,7} = s16(1:end,1:nFrames);
testSpeakerData{2,8} = s17(1:end,1:nFrames);
testSpeakerData{2,9} = s18(1:end,1:nFrames);
testSpeakerData{2,10} = s19(1:end,1:nFrames);
testSpeakerData{2,11} = s110(1:end,1:nFrames);
testSpeakerData{2,12} = s111(1:end,1:nFrames);
testSpeakerData{2,13} = s112(1:end,1:nFrames);
testSpeakerData{2,14} = s113(1:end,1:nFrames);
testSpeakerData{2,15} = s114(1:end,1:nFrames);
testSpeakerData{2,16} = s115(1:end,1:nFrames);
testSpeakerData{2,17} = s116(1:end,1:nFrames);
testSpeakerData{2,18} = s117(1:end,1:nFrames);
testSpeakerData{2,19} = s118(1:end,1:nFrames);
testSpeakerData{2,20} = s119(1:end,1:nFrames);
testSpeakerData{3,1} = s10(1:end,1:nFrames);
testSpeakerData{3,2} = s11(1:end,1:nFrames);
testSpeakerData{3,3} = s12(1:end,1:nFrames);
testSpeakerData{3,4} = s13(1:end,1:nFrames);
testSpeakerData{3,5} = s14(1:end,1:nFrames);
testSpeakerData{3,6} = s15(1:end,1:nFrames);
testSpeakerData{3,7} = s16(1:end,1:nFrames);
testSpeakerData{3,8} = s17(1:end,1:nFrames);
testSpeakerData{3,9} = s18(1:end,1:nFrames);
testSpeakerData{3,10} = s19(1:end,1:nFrames);
testSpeakerData{3,11} = s110(1:end,1:nFrames);
testSpeakerData{3,12} = s111(1:end,1:nFrames);
testSpeakerData{3,13} = s112(1:end,1:nFrames);
testSpeakerData{3,14} = s113(1:end,1:nFrames);
testSpeakerData{3,15} = s114(1:end,1:nFrames);
testSpeakerData{3,16} = s115(1:end,1:nFrames);
testSpeakerData{3,17} = s116(1:end,1:nFrames);
testSpeakerData{3,18} = s117(1:end,1:nFrames);
testSpeakerData{3,19} = s118(1:end,1:nFrames);
testSpeakerData{3,20} = s119(1:end,1:nFrames);


%%
% Step1: Create the universal background model from all the training speaker data
nmix = nMixtures;           % In this case, we know the # of mixtures needed
final_niter = 10;
ds_factor = 1;
ubm = gmm_em(testSpeakerData(:), nmix, final_niter, ds_factor, nWorkers);


%%
% Step2.1: Calculate the statistics needed for the iVector model.
stats = cell(nSpeakers, nChannels);
for s=1:nSpeakers
    for c=1:nChannels
        [N,F] = compute_bw_stats(testSpeakerData{s,c}, ubm);
        stats{s,c} = [N; F];
    end
end

% Step2.2: Learn the total variability subspace from all the speaker data.
tvDim = 100;
niter = 5;
T = train_tv_space(stats(:), ubm, tvDim, niter, nWorkers);
%
% Now compute the ivectors for each speaker and channel.  The result is size
%   tvDim x nSpeakers x nChannels
devIVs = zeros(tvDim, nSpeakers, nChannels);
for s=1:nSpeakers
    for c=1:nChannels
        devIVs(:, s, c) = extract_ivector(stats{s, c}, ubm, T);
    end
end

%%
% Step3.1: Now do LDA on the iVectors to find the dimensions that matter.
ldaDim = min(100, nSpeakers-1);
devIVbySpeaker = reshape(devIVs, tvDim, nSpeakers*nChannels);
[V,D] = lda(devIVbySpeaker, speakerID(:));
finalDevIVs = V(:, 1:ldaDim)' * devIVbySpeaker;

% Step3.2: Now train a Gaussian PLDA model with development i-vectors
nphi = ldaDim;                  % should be <= ldaDim
niter = 10;
pLDA = gplda_em(finalDevIVs, speakerID(:), nphi, niter);

%%
% Step4.1: OK now we have the channel and LDA models. Let's build actual speaker
% models. Normally we do that with new enrollment data, but now we'll just
% reuse the development set.
%Generate I vectors with new data.  Change devIVs
averageIVs = mean(devIVs, 3);           % Average IVs across channels.
modelIVs = V(:, 1:ldaDim)' * averageIVs;


% Step4.2: Now compute the ivectors for the test set 
% and score the utterances against the models
testIVs = zeros(tvDim, nSpeakers, nChannels); 
for s=1:nSpeakers
    for c=1:nChannels
        [N, F] = compute_bw_stats(testSpeakerData{s, c}, ubm);
        testIVs(:, s, c) = extract_ivector([N; F], ubm, T);
    end
end
testIVbySpeaker = reshape(permute(testIVs, [1 3 2]), ...
                            tvDim, nSpeakers*nChannels);
finalTestIVs = V(:, 1:ldaDim)' * testIVbySpeaker;

%%
% Step5: Now score the models with all the test data.
ivScores = score_gplda_trials(pLDA, modelIVs, finalTestIVs);
imagesc(ivScores)
title('Speaker Verification Likelihood (iVector Model)');
xlabel('Test # (Channel x Speaker)'); ylabel('Model #');
colorbar; axis xy; drawnow;

answers = zeros(nSpeakers*nChannels*nSpeakers, 1);
for ix = 1 : nSpeakers,
    b = (ix-1)*nSpeakers*nChannels + 1;
    answers((ix-1)*nChannels+b : (ix-1)*nChannels+b+nChannels-1) = 1;
end

ivScores = reshape(ivScores', nSpeakers*nChannels* nSpeakers, 1);
figure;
eer = compute_eer(ivScores, answers, true);
