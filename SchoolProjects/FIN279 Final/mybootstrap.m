function [MeanFromBoot, StdvFromBoot, BootMean, BootStd] = mybootstrap(rawdata, samplenum)

% rawdata must be the vector that you want to bootstrap.
% samplenum is the number of bootstrap samples.
% mybootstrap() returns the bootstraping mean and standard deviation
% of rawdata. It also return the multiple numbers of relevant data
% before calculating the final one.

% Bootstraping
rawdata(isnan(rawdata)) = [];
M = length(rawdata);
INDICES = fix(1+M*rand(samplenum*M,1)); % M is the number of stock prices
BootSamples = rawdata(INDICES,:);
Boots = reshape(BootSamples(:,1),M,samplenum);

% Relevant data.
BootMean = mean(Boots);
BootStd = std(Boots);

% Calculate the mean.
MeanFromBoot = mean(BootMean);
StdvFromBoot = mean(BootStd);

end