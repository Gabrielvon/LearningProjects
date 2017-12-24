
filename <- paste(Secnames[[1]][1],'.csv',sep='')
from <- '2005-12-01'
type='Adjusted'

#####******************Symbol Screening Testing******************#####

ProbTickersBig <- c()
for (j in 1:len.path) {
        sec <- paste(Secnames[[j]][1],'.BigTicksForAll',sep='')
        netsyms <- get(sec)
        stosyms <- get(sec)
        for (sym in netsyms) { 
                msg <- tryCatch({getSymbols(sym, from=from)
                }, warning = function(w) {
                        # len.sym <- length(get(sym))
                        # war <- paste('Warning: len.path',j ,' --- ', sym, ': Got ', len.sym, ' prices', sep='')
                        war <- paste('Warning: len.path',j ,' --- ', sym , sep='')
                        return(war)
                }, error=function(e) {
                        # print(e)
                        print(paste("MY_ERROR:  ",e))
                        # print(paste('Gotta check',sym,sep=' '))
                        err <- paste('Error: len.path',j ,' --- ', sym,sep='')
                        return(err)
                })
                ProbTickersBig <- rbind(ProbTickersBig,msg)
        }
}

ProbTickersSml <- c()
for (j in 1:len.path) {
        sec <- paste(Secnames[[j]][1],'.SmlTicksForAll',sep='')
        netsyms <- get(sec)
        stosyms <- get(sec)
        for (sym in netsyms) { 
                msg <- tryCatch({getSymbols(sym, from=from)
                }, warning = function(w) {
                        # len.sym <- length(get(sym))
                        # war <- paste('Warning: len.path',j ,' --- ', sym, ': Got ', len.sym, ' prices', sep='')
                        war <- paste('Warning: len.path',j ,' --- ', sym , sep='')
                        return(war)
                }, error=function(e) {
                        # print(e)
                        print(paste("MY_ERROR:  ",e))
                        # print(paste('Gotta check',sym,sep=' '))
                        err <- paste('Error: len.path',j ,' --- ', sym,sep='')
                        return(err)
                })
                ProbTickersSml <- rbind(ProbTickersSml,msg)
        }
        
}


print(ProbTickersBig)
print(ProbTickersSml)

        
    