function volumeChange = volumeChange(volume)
    % volumeChange(volume) computes the change in volume.
    % volume refer to the stock volume you want to analyze.
    volumeChange = volume(2:end,:)-volume(1:end-1,:);
    
    %concatenate NaNs to the result to make it have same row and column as price.
    row = size(volume,1)-size(volumeChange,1);
    col = size(volume,2);
    volumeChange = [NaN(row,col);volumeChange];
end