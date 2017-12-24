function [Muci,Stdci] = myBootstrapPlot(data1,rep,ci,dates,data2,type,PlotOutOfBoundsData)
    
%     %%%%%%%%%Instruction%%%%%%%%%
%     %[Muci,Stdci] = myBootstrapPlot(data1,rep,ci,dates,data2,type,PlotOutOfBoundsData)
%     % 1) this function do the bootstrap here
%     % 2) it returns the mean(Muci) and standard deviation(Stdci) confidence bounds of bootstrap samples. 
%     % 3) it can also plot the rawdata with bounds of assigned confident interval.
%     % 4) it can also point out the data which are out of the bounds of
%     %  assigned confident interval.
%     %
%     %%%%%%%%%%Usage%%%%%%%%%%%%
%     %%% Basic parameters
%     % 1) data1: the raw data you want to use to bootstrap. it only can be
%     a vector.
%     % 2) rep: repetition times for bootstraping.
%     % 3) ci: percentage of confidence interval.
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%% Other parameters %%%
%     % You can skip the following if you do not need to do the plot. If
%     you do, please read the following.
%     % 1) dates: the dates correspond to the raw data.
%     % 2) data2: the data you want to compare with the bounds of assigned
%     confidence interval.
%     % 3) type: the type of your raw data. i.e. 'Volatility' or 'Mean of Daily Trading Volume'
%     % 4) PlotOutOfBoundsData: just input 'y' to plot the points out of
%     bounds of assigned confidence interval.
    
        
    % delete the NaN elements in data.
    data1(isnan(data1)) = [];
    
    % bootstraping data
    N = size(data1,1);
    %INDICES = fix(1+N*rand(rep*N,1)); % Random integers between 1 and N
    INDICES = randi([1,N],rep*N,1);
    BootData = data1(INDICES,:);
    BootData = reshape(BootData, N, rep);
    
    % computing the critical points.
    alpha = 1-ci;
    bounds = norminv([alpha/2 1-alpha/2],0,1)';
    
    % computing the bounds with ci for mean.
    BootDataMu = mean(BootData);
    MuMu = mean(BootDataMu);
    MuStd = std(BootDataMu);
    Muci = MuMu + bounds .* MuStd;
    
    % computing the bounds with ci for standard deviation.
    BootDataStd = std(BootData); 
    StdMu = mean(BootDataStd);
    StdStd = std(BootDataStd);
    Stdci = StdMu+ bounds .* StdStd;
    
    if nargin >= 6
        switch type
            case 'Volatility'
                tempci = Stdci;
                ylname = 'Volatility';
            case 'mVolume'
                tempci = Muci;
                ylname = 'Mean of Daily Trading Volume';   
        end
    end
    
    if nargin == 6
        
        hold off
        plot(dates,data2);
        hold on          
        plot(dates,tempci(1),'r-')
        plot(dates,tempci(2),'r-')  
        datetick('x','yy')
        xlabel('Date')
        ylabel(ylname)
        title(['Repetition = ',num2str(rep)]);
    end
    
    if nargin == 7       
        if PlotOutOfBoundsData == 'y'
            indices = find(data2>tempci(2)|data2<tempci(1));
            OutBoundsDates = dates(indices);
            OutData = data2(indices);
            hold on
            plot(OutBoundsDates,OutData,'g+')
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