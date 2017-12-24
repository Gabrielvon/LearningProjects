library(openxlsx)
fp <- '/Users/gabrielfeng/Documents/R\ directory/Fin\ 285/EventDates/G_Summit&Others.xlsx'
gs.date <- read.xlsx(xlsxFile=fp,sheet=2,cols=c(2),startRow=2,colNames = FALSE)
gs.date <- gs.date[-42,]
date1 <- sapply(gs.date,strsplit,split=' ')


#regular expression example
mDates <- c()
for (i in 1:length(date1)) {
        rawdate <- date1[[i]]
        id.yr <- grep(pattern='\\d{3}',rawdate,perl=TRUE)
        id.day <- grep(pattern='[0-9],',rawdate,perl=TRUE)
        id.mon <- grep(pattern='[A-Za-z]',rawdate,perl=TRUE)
        nocomma <- strsplit(rawdate[id.day],',')[[1]]
        days <- data.frame(strsplit(nocomma,'–'),stringsAsFactors = FALSE)
        dmy1 <- paste(days[1,],rawdate[id.mon],rawdate[id.yr],sep='')
        dmy2 <- paste(days[2,],rawdate[id.mon],rawdate[id.yr],sep='')
        dmy <- as.character(as.Date(c(dmy1,dmy2),"%d%B%Y"))
        cat(i,dmy,'\n')
        if (as.Date(dmy1,"%d%B%Y")>as.Date('2005-11-01')) {
                mDates <- rbind(mDates, dmy)
                cat('---------Got',i,dmy,'\n')
        }
}
rownames(mDates) <- 1:nrow(mDates)

rem <- ls()
rem <- rem[!grepl('mDates',rem)]
rm(list=rem)
rm(rem)
save.image('/Users/gabrielfeng/Documents/R\ directory/Fin\ 285/EventDates.RData')