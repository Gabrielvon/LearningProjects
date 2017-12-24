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


mq(da,10) # it rejects H0, which mean the series are autocorrelated.
Eccm(da) #(3,0),(2,1) are possible order for modeling.
da2=diffM(da); tdx2=tdx[-nrow(da)]
Eccm(da2) #(3,0),(3,1) are possible order for modeling. 

# VAR (3) without difference
library(fBasics)
VARorder(da)
m2 = VAR(da,p=3,include.mean=T)
# MTSdiag(m2)
m2 = refVAR(m2,thres=0.1) 
mq(m2$residuals,10) #all lags pass test
jarqueberaTest(m2$residuals) #failed
phi=m2$Phi; theta=m2$Theta; sig=m2$Sigma
VARMAirf(Phi=phi,Theta=theta, Sigma=sig, orth=F)
m2.pred=VARpred(m2,h=50)$pred
tdx0=test[1:50,1]
test0 = test[1:50,2:dim(test)[2]]
for (i in 1:8) {
        plot.ts(1:50,test0[,i],type='l',col='red')
        lines(1:50,m2.pred[,i],col='green')
}
means0=rbind(apply(test0,2,mean),apply(m2.pred,2,mean))
sds0=rbind(apply(test0,2,sd),apply(m2.pred,2,sd))


# VAR (3) with one difference
VARorder(da2)
m2D = VAR(da2,p=2,include.mean=T)
# MTSdiag(m2D)
m2D = refVAR(m2D,thres=0.1) 
mq(m2D$residuals,10) #pass all lags
jarqueberaTest(m2D$residuals) #failed
phi=m2D$Phi; theta=m2D$Theta; sig=m2D$Sigma
VARMAirf(Phi=phi,Theta=theta, Sigma=sig, orth=F)
m2D.pred=VARpred(m2D,h=50)$pred
tdx0=test[1:50,1]
testD = diffM(test)[1:50,2:dim(test)[2]]
for (i in 1:8) {
        plot.ts(1:50,testD[,i],type='l',col='red')
        lines(1:50,m2D.pred[,i],col='green')
}
meansD=rbind(apply(testD,2,mean),apply(m2D.pred,2,mean))
sdsD=rbind(apply(testD,2,sd),apply(m2D.pred,2,sd))


# VARMA (this step spends unlimited time)
m3=VARMA(da2,3,0,thres=1)
m3=refVAR(m2,thres=0.1) 
mq(m3$residuals,10) #pass all lags
jarqueberaTest(m3$residuals) #failed
# MTSdiag(m3)
phi=m3$Phi; theta=m3$Theta; sig=m3$Sigma
VARMAirf(Phi=phi,Theta=theta, Sigma=sig, orth=F)
m3.pred=VARMApred(m3,h=50)$pred

# VARMA with other order selection
#Kronecker
kidx=Kronid(da2)
m4.kr=Kronfit(da2,kidx$index) #(this step spends unlimited time)
m4.kr_ref=refKronfit(m4.kr,thres=1)
m4.kr.pred=VARMApred(m4.kr_ref,10)
#Scalar Components
scm.id=SCMid2(da2,maxp=10,maxq=5)
scms=scm.id$SCMorder
Tdx=max.col(scm.id$Tmatrix) 
m4.scm=SCMfit(da2,scms,Tdx) #(this step spends unlimited time)
m4.scm_ref=refSCMfit(m4.scm,thres=1)
m4.scm.pred=VARMApred(m4.scm_ref,10)

# VARX 
zt=da[,c(1,4)]; xt=da[,c(2:3,5:8)]
VARorder(zt)
VARXorder(zt,xt,10,3)
m5=VARX(zt,1,xt,3)
m5_ref=refVARX(m5)
MTSdiag(m5)
xt.pred=test[1:50,c(2:4,6:8)]
m5.pred=VARXpred(m5_ref,xt.pred,hstep=50) #the extraction got some problems, which makes the following m5.pred[,i] is incorrect.
testX = test[1:50,c(2,5)] 
for (i in 1:2) {
        plot.ts(1:50,testX[,i],type='l',col='red')
        lines(1:50,m5.pred[,i],col='green') 
}
meansX=rbind(apply(testX,2,mean),apply(m5.pred,2,mean))
sdsX=rbind(apply(testX,2,sd),apply(m5.pred,2,sd))

save.image('model3.RData')
