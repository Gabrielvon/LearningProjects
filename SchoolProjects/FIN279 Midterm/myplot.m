function [OutBoundsDates,OutData] = myplot(dates,data2,ci,plottype)
    
    switch plottype
        case 1
            hold off
            plot(dates,data2);
            hold on          
%             plot(dates,repmat(ci(1),1,size(dates,1)),'r-')
            plot(dates,ci(1),'r--')
%             plot(dates,repmat(ci(2),1,size(dates,1)),'r-')  
            plot(dates,ci(2),'r--')
            datetick('x','yy')
            xlabel('Date')

        case 2
            indices = find(data2>ci(2)|data2<ci(1));
            OutBoundsDates = dates(indices);
            OutData = data2(indices);
            hold on
            plot(OutBoundsDates,OutData,'g+')
    end
      
end

    
    
    
    
    
   
