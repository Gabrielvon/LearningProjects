#####******************Volatility of Price in Each Event Windows******************#####

idx <- index(AR); by<-'1 day';
ew1 <- -10; ew2 <- 10;
price.sd <- data.frame(row.names = 2006:2015); 
return.sd <- data.frame(row.names = 2006:2015)
for (j in seq(nrow(mDates))) {
        eD1 <- as.Date(mDates[j,1])
        eD2 <- as.Date(mDates[j,2])
        eD1.idx <- gabAvaiNum(eD1,ew1, idx,by)
        eD2.idx <- gabAvaiNum(eD2,ew2, idx,by)
        EW <- unique(c(eD1.idx,eD2.idx))
        
        p.sd <- data.frame(sd(na.omit(TheBigCap)[EW,]),sd(na.omit(indices[,1])[EW,]))
        price.sd <- rbind(price.sd,p.sd)
        r.sd <- data.frame(sd(na.omit(TheBigCap.ret1)[EW,]),sd(na.omit(TheBigCap.ret2)[EW,]),sd(na.omit(IDX.ret)[EW,]))
        return.sd <- rbind(return.sd,r.sd)
        
        pt <- paste('Got','-',as.character(eD1),'to',as.character(eD2),sep=' ')
        cat(pt,'\n')
}
colnames(price.sd) <- c('TBC.p.sd','IDX.p.sd')
colnames(return.sd) <- c('TBC.ret1.sd','TBC.ret2.sd','IDX.ret.sd')

# EW period
c(max(price.sd[,2]),min(price.sd[,2]))
quantile(price.sd[,2],  probs = c(0.75,0.5,0.25),na.rm=TRUE)
c(max(return.sd[,2]),min(return.sd[,2]))
quantile(return.sd[,2],  probs = c(0.75,0.5,0.25),na.rm=TRUE)
c(max(return.sd[,3]),min(return.sd[,3]))
quantile(return.sd[,3],  probs = c(0.75,0.5,0.25),na.rm=TRUE)


# Entire period
gabRollsd <- function (x) sd(na.omit(x))
tbc.p.sd <- rollapply(TheBigCap,10,gabRollsd)
c(max(tbc.p.sd,na.rm=TRUE),min(tbc.p.sd,na.rm=TRUE))
quantile(tbc.p.sd,  probs = c(0.75,0.5,0.25),na.rm=TRUE)

tbc.r1.sd <- rollapply(TheBigCap.ret1,10,gabRollsd)
c(max(tbc.r1.sd,na.rm=TRUE),min(tbc.r1.sd,na.rm=TRUE))
quantile(tbc.r1.sd,  probs = c(0.75,0.5,0.25),na.rm=TRUE)

tbc.r2.sd <- rollapply(TheBigCap.ret2,10,gabRollsd)
c(max(tbc.r2.sd,na.rm=TRUE),min(tbc.r1.sd,na.rm=TRUE))
quantile(tbc.r2.sd,  probs = c(0.75,0.5,0.25),na.rm=TRUE)



#####******************Volatility of Volume in Each Event Windows******************#####

Big.v <- Big[[2]]
BigCY.v<- list() # create a list to store data of prices of stocks with big cap for each year.
for (year in sn[-1]) {
        theyear <- as.xts(Big.v[[year]])
        idx <- index(theyear)
        iBegin <- paste(as.character(as.numeric(year)),'-12',sep='')
        iEnd <- paste(as.character(as.numeric(year)+1),'-12',sep='')
        idx <- grep(iBegin,idx)[1]:grep(iEnd,idx)[1]
        theyear <- theyear[idx,]
        rownames(theyear) <- idx[idx]
        BigCY.v[[year]] <- theyear
}

TBC.vol <- c() # self-defined and created BIG INDEX 100 (Volume basics).
for (yr in sn[-1]) {
        # cat(yr,'\n')
        da.yr <- BigCY.v[[yr]]
        da.vec <- as.xts(apply(da.yr,1,mean))
        TBC.vol <- rbind.xts(TBC.vol,da.vec)
}

idx <- index(AR); by<-'1 day';
ew1 <- -10; ew2 <- 10;
volume.sd <- data.frame(row.names = 2006:2015);
for (j in seq(nrow(mDates))) {
        eD1 <- as.Date(mDates[j,1])
        eD2 <- as.Date(mDates[j,2])
        eD1.idx <- gabAvaiNum(eD1,ew1, idx,by)
        eD2.idx <- gabAvaiNum(eD2,ew2, idx,by)
        EW <- unique(c(eD1.idx,eD2.idx))
        
        v.sd <- data.frame(sd(na.omit(TBC.vol)[EW,]))
        volume.sd <- rbind(volume.sd,v.sd)
        
        pt <- paste('Got',as.character(eD1),'to',as.character(eD2),sep=' ')
        cat(pt,'\n')
}
colnames(volume.sd) <- c('Volume.sd')

# EW period
c(max(volume.sd,na.rm=TRUE),min(volume.sd,na.rm=TRUE))/1000
quantile(volume.sd,  probs = c(0.75,0.5,0.25),na.rm=TRUE)/1000

# Entire period
tbc.v.sd <- rollapply(TBC.vol,10,gabRollsd)/
c(max(tbc.v.sd,na.rm=TRUE),min(tbc.v.sd,na.rm=TRUE))/1000
quantile(tbc.v.sd,  probs = c(0.75,0.5,0.25),na.rm=TRUE)/1000

