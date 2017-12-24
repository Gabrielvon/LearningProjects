setwd('/Users/gabrielfeng/Documents/R directory/BAN 275/hw9')
# library(MTS)
library(vars)
library(tseries)
# library(timeSeries)
library(fUnitRoots)
# library(forecast)

# pdf(file='p6.pdf')
# Task:   Fit a two equation vector autoregressive model to the Employment data set.  
# Steps:
### -------------------- Data preparation -------------------- ###
employ <- read.csv('Employment.csv',header=T)
unrate <- ts(employ[,2])
jbop <- ts(employ[,3])

plot(unrate)
max.lag = floor((12*(length(unrate)/100)^0.25))
adf <- adfTest(diff(unrate),lag=2,type='nc')
adf@test
summary(adf@test$lm) # I(0)

plot(jbop) 
max.lag = floor((12*(length(jbop)/100)^0.25))
adf <- adfTest(diff(jbop),lag=2,type='nc')
adf@test
summary(adf@test$lm) # I(0)

employ.d1 <- cbind(diff(unrate),diff(jbop))
colnames(employ.d1) <- c('unrate','job.open')

# 
### ---------------- Determine the order of the model ---------------- ###
cor.acr <- acf(employ.d1, type="correlation")
VARselect(employ.d1,lag.max=max.lag,type='const')$selection
# Comparing the results of later test, I consider 6 as the order.

### -------------------- Model Checking -------------------- ###
employ.fit <- VAR(employ.d1,p=3)
summary(employ.fit)
plot(employ.fit)
serial.test(employ.fit,lags.pt=12,type='PT.adjusted')
arch.test(employ.fit,lags.single=16,lags.multi=5,multivariate.only=T)
normality.test(employ.fit,multivariate.only=TRUE)
roots(employ.fit)
plot(stability(employ.fit,type='Rec-CUSUM'))
plot(irf(employ.fit,response=c('unrate','job.open'),boot=T))
plot(fevd(employ.fit,n.ahead=10))
# dev.off()
