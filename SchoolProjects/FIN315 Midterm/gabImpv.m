function [myimpV,output] = gabImpv(OptionValue, S0, K, T, r, div, N, ...
    optyp, opsy,model,method,varargin)
%**************************************************************************
% Implied Volatility Calculation
%   Function calculates the implied volatility using NR, fzero, fsolve and
%   rough incremental methods, based on black-scholes model or binomial 
%   model.
% 
%   gabImpv(OptionValue, S0, K, T, r, div, optyp,model,method,varargin)
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
%   N           - The number of steps. (dt=T/N)
% 
%   optyp       - Option type +1=call, -1=put
% 
%   opsy        - Option style Euro=0, Amer=1
% 
%   model       - Pricing model. 'BS' = black-scholes, 'BN' = binomial
% 
%   method      - Approximation method. 'newton' = newton-raphson, 
%                 'fzero' = fzero, 'fsolve' = fsolve, 'incremental' =
%                 incremental.
%   
%   varargin{:}
%           1   - Tolerance: The numeric error you can tolerate.
% 
%           2   - Initial Guess or Itermax: The initial guess for x-point 
%                   or the max iterations.
%           3   - Incremental value for 'incremental' method
%
%==========================================================================
%   Note: 
%       Incremental need 4 control variables --- tolerance, iniGuess, 
%       incremental value.
%       newton need 2 control variables --- tolerance, intermax.
%       fzero need 2 control variables --- tolerance, iniGuess.
%       fsolve need 2 control variables --- tolerance, iniGuess.
%==========================================================================
% OUTPUTS:
%
%   myimpV   -   The estimated implied volatility.
% 
%   output   -   The approximation details.
%      
%==========================================================================
% EXAMPLE:
%
%       Value = 24.99; S0 = 309.43; K = 310; T = 90/360; rf = 0.00337;
%       div = 0; optyp = 1; tolerance = 1e-03; iniGuess = 1000;
%       model = 'BS'; method = 'fzero';
% 
%       ImpliedVol = gabImpv(OptionValue, S0, K, T, r, div, optyp,...
%                       model,method,tolerance, iniGuess)
%                      
%**************************************************************************




    % Object function
    f = @(x) objfcn(x,S0,K,T,r,OptionValue,div,N,optyp,opsy,model);

    % Newton Raphson Method
    if strcmp(method,'newton')
        tolerance = varargin{1}; itermax = varargin{2};
        myimpV = gabNRimpv(OptionValue, S0, K, T, r, div, optyp,...
            tolerance,itermax);
        % if this method fails, use next method instead.
        if ~exist('myimpV','var')
            if isnan(myimpV)
                method = 'fzero';
                varargin{2} = 1/itermax;
                display(['Warning: the group with strike price of ',...
                    num2str(K),' cannot solve the function using ',...
                    'Newton Raphson Method. Use fzero insted.\n'])
            end
        end
    end

    % fzero method
    if strcmp(method,'fzero')
        tolerance = varargin{1}; iniGuess = varargin{2};
        options = optimset('TolX', tolerance, 'Display', 'off');
        [myimpV,fval,ef,output] = fzero(f,iniGuess,options);
        output.method = 'fzero';output.fval = fval; output.ef = ef; 
        output.output=output;
        % if this method fails, use next method instead.
        if ~exist('myimpV','var')
            if isnan(myimpV)
                method = 'fsolve';
                display(['Warning: the group with strike price of ',...
                    num2str(K),' cannot solve the function using',...
                    ' fzero. Use fsolve insted.\n'])            
            end
        end
    end

    % fsolve method
    if strcmp(method,'fsolve')    
        tolerance = varargin{1}; iniGuess = varargin{2};
        options = optimset('TolX', tolerance,'Display', 'off');
        [myimpV,fval,ef,output] = fsolve(f,iniGuess,options);
        output.method = 'fsolve'; output.fval = fval; output.ef = ef; 
        output.output=output;
        % if this method fails, use next method instead.
        if ~exist('myimpV','var')
            if isnan(myimpV)
                myimpV = 'incremental';
                varargin{3} = 0.0001; varargin{4} = 0.0001;
                display(['Warning: the group with strike price of ',...
                    num2str(K),' cannot solve the function using ',...
                    'fsolve. Use "incremental" method, which is ',...
                    'rough, insted.\n'])            
            end
        end
    end

    % Incremental Method
    if strcmp(method,'incremental')
        tolerance = varargin{1}; iniVola= varargin{2}; %initial guess
        IncreVal = varargin{3};  itermax = 1/iniVola;
        for vola = iniVola:IncreVal:itermax
            delta = f(vola);
            comp = delta;
            if abs(delta) <= tolerance || comp*delta < 0
                myimpV = vola;
                break
            end
        end
        if ~exist('myimpV','var')
            if vola == itermax
                myimpV = NaN;
                disp(['Iteration ended. The estimate is not ',...
                    'closer than ',num2str(IncreVal)])
            else
                myimpV = vola;
            end
        end
    end

    if ~exist('myimpV','var')
        if isnan(myimpV)
            myimpV = NaN;
            display(['Warning: the group with strike price of ',...
                num2str(K), ' have no solution based on gabImpv',...
                ' or the solution is exactly NaN .\n'])            
        end
    end

end


function delta = objfcn(volatility, S0, K, T, r, OptionPrice,div,...
    N, optyp,opsy,flag)
    switch flag
        case 'BS'
            priceEst = gabBSpr(S0, K, T, r, div,volatility,optyp);
        case 'BN'
            priceEst = gabBNpr(S0,K,T,r,volatility,N,optyp,opsy,div);
    end
    delta = OptionPrice - priceEst;
end


