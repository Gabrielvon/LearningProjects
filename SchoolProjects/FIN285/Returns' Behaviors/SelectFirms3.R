load('/Users/gabrielfeng/Documents/R\ directory/Fin\ 285/initials.RData')
load('/Users/gabrielfeng/Documents/R\ directory/Fin\ 285/AllFirms.RData')
load('/Users/gabrielfeng/Documents/R\ directory/Fin\ 285/Allyears.RData')
load('/Users/gabrielfeng/Documents/R\ directory/Fin\ 285/AllSectors.RData')
library(quantmod)
library(zoo)
library(xts)
from <- '2005-12-01'
to <- '2015-12-01'
ifsort <- 'TRUE'

#####******************Screen Available Stocks ******************#####

gabSelected <- function(mkttype){
        #datatype: 'Adjusted' or' Volume
        #sort: TRUE for 'from big to small'; FALSE for 'from small to big'
        #outputname: name for .RData
        
        MsgList <- list()
        AdjList <- list()
        VolList <- list()
        getSymbols('AAPL',from=from,to=to)
        for (year in sn) {
                syear <- DataYearlyForAllSec[[year]]
                MsgBox <- zoo()
                AdjMatYearly <- zoo(order.by=index(AAPL))
                VolMatYearly <- zoo(order.by=index(AAPL))
                for (col in Secnames) {
                        dada <- syear[!is.na(syear[,col]),col]
                        MsgVec <- c()
                        count <- 0
                        # sortorder <- ifelse(ifsort, 1:length(dada),length(dada):1)
                        sortorder <- switch(mkttype, Big=1:length(dada),Small=length(dada):1)
                        # if (ifsort) {
                        #         sortorder <- 1:length(dada)
                        # } else {
                        #         sortorder <- length(dada):1
                        # }
                        for (rowi in sortorder) {
                                sym <- dada[rowi]
                                msg <- try(getSymbols(sym,from=from,to=to),silent=TRUE)
                                if (grepl('Error',msg)) {
                                        msg <- paste(sym,'---',msg)
                                } else {
                                        DaVec <- get(sym)
                                        rn <- index(DaVec)
                                        iBegin <- paste(as.character(as.numeric(year)),'-12',sep='')
                                        iEnd <- paste(as.character(as.numeric(year)+1),'-12',sep='')
                                        d1 <- sum(c(grepl(iBegin,rn)))
                                        d2 <- sum(grepl(iEnd,rn))
                                        tf <- (d1==0) || (d2==0)
                                        if (year=='2015') tf <- FALSE
                                        if ( tf ) {
                                                msg <- paste(sym, '--- NA values in responding year and stock' )
                                        } else {
                                                msg <- paste(sym, '--- Fetched' )
                                                Adj <- DaVec[,paste(sym,'.Adjusted',sep='')]
                                                colnames(Adj) <- strsplit(sym,'[.]')[1]
                                                AdjMatYearly <- merge.xts(AdjMatYearly,Adj)
                                                Vol <- DaVec[,paste(sym,'.Volume',sep='')]
                                                colnames(Vol) <- strsplit(sym,'[.]')[1]
                                                VolMatYearly <- merge.xts(VolMatYearly,Vol)
                                                count = count + 1  
                                        }
                                        
                                }
                                cat('Fetcing',mkttype,'Cap -----',year,col,rowi,msg,'\n')
                                MsgVec <- c(MsgVec,msg)
                                if (count == 10) break
                        }
                        MsgBox <- merge(MsgBox,MsgVec)
                }
                MsgBox <- as.data.frame(MsgBox,stringAsFactors=FALSE)
                colnames(MsgBox) <- Secnames
                MsgList[[year]] <- MsgBox
                AdjMatYearly <- as.data.frame(AdjMatYearly,stringAsFactors=FALSE)
                AdjList[[year]] <- AdjMatYearly
                VolMatYearly <- as.data.frame(VolMatYearly,stringAsFactors=FALSE)
                VolList[[year]] <- VolMatYearly
        }
        return(list(AdjList,VolList,MsgList))
        # assign(outputname,DaList)
        # pathname <- paste("~/Documents/R directory/Fin 285/",outputname,".RData")
        # save.image(pathname)
}

Big <- gabSelected('Big')
# rem <- ls()
# ind <- grepl('Big',rem) | grepl('Small',rem) | grepl('gabSelected',rem)
# rm(list=c(rem[!ind]))
# rm(ind,rem)
# save.image("~/Documents/R directory/Fin 285/Selected10Firms.RData")

Small <- gabSelected('Small')
rem <- ls()
ind <- grepl('Big',rem) | grepl('Small',rem) | grepl('gabSelected',rem)
rm(list=c(rem[!ind]))
rm(ind,rem)
# save.image("~/Documents/R directory/Fin 285/Selected10Firms.RData")
        
