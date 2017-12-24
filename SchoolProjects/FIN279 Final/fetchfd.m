function fd = fetchfd(originaldates,year,month)

%% Decription
% this function is used when the dates are not consecutive, like when we
% are dealing with trading days.

%% Instruction for the fuction
% fetchfd() returns the index of first trading day in specific 
% year or month.
% originaldates is the dates you need fetch the year from. The format 
% should be number. 
% year and month are the first days of those you want.

%% Example
% >> [fd] = fetchfd([731217:734869],2011,1)
% >> fd =
%           3288


%%

%% consider the possibility of that we only need the firsty trading in a year.
if nargin < 3
    month = 1;
end

%% fetch the index
for i = 1:4 
    tmpnum = datenum(year,month,i);
    tmpind = find(originaldates==tmpnum);
    if ~isempty(tmpind)
        fd = tmpind;
        break
    end
end
    