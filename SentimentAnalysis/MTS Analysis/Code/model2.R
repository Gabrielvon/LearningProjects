setwd('/Users/gabrielfeng/Dropbox/TM\ project/Numeric\ Data/Code')
# MTS practise
require(MTS)
require(mvtnorm)
require(timeSeries)
# Import data
train=read.table('train.csv',sep=',',header=TRUE)
test=read.table('test.csv',sep=',',header=TRUE)
da=train[,2:dim(train)[2]]
tdx=train[,1]

# Cointegration for Vector & ECM 
library(urca)
da2=diffM(da); tdx2=tdx[-nrow(da)]
MTSplot(da2,tdx2) # no diff
mq(da,lag=10)  # Compute Q(m) statistics
jo1 = ca.jo(da2,type='trace',ecdet='none',spec=c("transitory"))
jo1.sum=summary(jo1) #all variables should be considered
eig.none=jo1.sum@V
ind=cbind(c(1:8),c(8:1))
wt1=0
for (i in c(1:8)) {
        wt1=wt1+eig.none[i,9-i]*da2[,i]
}
library(fUnitRoots)
adfTest(wt1,10,type='nc')
m5=ECMvar1(da2,3,wt1)
m5.ref=refECMvar1(m5)

jo2 = ca.jo(da2,type='trace',ecdet='const',spec=c("transitory"))
jo2.sum=summary(jo2) #all variables should be considered
eig.const=jo2.sum@V
len=dim(da2)[1]
# mula=t(matrix(rep(eig.const[-9,1],len),8,len))
# wt2a=mula*da2
# mulb=t(matrix(rep(eig.const[-9,2],len),8,len))
# wt2b=mulb*da2
wt2=c()
for (i in c(1:8)) {
        mul=t(matrix(rep(eig.const[-9,i],len),8,len))
        wwtt=rowSums(mul*da2)
        wt2=cbind(wt2,wwtt)
}
adfTest(wt2,lag=10,type='c')
m5=ECMvar1(da2,5,wt2)
m5.ref=refECMvar1(m5,thres=0.2)

save.image('model2.RData')
