function sigma = EWMAvolatility(data,mu,n,lambda)
    % EWMAvolatility(data,mu,n,lambda) computes the exponentially weighted moving average volatility of data keeping n numbers.
    % here the decay factor is lambda.
    % data can be the one like original prices, original volume, log returns, etc.
    % mu is supposed to the mean used here, like normal mean and weighted average mean.
    
    row = size(data,1);
    col = size(data,2);
   
    % to transform lambda in vector to be in matrix form in case that we use it in bootstrap situation.
    lambdaN = lambda.^(0:n-1)';
    lambdaN = repmat(lambdaN,1,col);
   
    % creat a matirx mu with same rows an columns as data.
    var = NaN(row,col);
    
    % fill out mu with the following means.
    for t = n+2:row
        var(t,:) = (1-lambda) .* sum(lambdaN.*(data(t-1:-1:t-n,:)-repmat(mu(t,:),n,1)).^2);
    end
    sigma = sqrt(var);
end
    