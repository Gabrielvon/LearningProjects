setwd('/Users/gabrielfeng/Dropbox/TM\ project/Numeric\ Data/ToUse')
require(dplyr)

filepaths = list.files(path=getwd(), full.names = TRUE)
filenames = list.files(path=getwd(), full.names = FALSE)
len = length(filepaths)
for (i in 1:len) {
        table <- read.csv(filepaths[i],sep=',',header=TRUE,blank.lines.skip=TRUE,stringsAsFactors=FALSE)
        assign(paste('data',i,sep=''),tbl_df(table))
        names = rbind(names,c(paste('data',i,sep=''),filenames[i]))
}
data6[,c(2:ncol(data6))] = sapply(data6[,c(2:ncol(data6))],function(x) {as.numeric(as.character(x))})
data6 = na.omit(data6[-1,][c(1,4)])
colnames(data6) = 'Date'
datalist = list(data1,data2,data3,data5,data6,data7,data8,data9,data10)
names1=filenames[-4]
df = inner_join(datalist[[1]],datalist[[2]],by='Date')
for (i in c(3,5:len)) {
        show(i)
        data = get(paste('data',i,sep=''))
        df = inner_join(df,data,by='Date')
#         suppressWarnings()
}
colnames(df) = c('Date',names1)
write.csv(df,'/Users/gabrielfeng/Dropbox/TM project/Numeric Data/Code/cleandata.csv')
# df = data1
# f1 <- function (data,name) {
#         colnames(data) = name
#         set = inner_join(df,data, by='Date')
#         return(set)
# }
# f1(data1,filenames[1])


# for (i in 1:len) {
#         sets = get(paste('data',i,sep=''))
#         colnames(sets) = c('Date',filenames[i])
#         show(filenames)
# }


# data1=data5=data10
# data3=data7
# data4 have problems