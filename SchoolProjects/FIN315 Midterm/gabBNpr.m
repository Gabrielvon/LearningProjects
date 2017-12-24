function [price, stp, lattice] = gabBNpr(S0,K,T,r,sigma,N,opty,opsy,div)
%**************************************************************************
% Binomial Option Pricing 
%   Function calculates the price of a call/put,european/american option
%   using binomial tree model.
%
%   gabBNpr(S0,K,T,r,sigma,N,opty,opsy,div)
%
%==========================================================================
% INPUTS:     
%   S0      - Initial price of the underlying asset
% 
%   K       - Strike price of the option
% 
%   T       - Option's maturity (fraction of year, i.e. in decimal)
% 
%   r       - Risk free rate-in annual terms (in decimal)
% 
%   sigma   - Annualized volatility (in decimal)
% 
%   N       - The number of steps. (dt=T/N)
% 
%   opty   - Option type +1=call, -1=put
% 
%   opsy    - Option style Euro=0, Amer=1
% 
%   div     - Annualized dividend yield (in decimal)
%
%
%==========================================================================
% OUTPUTS:
%
%   price   - The option price
%   
%   stp     - The binomial stock price tree
%   
%   lattice - The binomial option price tree
%                   
%      
%==========================================================================
% EXAMPLE:
%
%       [price, ~, ~] = gabBNpr(60,50,4/12,0.03,0.3021,100,1,0,0.018)
%       [price, stp, lattice] = ...
%                       gabBNpr(60,50,4/12,0.03,0.3021,100,1,0,0.018)
%
%**************************************************************************

    
    deltaT = T./N;
    u=exp(sigma .* sqrt(deltaT));
    d=1./u;
    %Probability of a up movement
    p=(exp((r-div).*deltaT) - d)./(u-d);
    
    stp = zeros(N,N+1);
    stp(1,1) = S0;
    % nchoosek could be useful.
    for j=1:N     
        for i=1:j+1
            stp(i,j+1)=S0.*u.^(j+1-i).*d.^(i-1);        
        end
    end 
    
    % Generate option price at the last steps
    lattice = zeros(N+1,N+1);
    for i=0:N
        lattice(i+1,N+1)=max(0 , opty.*((S0.*(u.^(N-i)).*(d.^i)) - K));
    end
    
    % Iterate option price at the former steps from last steps
    for j=N-1:-1:0
        for i=0:j
            % Present Value of Expected Payoffs
            lattice(i+1,j+1) = exp(-r.*deltaT) .* ...
                (p .* lattice(i+1,j+2) + (1-p) .* lattice(i+2,j+2)); 
            % Potential Early Exercise Payoffs
            exVal = opsy .* max(opty.*(stp(i+1,j+1)-K),0);
            lattice(i+1,j+1) = max(exVal,lattice(i+1,j+1));
        end   
    end
    
    % The present value of option
    price = lattice(1,1);
    
end