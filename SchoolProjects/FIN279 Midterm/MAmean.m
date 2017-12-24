function mu = MAmean(data,n,lambda)

    % UWMAmean(data,n) computes the normal moving average mean of data keeping n numbers.
    % data can be the one like original prices, original volume, log returns, etc.
    row = size(data,1);
    col = size(data,2);
    % creat a matirx mu with same rows an columns as data.
    mu = NaN(row,col);
    
    if nargin == 2
        % fill out mu with the following means.
        for t = n+2:row
            mu(t,:) = mean(data(t-n:t-1,:));
        end    
    end    
    
    % EWMAmean(data,n) computes the exponentially weighted moving average mean of data keeping n numbers.
    % data can be the one like original prices, original volume, log returns, etc.
    if nargin == 3
        lambdaN = lambda.^(0:n-1)';
        lambdaN = repmat(lambdaN,1,col);
        % fill out mu with the following means.
        for t = n+1:row 
            mu(t,:) = (1-lambda) .* sum(lambdaN .* data(t-1:-1:t-n,:)); 
        end
    end
    
end





