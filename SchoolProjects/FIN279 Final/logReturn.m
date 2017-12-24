function logReturn = logReturn(price)
    % logReturn(price) computes the log return of price.
    % price refer to the stock volume you want to analyze.
    logReturn = log(price(2:end,:)./price(1:end-1,:));
 
    %concatenate NaN to the result to make it have same row and column as price.
    row = size(price,1)-size(logReturn,1);
    col = size(price,2);
    logReturn = [NaN(row,col);logReturn];

    
end