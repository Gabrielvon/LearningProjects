setwd('/Users/gabrielfeng/Dropbox/TM\ project/Numeric\ Data/ToUse')
require(dplyr)

filepaths = list.files(path=getwd(), full.names = TRUE)
filenames = list.files(path=getwd(), full.names = FALSE)
len = length(filepaths)
names = list()
for (i in 1:len) {
        table <- read.csv(filepaths[i],sep=',',header=TRUE,blank.lines.skip=TRUE,stringsAsFactors=FALSE)
        fn = substr(filenames[i],1,nchar(filenames[i])-4)
        colnames(table) = c('Date',fn)
        assign(paste('data',i,sep=''),tbl_df(table))
        names = rbind(names,c(paste('data',i,sep=''),fn))
}
# data6[,c(2:ncol(data6))] = sapply(data6[,c(2:ncol(data6))],function(x) {as.numeric(as.character(x))})
# data6 = na.omit(data6[-1,][c(1,4)])
# colnames(data6) = 'Date'
datalist = list(data1,data2,data3,data5,data7,data8,data9,data10)

df = data1[,1] 
lenUse = length(datalist)
for (i in c(1:lenUse)) {
        df = inner_join(df,datalist[[i]],by='Date')
}

write.csv(df,'/Users/gabrielfeng/Dropbox/TM project/Numeric Data/Code/cleandata.csv')

setwd('/Users/gabrielfeng/Dropbox/TM\ project/Numeric\ Data/Code')
# Further cleaning
f = function(x) {
        xx = sapply(strsplit(as.character(x),'/'),as.numeric)
        daynum=(as.numeric(xx[1])*21+as.numeric(xx[2]))/252+as.numeric(xx[3])-9
}
df = read.table('cleandata.csv',sep=',',header=TRUE)
df = df[order(df[,'X'],decreasing=TRUE),]
df[,'Date'] = sapply(df[,'Date'],f)
tdx = df[,'Date']
da = df[,3:length(df)]

train = df[1:(365*4),]
test = df[(365*4):dim(df)[1],]
write.csv(train,'/Users/gabrielfeng/Dropbox/TM project/Numeric Data/Code/train.csv',row.names = FALSE)
write.csv(test,'/Users/gabrielfeng/Dropbox/TM project/Numeric Data/Code/test.csv',row.names = FALSE)
