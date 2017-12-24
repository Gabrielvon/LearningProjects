load("~/Documents/R directory/Fin 285/Selected10Firms.RData")
load("~/Documents/R directory/Fin 285/SelectedSmlFirms.RData")
load('/Users/gabrielfeng/Documents/R\ directory/Fin\ 285/initials.RData')
load('/Users/gabrielfeng/Documents/R\ directory/Fin\ 285/SelectedIndices.RData')
load('/Users/gabrielfeng/Documents/R\ directory/Fin\ 285/EventDates.RData')

library(zoo)
library(MTS)
library(quantmod)
#####******************Extract prices For Each Event Window Years******************#####
# Big.p <- Big[[1]]
Msg.big <- Big[[3]]
# Msg.small <- Small[[3]]
Big.p <- Small[[1]]
BigCY.p<- list() # create a list to store data of prices of stocks with big cap for each year.
for (year in sn[-1]) {
        theyear <- as.xts(Big.p[[year]])
        idx <- index(theyear)
        if (year=='2005') {
                iBegin <- paste(as.character(as.numeric(year)),'-12',sep='')
                iEnd <- paste(as.character(as.numeric(year)+1),'-12',sep='')
                idx <- grep(iBegin,idx)[1]:grep(iEnd,idx)[1]
        } else {
                iBegin <- paste(as.character(as.numeric(year)),'-11',sep='')
                iEnd <- paste(as.character(as.numeric(year)+1),'-12',sep='')
                idx <- grep(iBegin,idx)[1]:grep(iEnd,idx)[1]
        }
        
        theyear <- theyear[idx,]
        rownames(theyear) <- idx[idx]
        BigCY.p[[year]] <- theyear
}



#####******************Eql-weighted TheBigCap and its Return******************#####
# Calculate daily return(dRet)
gabRet <- function(x) {
        len <- length(x)
        dRet <- log(x[-1]/x[-len])
        return(dRet)
}

#########################?????????????????????????????????????
# Method 1 
dRet <- list()
TheBigCap.ret1 <- c()
for (year in sn[-1]) {
        dat <- as.xts(BigCY.p[[year]])
        dRet[[year]] <- apply(dat,2,gabRet)
        temp <- as.xts(apply(dRet[[year]],1,mean)) # eql-weighted return
        TheBigCap.ret1 <- rbind.xts(TheBigCap.ret1,temp)
}
#########################?????????????????????????????????????
# # Method 2
# # TheBigCap based on only stock prices of selected firms.
# TheBigCap <- c() # self-defined and created BIG INDEX 100 (Price basics).
# for (yr in sn[-1]) {
#         # cat(yr,'\n')
#         da.yr <- BigCY.p[[yr]]
#         da.vec <- as.xts(apply(da.yr,1,mean))
#         TheBigCap <- rbind.xts(TheBigCap,da.vec)
# }
# TheBigCap.ret2 <- apply(TheBigCap,2,gabRet)
#         
# TheBigCap.ret <- TheBigCap.ret2
#########################?????????????????????????????????????

indices <- indices.norm
TBC.ret <- na.omit(TheBigCap.ret)
colnames(TBC.ret) <- 'TBC'
IDX.ret <- as.xts(na.omit(apply(indices,2,gabRet)))
colnames(IDX.ret) <- colnames(indices)
# TBC.cum <- cumsum(TBC.ret)
# IDX.cum <- cumsum(IDX.ret)

#####******************AR, CAR, AAR and T-test******************#####
gabAR <- function (ts.individual,ts.market) {
        coln1 <- colnames(ts.individual); coln2 <- colnames(ts.market)
        obj.name <- paste(coln1,'~',coln2,sep='')
        vs <- na.omit(merge.xts(ts.individual,ts.market))
        vs.lm <- lm(substitute(y ~ x, list(y=as.name(coln1),x=as.name(coln2))), data = vs)
        vs.lm.summary <- summary(vs.lm)
        
        AR.vs <- vs[,1] - (vs.lm$coefficients[1] + vs.lm$coefficients[2]*vs[,2])
        CAR.vs <- cumsum(AR.vs)
        AAR.vs <- CAR.vs / seq(nrow(CAR.vs))
        ttest.vs <- t.test(vs[, 1],vs[, 2])
        AR.ttest <- AR.vs / as.numeric(ttest.vs$statistic)        
        
        results <- merge.xts(AR.vs,CAR.vs,AAR.vs,AR.ttest)
        colnames(results) <- c('AR','CAR','AAR','T-test')
        mylist <- list(results,vs.lm.summary,ttest.vs)
        names(mylist) <- c('ARCA','lm.summary','ttest')
        return(mylist)
}

# TBCvsDJI <- gabAR(TBC.ret,IDX.ret[,1])
# TBCvsGSPC <- gabAR(TBC.ret,IDX.ret[,2])
# TBCvsNYSE <- gabAR(TBC.ret,IDX.ret[,3])
# TBCvsDJUSS <- gabAR(TBC.ret,IDX.ret[,4])

TBC.AR <- list()
for (obj in colnames(IDX.ret)) {
        TBC.AR[[obj]] <- gabAR(TBC.ret,IDX.ret[,obj])
}

# Reshape and extract the AR,
idx <- index(TBC.AR[['DJI']][['ARCA']][,'AR']);
AR <- zoo(order.by = idx); CAR <- zoo(order.by = idx)
AAR <- zoo(order.by = idx); ttest <- zoo(order.by = idx)
for (i in seq(ncol(IDX.ret))) {
        AR <- cbind.xts(AR,TBC.AR[[i]][['ARCA']][,'AR'])
        CAR <- cbind.xts(CAR,TBC.AR[[i]][['ARCA']][,'CAR'])
        AAR <- cbind.xts(AAR,TBC.AR[[i]][['ARCA']][,'AAR'])
        ttest <- cbind.xts(ttest,TBC.AR[[i]][['ARCA']][,'T-test'])
}
colnames(AR) <- paste(colnames(IDX.ret),c('.AR'),sep='')
colnames(CAR) <- paste(colnames(IDX.ret),c('.CAR'),sep='')
colnames(AAR) <- paste(colnames(IDX.ret),c('.AAR'),sep='')
colnames(ttest) <- paste(colnames(IDX.ret),c('.T-test'),sep='')

#####******************Compare Each Event Window Years******************#####
gabAvaiNum <- function (eD, daydiff, index, by) {
        eD <- as.Date(eD)
        eD.d <- eD+daydiff
        if (daydiff<=0) {
                eD.seq <- seq(eD.d,eD,by=by) 
        } else {
                eD.seq <- seq(eD,eD.d,by=by)
        }
        avaiDnum <- unlist(sapply(eD.seq,grep,index))
        return(avaiDnum) # this is the index of index
}


idx <- index(AR); by<-'1 day';
ew1 <- -10; ew2 <- 10;
for (j in seq(nrow(mDates))) {
        eD1 <- as.Date(mDates[j,1])
        eD2 <- as.Date(mDates[j,2])
        eD1.idx <- gabAvaiNum(eD1,ew1, idx,by)
        eD2.idx <- gabAvaiNum(eD2,ew2, idx,by)
        EW <- unique(c(eD1.idx,eD2.idx))
        
        if (length(EW) >= 2){
                par(mfrow=c(3,1))
                
                ylim <- c(min(AR[EW,]),max(AR[EW,]))
                for (i in seq(ncol(AR))) {
                        graphics::plot(AR[EW,i],lty=i,main='',ylim=ylim)
                        par(new=TRUE)
                }
                title(main='AR', xlab='Event Dates', ylab='Abnormal Returns')
                legend('bottomright',legend=colnames(AR),lty=1:ncol(AR),bg='white',bty='n')
                par(new=FALSE)
                
                ylim <- c(min(CAR[EW,]),max(CAR[EW,]))
                for (i in seq(ncol(CAR))) {
                        graphics::plot(CAR[EW,i],lty=i,main='',ylim=ylim)
                        par(new=TRUE)
                }
                title(main='CAR', xlab='Event Dates', ylab='Cummulative Abnormal Returns')
                legend('bottomright',legend=colnames(CAR),lty=1:ncol(CAR),bg='white',bty='n')
                par(new=FALSE)
                
                ylim <- c(min(AAR[EW,]),max(AAR[EW,]))
                for (i in seq(ncol(AAR))) {
                        graphics::plot(AAR[EW,i],lty=i,main='',ylim=ylim)
                        par(new=TRUE)
                }
                title(main='AAR', xlab='Event Dates', ylab='Average Abnormal Returns')
                legend('bottomright',legend=colnames(AAR),lty=1:ncol(AAR),bg='white',bty='n')
                par(new=FALSE)
                
                msg <- "Graph completed"
                
        } else {
                msg <- "Error: Got too many NAs, no graphs generated"
        }
        

        
        pt <- paste('ARCR','-',as.character(eD1),'to',as.character(eD2),'---', msg,sep=' ')
        cat(pt,'\n')
}


#####******************Eql-weighted Portfolio For Each Event Window Years******************#####
# # Create matrix of weights
# library(xts)
# dRet.wted <- list()
# for (year in sn[-1]) {
#         colret <- dim(dRet[[year]])[2]
#         rowret <- dim(dRet[[year]])[1]
#         wt <- rep(1/colret,100)
#         wt <- matrix(rep(wt,rowret),nrow=rowret)
#         temp <- as.xts(apply(wt*dRet[[year]],1,sum))
#         # rownames(temp) <- rownames(dRet[[year]])
#         dRet.wted[[year]] <- temp
# }










