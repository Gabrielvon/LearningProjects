setwd('/Users/gabrielfeng/Documents/R\ directory/Fin\ 285')
getdata <- function (yahoo.symbols,stosyms,filename,from,to,datatype) {
        library(quantmod)
        # symbols <- symbols[symbols %in% ls()]
        for (sym in yahoo.symbols) { getSymbols(sym, from=from, to=to)}
        # symbols <- stosyms
        
        data <- xts()
        for(i in seq_along(stosyms)) {
                colname <- c(paste(stosyms[i], datatype, sep="."))
                cat(ls(),'\n')
                cat(colname,'\n')
                data <- merge(data, get(stosyms[i])[,colname])
        }
        colnames(data) <- stosyms
        index(data)=as.Date(index(data))
        # write.csv(data,filename)
        
        return(data)
}

# Columne name example: DJI.Close, DJI.Volume, DJI.Adjusted
# Function Example

#####************Download Index from Yahoo Finance************#####
yahoo.symbols.ind <- c("^DJI","^GSPC","^IXIC",'^DJUSS','^W5KLCV')
stosyms.ind <- c("DJI","GSPC","IXIC","DJUSS","W5KLCV")
filename.ind <- 'MktIndices.csv'
from <- '2005-12-01'; to <- '2015-12-01'
type <- 'Adjusted'
indices <- getdata(yahoo.symbols.ind,stosyms.ind,filename.ind,from,to,type)

rem <- ls()
ind <- grepl('indices',rem)
rm(list=c(rem[!ind]))
rm(ind,rem)
save.image('/Users/gabrielfeng/Documents/R\ directory/Fin\ 285/SelectedIndices.RData')
# write.csv(indices,'/Users/gabrielfeng/Documents/R\ directory/Fin\ 285/SelectedIndices.csv')



