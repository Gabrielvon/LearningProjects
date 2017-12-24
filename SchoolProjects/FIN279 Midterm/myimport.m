function [dates,price,volume] = myimport(stock,filename,sheetname,columnsum)
    % myimport(stock,filename,sheetname,columnsum) imports the stock data in the sheet of excel. And the sheet has columnsum, which is required to input in this function.
    % stock refers to the complete name of stock in excel.
    % filename refers to the name of excel file.
    % sheetname refers to the name of sheet in the excel file you want to use.
    % columnsum refers to the total columns in the sheet.
    
% import the rawdata.
[rawdata,text] = xlsread(filename,sheetname);

% process the rawdata.
for i = 1:3:columnsum;
    tf = strcmp(text(1,i), stock); % Compare text(1,i) and stock.
    if tf == true;      % loop until we find the stock.
        mydata = rawdata(:,i:i+2);
    end
end

dates = mydata(:,1);
price = mydata(:,2);
volume = mydata(:,3);


end
