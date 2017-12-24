function Sigma = gabNRimpv(OptionValue, S0, K, T, r, div, optyp,...
    tolerance,itermax)
%**************************************************************************
% Implied Volatility Calculation
%   Function calculates the implied volatility using Newton-Raphson Method
%   based on black-scholes model.
% 
%   gabNRimpv(OptionValue, S0, K, T, r, div, optyp,tolerance,itermax)
%
%==========================================================================
% INPUTS:     
%
%   OptionValue - The observed value of this option.
%
%   S0          - Initial price of the underlying asset
% 
%   K           - Strike price of the option
% 
%   T           - Option's maturity (fraction of year, i.e. in decimal)
% 
%   r           - Risk free rate-in annual terms (in decimal)
%
%   div         - Rnnualized dividend yield (in decimal)
% 
%   optyp       - Option type +1=call, -1=put
% 
%   tolerance   - The numeric error you can tolerate.
% 
%   itermax     - The max iterations.
%
%==========================================================================
% OUTPUTS:
%
%   Sigma   -   The estimated implied volatility
% 
%                   
%      
%==========================================================================
% EXAMPLE:
%
%       Value = 24.99; S0 = 309.43; K = 310; T = 90/360; rf = 0.00337;
%       div = 0; optyp = 1; tolerance = 1e-03; itermax = 1000;
% 
%       ImpliedVol = gabNRimpv(Value, S0, K, T, r, div, optyp,...
%                       tolerance,itermax)
%                      
%**************************************************************************

    % Parameter inputs checking
    input = {OptionValue, S0, K, T, r, div, optyp};
    if sum(cellfun(@isvector,input)) < 7
        error('input parameters must be vector or scalar.')
    end
    paraL = arrayfun(@(x) length(cell2mat(x)),{OptionValue,K,T},...
        'UniformOutput',false);
    if length(unique(cell2mat(paraL))) > 1
        error('CallPrice K T parameters must be in same length.')
    end

    % Prepare for vector parameters input
    L = length(OptionValue);
    values = OptionValue; strike = K; TtoM = T;
    Sigma = zeros(L,1);
    for i = 1:L
        OptionValue = values(i); K = strike(i); T = TtoM(i);    
        sigma = sqrt(2.*pi./T).*OptionValue./S0; %initial guess
        priceDiff = inf; %initial tolerance
        iternum = 0;
        % Object function
        dprice = @(x) gabBSpr(S0, K, T, r, div, x, optyp)-OptionValue;
        % Deriatives of dprice w.r.t sigma, which is Vega
        f_vega = @(x) gabBSGrks(S0,K,T,r,div,x,optyp,'vega');        
        % Main Newton Raphson Method Iteration
        while iternum <= itermax && abs(priceDiff) > tolerance && ...
                ~isnan(sigma)
            iternum = iternum+1;
            priceDiff = dprice(sigma);           
            vegaEst = f_vega(sigma); 
            %Update sigma:
            sigma = sigma - (priceDiff)./vegaEst;        
        end        
        try 
            Sigma(i) = sigma;
        catch
            Sigma(i) = NaN;
        end

    end

end
