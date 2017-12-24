# BAN275 Midterm
library(quantmod)
library(tseries)
library(timeSeries)
library(fUnitRoots)
library(forecast)
library(TTR)


##----------------------------- 1 -----------------------------##
getSymbols('MSFT',src='yahoo',from='2012-01-01',to='2015-03-31')
MSFT.adj <- Ad(MSFT)
summary(as.numeric(MSFT.adj))
# stats <= summary(as.numeric(MSFT.adj))
# stats[c(4,3,2,5)] order

##----------------------------- 2 -----------------------------##
getSymbols('MSFT',src='yahoo',from='2014-07-01',to='2014-12-31')
MSFT.ret.14 <- dailyReturn(MSFT,type='log')[-1]
MSFT.ma20.14 <- ma(timeSeries(MSFT.ret.14),order=20,centre=T)
chartSeries(MSFT, theme='white',
            TA="addBBands();addVo();addWMA(n=20);",
            main='',name='MSFT')
addTA(MSFT.ret.14,col='blue',lwd=1,type='l')



##----------------------------- 3 -----------------------------##
# MSFT returns
par(mfrow=c(2,3))
cat(paste("\n", "MSFT Compounded Daily Returns",
          "\n  Mean = \t", mean(MSFT.ret.14),
          "\n  Stdev = \t", stdev(MSFT.ret.14), sep = ""))
barplot(MSFT.ret.14, main=paste('barplot:','\n','Aggregated Returns'))
hist(MSFT.ret.14,main=paste('hist:','\n','Aggregated Returns'))
qqnorm(MSFT.ret.14,main=paste('qqnorm:','\n','Aggregated Returns'))

plot(MSFT.ret.14)
acf(MSFT.ret.14,na.action=na.pass,main="ACF: MSFT.ret.14") 
pacf(MSFT.ret.14,na.action=na.pass,main="PACF: MSFT.ret.14")
summary(lm(MSFT.ret.14~lag(MSFT.ret.14)))

max.lag = floor((12*(length(MSFT.ret.14)/100)^0.25))
adf.test = adfTest(as.timeSeries(MSFT.ret.14),lag=4,type='nc')
adf.test@test
summary(adf.test@test$lm)

MSFT.d1 <- diff(as.timeSeries(MSFT.ret.14))
adf.test = adfTest(MSFT.d1,lag=12,type='nc')
adf.test@test
summary(adf.test@test$lm)

# 20 days MA
cat(paste("\n", "MSFT 20 days MA Daily Returns",
          "\n  Mean = \t", mean(MSFT.ma20.14,na.rm=T),
          "\n  Stdev = \t", stdev(MSFT.ma20.14,na.rm=T), sep = ""))
barplot(MSFT.ma20.14, main=paste('barplot:','\n','Aggregated MA20'))
hist(MSFT.ma20.14,main=paste('hist:','\n','Aggregated MA20'))
qqnorm(MSFT.ma20.14,main=paste('qqnorm:','\n','Aggregated MA20'))

acf(MSFT.ma20.14,na.action=na.pass,main=paste("ACF: MSFT.ma20.14", sep=" ")) 
pacf(MSFT.ma20.14,na.action=na.pass,main=paste("PACF: MSFT.ma20.14", sep=" "))

max.lag = floor((12*(length(MSFT.ma20.14)/100)^0.25))
adf.test = adfTest(MSFT.ma20.14,lag=9,type='nc')
adf.test@test
summary(adf.test@test$lm)

##----------------------------- 6 -----------------------------##
se.a.AR <- -1.01  
se.b.AR <- c(1.3,-0.99) 
se.c.AR <- c(-1.7,0.8) 
se.d.AR <- c(0.8,-1.5)
se.d.MA <- c(1.6,0.3) 
se.e.AR <- c(0.6,0.3,-0.1,0.2)
se.all <- list(se.a.AR,se.b.AR,se.c.AR,se.d.AR,se.e.AR)
se.all.AR <- mapply(function(x){min(Mod(polyroot(c(1, -x))))}, x=se.all)
se.all.AR
se.d.MA <- min(Mod(polyroot(c(1,-se.d.MA))))
se.d.MA

##----------------------------- 7 -----------------------------##
# H0: the population mean of the random variable X is equal to 7; H1:.
# Sim.1: H0 is true;
set.seed(185)
count.7 <- 0
for (i in 1:500) {
        dat <- rnorm(20,mean=7,sd=sqrt(0.5))
        ttest <- t.test(dat,mu=7,conf.level=.95,alternative='two.sided')
        if (ttest$p.value <= 0.05) {
                count.7 = count.7 + 1 #Collect data on frequency, type I error
        }
}
p1 <- count.7/500
# Findings: Apparently, the probability of those random numbers locating in 
# confident interval is close to 0.025. That is, we are 97.5% confident to say 
# that the means of this samples are not equal to 7.

# Sim.2: H0 is false
set.seed(185)
count.74 <- 0
for (i in 1:500) {
        dt <- rnorm(20,mean=7.4,sd=sqrt(0.5))
        ttest <- t.test(dt,mu=7,conf.level=.95,alternative='two.sided')
        if (ttest$p.value >= 0.05) {
                count.74 = count.74 + 1 #Collect data on frequency, type II error
        }
}
p2 <- count.74/500
# Findings: The probability of those random numbers locating in 
# confident interval is 0.526. That is, we are 47.4% confident to say 
# that the means of this samples are not equal to 7.

##----------------------------- 8 -----------------------------##
# MA(2) additive error model
# Sim.1: H0 is true;
set.seed(185)
mu <- 7
count.ma.7 <- 0
for (i in 1:500) {        
        ma2 <- mu + arima.sim(model = list(order=c(0,0,2),ma=c(1.4,-0.8),include.mean=TRUE),n=20)        
        ttest <- t.test(ma2, mu=7, conf.level=.95)
        if (ttest$p.value <= 0.05) {
                count.ma.7 = count.ma.7 + 1 #Collect data on frequency, type I error
        }       
}
p1.ma <- count.ma.7/500

# Sim.2: H0 is false;
set.seed(185)
mu <- 7.4
count.ma.74 <- 0
for (i in 1:500) {        
        ma2 <- mu + arima.sim(model = list(order=c(0,0,2),ma=c(1.4,-0.8),include.mean=TRUE),n=20)
        ttest <- t.test(ma2, mu=7, conf.level=.95)
        if (ttest$p.value >= 0.05) {
                count.ma.74 = count.ma.74 + 1 #Collect data on frequency, type II error
        }       
}
p2.ma <- count.ma.74/500 

##----------------------------- 9 -----------------------------##

#Simulation
set.seed(74)
da.sim <- arima.sim(model = list(order=c(2,1,1), ar = c(1.2,-0.7),
                       ma = 0.7), n=310,  sd = 0.2)
#Fitting ARIMA model
co.m.fit <- Arima(da.sim,order=c(2,1,1),method='ML')
iTestArima(co.m.fit, nobs=300, lb.lag=12)
ov.m.fit <- Arima(da.sim,order=c(5,0,1),method='ML')
iTestArima(ov.m.fit, nobs=300, lb.lag=12)
un.m.fit <- Arima(da.sim,order=c(1,0,1),method='ML')
iTestArima(un.m.fit, nobs=300, lb.lag=12)

#Forecasting
forc.co = forecast(co.m.fit, 10)
plot(forc.co,main='forcasting correct model')
forc.co.mean = forc.co$mean
forc.co.se   = forc.co$residuals
forc.ov = forecast(ov.m.fit, 10)
plot(forc.ov,main='forcasting overfit model')
forc.ov.mean = forc.co$mean
forc.ov.se   = forc.co$residuals
forc.un = forecast(un.m.fit, 10)
plot(forc.un,main='forcasting underfit model')
forc.un.mean = forc.co$mean
forc.un.se   = forc.co$residuals

# Collect performance data
da.fit$aic
da.fit$bic
da.fit$loglik
resid <- da.fit$residual
p <- length(da.fit$model$phi[da.fit$model$phi!=0])
q <- length(da.fit$model$theta[da.fit$model$theta!=0])
df  <- 300 - da.fit$n.cond - p - q
se.e <- sqrt(sum(resid^2)/df)
JB.P <- jarque.bera.test(resid)$p.value
LB.P <- Box.test(resid,  lag = 12, type = "Ljung-Box", fitdf = p+q)$p.value
#proportion of significant p-values
MAPE <- 1/10 * sum(abs(da.sim[301:310]-da.forc$mean)/da.sim[301:310])

### two graphics pages, 3x3 box-plots, correct vs. under-fitted and 
# correct vs over-fitted models???
boxplot(co.m.fit$model)


