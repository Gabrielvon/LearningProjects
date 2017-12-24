function S = ajGBM(mu,sigma,S0,N,T,dt)

%% this function is based on the GBM_FCN from Dr. K.

%% geometric brownian motion
%
% [S,t] = GBM_fcn(mu,sigma,S0,N,T,dt)
% returns
%       S - matrix of Wiener process paths
%       t - corresponding timebase
% where
%       mu - mean
%       sigma - volatility
%       S0 - intial value of Stock
%       N - number of paths
%       T - stop time
%       dt - timestep
%
% Given mu, sigma dt and S0 we generate random stock path and
% create a histogram of the final prices. We create the return
% series by using the formula:
%
%   S(n+1) = S(n)*exp((mu-sigma^2/2)*dt + sigma*dW*sqrt(dt))
%
% Example
%
%   [StockPaths,Timebase] = GBM_fcn(.5,.4,50,100,2,1/500);
%
% see also
%       randn

%%
M = floor(T/dt); % Number of steps to take

%% Generate the Wiener process
% take the random numbers created in dS and insert into the
% bottom M+1 rows of the S matrix, so that we can use
% cumulative product on S to generate the return paths and
% avoid using a for loop over the rows.

% Generate Wiener process
dW = randn(M,N); 
% Create dS according to equation
dS = exp((mu-sigma^2/2)*dt + sigma*dW*sqrt(dt));

S = S0*ones(M+1,N); % Initialise S matrix

% take the random numbers created in dS and insert into the
% bottom M-1 rows of the S matrix, so that we can use
% cumulative product on S to generate the return paths and
% avoid using a for loop over the rows.
S(2:end,:) = dS;

% Create final paths using cumulative product
S = cumprod(S);


end
