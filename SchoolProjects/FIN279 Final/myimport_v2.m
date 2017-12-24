function [mydata,rawdata,text] = myimport_v2(filename,sheetname,varargin)
    % myimport() imports the assets' data in the sheet of excel.
    % varargin refers to each of the complete name of assets in excel. 
    % In our case, they are on first line.
    % filename refers to the name of excel file.
    % sheetname refers to the name of sheet in the excel file you want 
    % to use.
    
% Import the rawdata.
[rawdata,text] = xlsread(filename,sheetname);

% Fetch the data we need
if nargin > 2
    col = size(text,2);
    %The number of columns of data we need to import.
    nVarargs = length(varargin); 
    mydata = NaN(size(rawdata,1),nVarargs);
    for i = 1:col;
        for j = 1:nVarargs
            %Compare text(1,i) and the asset's name.
            tf = strcmp(text(1,i), varargin{j}); 
            if tf == true;      
                mydata(:,j) = rawdata(:,i);
            end
        end
        % Loop until we find the asset.
        if sum(double(~isnan(mydata(:,nVarargs)))) > 0 
            break 
        end    
    end
    % A bit correction for apple Dates. the following two lines will
    % still work in windows.
    fdate = rawdata(:,1);
    Dates = fdate+datenum(2002,1,1)-fdate(1);
    mydata = [Dates, mydata];
end



