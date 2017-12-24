function bounds = myBootstrap(data,rep,ci,flag,n,lambda)
    % [BootData,cibounds] = myBootstrapB(data,rep,ci) do the bootstrap data here.
    % it returns the bootstrap dataset for rep times for the input data as BootData.
    % it also returns the bounds of ci confidence interval ci as cibounds.
    % data decides what value you need to bootstrap.
    % rep is the bootstrap repetition.
    % ci is the confidence interval.
    % n is the moving days.
    % lambda is the weighted factor.

    % delete the NaN elements in data.
    data(isnan(data)) = [];
    
    % bootstraping data
    N = size(data,1);
    %INDICES = fix(1+N*rand(rep*N,1)); % Random integers between 1 and N
    INDICES = fix(1+N*rand(rep*N,1));
    BootData = data(INDICES,:);
    BootData = reshape(BootData, N, rep);
    
    % computing the critical points.
    alpha = 1-ci;
    bounds = norminv([alpha/2 1-alpha/2],0,1)';
    
    switch flag
        case 1
        % computing the bounds with ci for mean.
            BootDataMu = mean(BootData);
            MuMu = mean(BootDataMu);
            MuStd = std(BootDataMu);
            bounds = MuMu + bounds .* MuStd;
        case 2
            BootDataStd = std(BootData); 
            StdMu = mean(BootDataStd);
            StdStd = std(BootDataStd);
            bounds = StdMu+ bounds .* StdStd;
    end
    
    if nargin > 4
        switch flag
            case 3
                Mu3 = MAmean(BootData,n,lambda);
                Mu3(isnan(Mu3)) = [];
                Mu3Mu = mean(Mu3);
                Mu3Std = std(Mu3);
                bounds = Mu3Mu + bounds .* Mu3Std;

            case 4
                Mu4 = MAmean(BootData,n,lambda);
                Std4 = EWMAvolatility(BootData,Mu4,n,lambda);
                Std4(isnan(Std4)) = [];
                Std4Mu = mean(Std4);
                Std4Std = std(Std4);
                bounds = Std4Mu + bounds .* Std4Std;
        end   
    end
    
end


%% QUESTION:
%1) what is the difference for the following ways to create indices for bootstrap.
%	a. INDICES = fix(1+N*rand(rep*N,1)); % Random integers between 1 and N
%	b. INDICES = randi([1,N],rep*N,1);
% 2) I know there arer some other way which might computing the bounds for specific confidence interval, but I don't know how to use it correctly.
%	a. normfit()
%	b. norminv()
%	c. paramci()
% 	d. prctile()