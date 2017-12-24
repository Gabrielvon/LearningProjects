function bsgreeks_gab=gabBSGrks(S0,K,T,r,div,sigma,optyp,greek)
  %**************************************************************************
% Greeks Calculation
%   Function calculates the greeks for options, only for european style 
%   using Black-Scholes model.
% 
%   gabBSGrks(S0,K,T,r,div,sigma,optyp,greek)
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
%   greek   - which option sensitivity, i.e. Greek is to be calculated
%
%==========================================================================
% OUTPUTS:
%
%   bsGreeks_gab   - The greek value.
%   
%                   
%      
%==========================================================================
% EXAMPLE:
%
%       delta = gabBNGrks(60,50,4/12,0.03,0.018,0.3021,...
%                       1,0,'delta')
%
%**************************************************************************

    %Calculate d values
    d1=(log(S0/K)+((r-div+((sigma^2)/2)).*T))/(sigma.*sqrt(T));
    d2=d1-(sigma.*sqrt(T));

    %Calculate Option Sensitivities
    bsDelta=exp(-div.*T).*(optyp.*normcdf(optyp.*d1));
    bsVega=S0.*exp(-div.*T).*normpdf(d1).*sqrt(T);
    bsTheta = -(S0.*exp(-div.*T).*normpdf(d1).*sigma/(2.*sqrt(T))) ...
        - optyp.*r.*K.*exp(-r.*T).*normcdf(optyp.*d2) ...
        + optyp.*div.*S0.*exp(-div.*T).*normcdf(optyp.*d1);
    bsRho=(K.*T.*exp(-r.*T)).*(optyp.*normcdf(optyp.*d2));
    bsGamma=exp(-div.*T).*(normpdf(d1)/(S0.*sigma.*sqrt(T)));
    bsVanna = bsVega/S0 .* (1-d1/(sigma.*sqrt(T)));
    bsCharm = optyp.*div.*exp(-div.*T).*normcdf(optyp.*d1) ...
        - exp(-div.*T).*normpdf(d1).*(2.*(r-div).*sqrt(T)-d2.*...
        sigma)/(2.*T.*sigma);
    bsSpeed = -bsGamma/S0 .* (d1/(sigma.*sqrt(T))+1);
    bsZomma = bsGamma.*((d1.*d2-1)/sigma);
    bsColor = -exp(-div.*T) .* normpdf(d1)/(2.*S0.*T.*sigma.*...
        sqrt(T)).* (2.*div.*T + 1 + d1 .* (2.*(r-div).*sqrt(T)-...
        d2.*sigma)/sigma);
    bsVeta = S0 .* exp(-div.*T) .* normpdf(d1) .* sqrt(T).*(div +...
        (r-div).*d1/(sigma.*sqrt(T)) - (1+d1.*d2)/2.*T);
    bsVomma = bsVega .* d1 .* d2 / sigma;
    bsUltima = -bsVega/sigma^2 .* (d1.*d2.*(1-d1.*d2)+d1^2+d2^2);
    
    %Output the Greek letter choices based on input grk
    grk ={'delta','gamma','vega','theta','rho','vanna','charm',...
        'speed','zomma','color','veta','vomma','ultima'};
    grkval = [bsDelta,bsGamma,bsVega,bsTheta,bsRho,bsVanna,...
        bsCharm,bsSpeed,bsZomma,bsColor,bsVeta,bsVomma,bsUltima];    
    ext = strcmp(greek,grk);
    bsgreeks_gab = grkval(ext);
    
end
