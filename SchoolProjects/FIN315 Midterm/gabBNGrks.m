function bsGreeks_gab=gabBNGrks(S0,K,T,r,div,sigma,N,optyp,opsy,smch,greek,varargin)
%**************************************************************************
% Greeks Calculation
%   Function calculates the greeks for options using binomial model.
% 
%   gabBNGrks(S0,K,T,r,div,sigma,N,optyp,opsy,smch,greek)
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
%   sigma   - annualized volatility (in decimal)
% 
%   N       - the number of steps. (dt=T/N)
% 
%   optyp   - option type +1=call, -1=put
% 
%   opsy    - Euro=0, Amer=1
% 
%   smch    - The small change you apply to calculate first devariatives.
%
%   greek   - which option sensitivity, i.e. Greek is to be calculated
%
%   varargin{1} - The small change you apply to calculate second devariatives,
%             which is gamma here, and bigsmch must be larger than smch.
%
%==========================================================================
% OUTPUTS:
%
%   bsGreek_gab   - The greek value.
% 
%                   
%      
%==========================================================================
% EXAMPLE:
%
%       delta = gabBNGrks(60,50,4/12,0.03,0.018,0.3021,...
%                       100,1,0,0.00001,'delta')
% 
%
%**************************************************************************
    
    % Parameters pre-process
    S0ps = S0; S0ms = S0;    sigps = sigma; sigms = sigma;
    Tps = T; Tms = T;    rps = r; rms = r;
    switch greek
        case 'delta'
            S0ps = S0 + smch;    S0ms = S0 - smch;
        case 'vega'
            sigps = sigma + smch;    sigms = sigma -smch;
        case 'theta'
            Tps = T - smch;    Tms = T + smch;
        case 'rho'
            rps = r + smch;    rms = r - smch;
        case 'gamma'
            bigsmch = varargin{1};
            temp = gabBNGamma(S0,K,T,r,div,sigma,N,optyp,opsy,smch,bigsmch);
    end
    
    %Calculate d values & option price at S0
    bspr_ini = gabBNpr(S0,K,T,r,sigma,N,optyp,opsy,div);

    %Calculate d values & option price at S0+small change, add _ps to
    %variables that change
    bspr_ps = gabBNpr(S0ps,K,Tps,rps,sigps,N,optyp,opsy,div);

    %Calculate d values & option price at S0-small change, add _ms to
    %variables that change
    bspr_ms = gabBNpr(S0ms,K,Tms,rms,sigms,N,optyp,opsy,div);

    %Calculate discreet approximation of delta with S0 plus small change
    delt_ps=(bspr_ps-bspr_ini)/smch;

    %Calculate discreet approximation of delta with S0 minus small change
    delt_ms=(bspr_ms-bspr_ini)/(-1*smch);

    %Calculate the discreet approximation of the delta as the average of
    %delt_ps & delt_ms
    bsGreeks_gab = (delt_ps+delt_ms)/2;
    if exist('temp','var')
        bsGreeks_gab = temp;
    end
 
end
 
function bsGamma_drk=gabBNGamma(S0,K,T,r,div,sigma,N,optyp,opsy,smch,bigsmch)
    %smch - small change used to calculate delta
    %bigsmch - small change (must be larger than smch) used to calculate gamma
    %This part is refered to Dr.K's function.
    %Calculate d values & option price at S0
    %Calculate Delta at S0
    delt_S0=gabBNGrks(S0,K,T,r,div,sigma,N,optyp,opsy,smch,'delta');

    %Calculate d values & option price at S0+small change=(S0+smch), 
    %add _ps to variables that change.
    %Calculate Delta at S0+small change
    delt_S0ps=gabBNGrks(S0+bigsmch,K,T,r,div,sigma,N,optyp,opsy,smch,'delta');

    %Calculate d values & option price at S0-small change, add _ms to
    %variables that change.
    %Calculate Delta at S0-small change
    delt_S0ms=gabBNGrks(S0-bigsmch,K,T,r,div,sigma,N,optyp,opsy,smch,'delta');

    %Calculate discreet approximation of Gamma with delt_S0ps
    gamm_ps=(delt_S0ps-delt_S0)/bigsmch;

    %Calculate discreet approximation of Gamma with delt_S0ms
    gamm_ms=(delt_S0ms-delt_S0)/(-1*bigsmch);

    %Calculate the discreet approximation of the Gamma as the average of
    %gamm_ps & gamm_ms
    bsGamma_drk=(gamm_ps+gamm_ms)/2;
    
%     bsGamma_drk = (delt_S0ps-delt_S0ms)/2*bigsmch;
 
 end