function [opt,rawopt] = OptionKVTD(filename,sheetname,Kcol,Vcol,S0,rf,div,N,...
    optyp,opsy)
%**************************************************************************
% Generate 3D plot structure
% This function is going to generate a struct variables containing 
%     struct(Strike price, Option Value, Time to Maturity, Expiration Date)
%   from excel files in specific format.
%
%   OptionKVTD(filename,sheetname,Kcol,Vcol,S0,rf,div,optyp)
%
%==========================================================================
% INPUTS:     
%   filename      - Excel name
% 
%   sheetname     - Excel sheetname 
% 
%   Kcol          - Column number of strie price location
% 
%   Vcol          - Column number of option value location
% 
%   S0            - Initial price of the underlying asset
% 
%   rf            - Risk free rate-in annual terms (in decimal)
% 
%   div           - Annualized dividend yield (in decimal)
% 
%   N             - The number of steps. (dt=T/N)
% 
%   opty          - Option type +1=call, -1=put
% 
%   opsy          - Option style Euro=0, Amer=1
% 

%
%
%==========================================================================
% OUTPUTS:
%
%   opt   - A structure for 3-D plot.
% 
%==========================================================================
% EXAMPLE:
%       S0 = 309.58; rf=0.0017; div=1.39/100; optyp=1; Kcol=2; Vcol=3;
%       filename = 'callputprice';sheetname = 'Call' ;
% 
%       opt = OptionKVTD(filename,sheetname,Kcol,Vcol,S0,rf,div,optyp)
% 
%
%**************************************************************************

    
    % Import data and pre-process
    rawopt = xlsread(filename,sheetname);
    optdate = rawopt(:,1);
    datetype = unique(optdate); 
    % Fix import time problem on mac
    datecol = cellstr(datestr(FixMacTime(optdate)));
    opt.date = reshape(datecol,length(datecol)/length(datetype),...
        length(datetype));
    
    % Create option structure
    for i = 1:length(datetype)
        ind = optdate==datetype(i);
        opt.K(:,i) = rawopt(ind,Kcol);
        opt.V(:,i) = rawopt(ind,Vcol);
        opt.T(:,i) = repmat(15/360,sum(ind),1);
        opt.impv(:,i) = gabImpv(opt.V(:,i), S0, opt.K(:,i), opt.T(:,i),... 
            rf, div, N, optyp, opsy, 'BN','newton',1e-05,10000);
%         opt.impv(:,i) = gabNRimpv(opt.V(:,i), S0, opt.K(:,i), opt.T(:,i),... 
%             rf, div, optyp,1e-05,10000);
    end
    
    % Calculate Moneyness
    opt.M = opt.K./S0;
end
