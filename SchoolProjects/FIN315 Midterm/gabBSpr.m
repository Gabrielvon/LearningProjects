  function price = gabBSpr(S0, K, T, r, div, sigma, optyp)
  %**************************************************************************
% Black-Scholes Option Pricing 
%   Function calculates the price of a call or put option using
%   Black-Scholes analytical formula
%
%   gabBSpr(S0, K, T, r, div, sigma, optyp)
%
%==========================================================================
% INPUTS:     
%   S0      - Initial price of the underlying asset
% 
%   K       - Strike price of the option
% 
%   T       - Option's maturity (fraction of year, i.e. in decimal)
% 
%   r       - risk free rate-in annual terms (in decimal)
% 
%   div     - annualized dividend yield (in decimal)
% 
%   sigma   - annualized volatility (in decimal)
% 
%   optyp   - option type +1=call, -1=put
%
%
%==========================================================================
% OUTPUTS:
%
%   price   - The option price from blach-scholes model
%   
%                   
%      
%==========================================================================
% EXAMPLE:
%
%       price = gabBSpr(60,50,4/12,0.03,0.018,0.0037,1)
%
%**************************************************************************

    %Calculate d values
    d1=(log(S0./K)+((r-div+((sigma.^2)/2)).*T))./(sigma.*sqrt(T));
    d2=d1-(sigma.*sqrt(T));

    %Calculate Black-Scholes Option Price
    price=optyp.*((S0.*exp(-div.*T).*normcdf(optyp.*d1))-...
        (K.*exp(-r.*T).*normcdf(optyp.*d2)));
   
end
