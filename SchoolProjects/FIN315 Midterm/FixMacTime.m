function FixedNum = FixMacTime(ExcelNum)
  %**************************************************************************
% Fix Excel Import Problem For Matlab On Mac System
%     This function is going to fix the import problem about date for
%     Matlab User on mac.
%
%   FixMacTime(ExcelNum)
%
%==========================================================================
% INPUTS:     
%   ExcelNum    - The date number you import from excel without any
%   modification
%
%==========================================================================
% Note:
%     If import datestr to Matlab on OSX from excel, they will be the 
%     following, which is not correct.
%     42328 == '21-Nov-0115'
%     42356 == '19-Dec-0115
%     In excel, they are supposedd to be match respectively as the
%     following:
%     42328 == '20-Nov-2015'
%     42356 == '18-Dec-2015
%==========================================================================
% OUTPUTS:
%
%   FixedNum   - The date number correspond to the excel date.
%   
%==========================================================================
% EXAMPLE:
%
%       realNum = Fixed(42328)
%
%**************************************************************************
   
    dnum = 42328;
    dnum_f = datenum('20-Nov-2015');
    difference = dnum_f - dnum;
    
    FixedNum = ExcelNum + difference;
end

    