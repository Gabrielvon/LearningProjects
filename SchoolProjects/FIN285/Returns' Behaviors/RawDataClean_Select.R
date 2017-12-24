setwd('/Users/gabrielfeng/Documents/R\ directory/Fin\ 285')

#####******************Clean Data from bloomberg******************#####
datapath <- '/Users/gabrielfeng/Documents/R\ directory/Fin\ 285/Raw\ Data'
filepaths <-  list.files(path=datapath, pattern='^[a-zA-Z]',full.names = TRUE)
filenames <- list.files(path=datapath,pattern='^[a-zA-Z]',full.names = FALSE)
Secnames <- as.array(strsplit(filenames,'[.]'))
len.path <- length(filepaths)
sn <- as.character(2015:2005)
len.sn <- length(sn)

library(openxlsx)
library(zoo)
gabReader <- function(fpath,snum) {
        da <- read.xlsx(xlsxFile=fpath,sheet=snum,startRow=5,cols=c(1,3),colNames = FALSE)
        da <- as.data.frame(da[complete.cases(da),][,1])
        colnames(da) <- as.character(snum)
        return(da)
}
# BM <- gabReader(filepaths[1],1)

for (j in 1:len.path){
        tick.da <- zoo()
        tick.list <- sapply(sn,gabReader,fpath=filepaths[j])
        for (i in 1:len.sn) {
                tick.da <- merge(tick.da,as.data.frame(tick.list[[i]]))
        }
        tick <- as.data.frame(tick.da)
        name <- unlist(strsplit(filenames[[j]],'[.]'))[1]
        assign(name,tick)
}

rem <- ls()

#####***************Select the biggest and smallest MktCap firms**************#####
load('/Users/gabrielfeng/Documents/R\ directory/Fin\ 285/AllFirms.RData')
gabVecTick <- function(char.vector) {
        strings <- strsplit(as.character(char.vector,' '),' ')
        tickers <- unlist(lapply(strings,function(x) x[1]))
        return(tickers)
}

# Big cap
for (j in 1:len.path) {
        Secda <- get(Secnames[[j]][1])
        Secda.comp <- Secda[complete.cases(Secda),]
        Secbig <- as.data.frame(Secda.comp[1:10,])
        Secbig.tick <- apply(Secbig,2,gabVecTick)
        colnames(Secbig) <- sn[1:len.sn]
        Secbig.tick.uni <- unique(as.vector(unlist(Secbig.tick)))
        SecTickNm <- paste(Secnames[[j]][1],'.BigTicksForAll',sep='')
        print(SecTickNm)
        assign(SecTickNm,Secbig.tick.uni)
}

# Small cap
for (j in 1:len.path) {
        Secda <- get(Secnames[[j]][1])
        Secda.comp <- Secda[complete.cases(Secda),]
        lastnums <- (dim(Secda.comp)[1]-9) : dim(Secda.comp)[1]
        Secsml <- as.data.frame(Secda.comp[lastnums,])
        Secsml.tick <- apply(Secsml,2,gabVecTick)
        colnames(Secsml) <- sn[1:len.sn]
        Secsml.tick.uni <- unique(as.vector(unlist(Secsml.tick)))
        SecTickNm <- paste(Secnames[[j]][1],'.SmlTicksForAll',sep='')
        assign(SecTickNm,Secsml.tick.uni)
}

rem <- ls()
rm(list=rem[!grepl('TicksForAll',rem)])
# rm(list=ls(pattern='TicksForAll'))
save.image('/Users/gabrielfeng/Documents/R\ directory/Fin\ 285/TicksForALL.RData')
