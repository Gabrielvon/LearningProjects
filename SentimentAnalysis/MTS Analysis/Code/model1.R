setwd('/Users/gabrielfeng/Dropbox/TM\ project/Numeric\ Data/Code')
# MTS practise
require(MTS)
require(mvtnorm)
require(timeSeries)
require(fBasics)
# Import data
train=read.table('train.csv',sep=',',header=TRUE)
test=read.table('test.csv',sep=',',header=TRUE)
da=train[,2:dim(train)[2]]
tdx=train[,1]

## PCA&Factor Model (failed or need to be modified)
da1=scale(diffM(da)); tdx1=tdx[-nrow(da)];
m1.pca=princomp(da1)
summary(m1.pca)
screeplot(m1.pca,type='lines')
m1.pr=prcomp(da1)
a1=predict(m1.pr)[,1:5]
a2=m1.pr$x
m1.lm=lm(tdx1~m1.pr$x[,1]+m1.pr$x[,2]+m1.pr$x[,3]+m1.pr$x[,4]+m1.pr$x[,5])
summary(m1.lm)
factanal(da,2,method='mle')

# VARMA+PCA
da.m1=m1.pr$x
mq(da.m1,10) 
Eccm(da.m1)
m3.m1pc = VAR(da.m1,3)
mq(m3.m1pc$residuals,10)  #failed at lag=10;
jarqueberaTest(m3.m1pc$residuals) #failed
m3.m1pc_ref = refVAR(m3.m1pc,thres=1)
mq(m3.m1pc_ref$residuals,10)  #failed at lag=9 and 10;
jarqueberaTest(m3.m1pc_ref$residuals) #failed

save.image('model1.RData')
