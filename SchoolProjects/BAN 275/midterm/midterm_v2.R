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

##----------------------------- 2 -----------------------------##
getSymbols('MSFT',src='yahoo',from='2014-07-01',to='2014-12-31')
MSFT.ret.14 <- dailyReturn(MSFT,type='log')[-1]
MSFT.ma20.14 <- ma(timeSeries(MSFT.ret.14),order=20,centre=T)
chartSeries(MSFT, theme='white',
            TA="addBBands();addVo();addWMA(n=20);",
            main='',name='MSFT')
addTA(MSFT.ret.14,col='blue',lwd=1,type='l')
chartSeries(MSFT, theme = "white", TA = 
                    c(addBBands(),addTA(MSFT["2014-07-01::2014-12-31",5]),
                      addWMA(n=20)))

##----------------------------- 3 -----------------------------##
# MSFT returns
par(mfrow=c(2,3))
cat(paste("\n", "MSFT Compounded Daily Returns",
          "\n  Mean = \t", mean(MSFT.ret.14),
          "\n  Stdev = \t", stdev(MSFT.ret.14), sep = ""))
plot(MSFT.ret.14,main='Log Return 2014')
barplot(MSFT.ret.14, main=paste('barplot:','\n','Aggregated Returns'))
hist(MSFT.ret.14,main=paste('hist:','\n','Aggregated Returns'))
qqnorm(MSFT.ret.14,main=paste('qqnorm:','\n','Aggregated Returns'))
acf(MSFT.ret.14,na.action=na.pass,main="ACF: MSFT.ret.14") 
pacf(MSFT.ret.14,na.action=na.pass,main="PACF: MSFT.ret.14")

max.lag = floor((12*(length(MSFT.ret.14)/100)^0.25))
adf.test = adfTest(as.timeSeries(MSFT.ret.14),lag=4,type='nc')
adf.test@test
summary(adf.test@test$lm)
MSFT.d1 <- diff(as.timeSeries(MSFT.ret.14))
adf.test.d1 = adfTest(MSFT.d1,lag=12,type='nc')
adf.test@test
summary(adf.test.d1@test$lm)

# 20 days MA
par(mfrow=c(2,3))
cat(paste("\n", "MSFT 20 days MA Daily Returns",
          "\n  Mean = \t", mean(MSFT.ma20.14,na.rm=T),
          "\n  Stdev = \t", stdev(MSFT.ma20.14,na.rm=T), sep = ""))
plot.ts(MSFT.ma20.14,main='20 days MA Returns 2014')
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
        if (ttest$p.value < 0.05) {
                count.7 = count.7 + 1 #Collect data on frequency, type I error
        }
}
p1 <- count.7/500
count.7
p1
# Findings: Apparently, the probability of those random numbers from simulation
# locating in confident interval is 0.064, which is close to 0.05. That is, it is
# close to what we expected, and this method is applicable to this case.

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
count.74
p2
# Findings: Apparently, the probability of those random numbers from simulation
# locating in confident interval is 0.68, which is a bit away from what we 
# expected -- close to 0.95. That is saying, this experience might not be
# approprite for this case. We have to make an adjustment before using this method.

##----------------------------- 8 -----------------------------##
# MA(2) additive error model
# Sim.1: H0 is true;
set.seed(185)
mu = 7
count.ma.7 = 0
for (i in 1:500) {   
        ma2 = mu + arima.sim(model = list(order=c(0,0,2),ar=NULL,ma=c(1.4,-0.8)),n=20,sd=sqrt(0.5))        
        ttest = t.test(ma2, mu=mu, conf.level=0.95,alternative='two.sided')
        if (ttest$p.value <= 0.05) {
                count.ma.7 = count.ma.7 + 1 #Collect data on frequency, type I error
        }
}
p1.ma <- count.ma.7/500
count.ma.7
p1.ma

# Sim.2: H0 is false;
set.seed(185)
mu <- 7.4
count.ma.74 <- 0
for (i in 1:500) {        
        ma2 <- mu + arima.sim(model = list(order=c(0,0,2),ma=c(1.4,-0.8),include.mean=TRUE),n=20,sd=sqrt(0.5))
        ttest <- t.test(ma2, mu=7, conf.level=.95,alternative='two.sided')
        if (ttest$p.value >= 0.05) {
                count.ma.74 = count.ma.74 + 1 #Collect data on frequency, type II error
        }
}
p2.ma <- count.ma.74/500 
count.ma.74
p2.ma

# Findings: Compare to question 7, the error between the simulation output and 
# our expectation is smaller. That is saying, 

##----------------------------- 9 -----------------------------##
diagnArima <- function(ar.par=c(1.2,-0.7),ma.par=c(0.7), d=0, p.test=2, d.test=1, 
                       q.test=1, sd=0.2, n.st=100, nobs=300, const=0, nforward=10, lb.lags=12)
{
        p <- length(ar.par); q <- length(ma.par);
        local.ts <- const + arima.sim(model = list(order=c(p,d,q), ar = ar.par, ma = ma.par), n=nobs+nforward, n.start=n.st, sd = sd)
        #---------------- Fit an ARIMA(p.test,d.test,q.test) -----------------#
        arima.mod = order = c(p.test, d.test, q.test)
        local.ts.mean = mean(local.ts)       # demean prior to fitting      
        local.ts.dm = local.ts - local.ts.mean
        arima.fit  =  Arima(local.ts.dm, order = arima.mod, method = "ML")
        #----------------------  Forecasting ----------------------#
        forc.co = forecast(arima.fit, nforward)
        #----------------------  Diagnose ----------------------#
        df  = nobs - arima.fit$n.cond - p.test - q.test
        AIC <- arima.fit$aic
        BIC <- arima.fit$bic
        Loglik <- arima.fit$loglik
        resid <- arima.fit$residual
        se.e <- sqrt(sum(resid^2)/df)
        JB.P <- jarque.bera.test(resid)$p.value
        LB.P <- Box.test(resid,  lag = 12, type = "Ljung-Box", fitdf = p+q)$p.value
        suppressWarnings(s.e <-  sqrt(diag(arima.fit$var.coef)))
        tstat = arima.fit$coef/s.e
        signif   =   2 * (1 - pt(abs(tstat), df)) < 0.05
        prop.sig =  100*sum(signif)/length(signif)         
        MAPE <- (1/nforward) * sum(abs(local.ts[(nobs+1):(nobs+nforward)]-forc.co$mean)/local.ts[(nobs+1):(nobs+nforward)])
        results <- c(AIC,BIC,Loglik,se.e,JB.P,LB.P,prop.sig,MAPE)
        return(results)
}
performance <- c("AIC", "BIC", "LogLik", "Est.Err.Std","JB P-value", "LB P-value",'Prop.Sig','MAPE')
for (str in c('co.m.fit','ov.m.fit','un.m.fit')) { 
        eval(parse(text=paste(str,'<- matrix(NA,100,8,dimnames=list(NULL,performance))')))}
set.seed(74)
for (i in 1:100){
        co.m.fit[i,] <- diagnArima(p.test=2,q.test=1,d.test=0)
        ov.m.fit[i,] <- diagnArima(p.test=5,q.test=1,d.test=0)
        un.m.fit[i,] <- diagnArima(p.test=1,q.test=1,d.test=0)}
alldata<-lapply(1:8,function(i){cbind(co.m.fit[,i],ov.m.fit[,i],un.m.fit[,i])})
names(alldata) <- performance
# Boxplots
par(mfrow=c(3,3)); invisible(sapply(1:8,function(i){boxplot(alldata[[i]][,1],main='Correctfit',ylab=names(alldata)[i],col="steelblue")}))
par(mfrow=c(3,3)); invisible(sapply(1:8,function(i){boxplot(alldata[[i]][,2],main='Overfit',ylab=names(alldata)[i],col="mediumturquoise")}))
par(mfrow=c(3,3)); invisible(sapply(1:8,function(i){boxplot(alldata[[i]][,3],main='Underfit',ylab=names(alldata)[i],col="sandybrown")}))
par(mfrow=c(3,3)); invisible(sapply(1:8,function(i){boxplot(alldata[[i]],main='Co/Ov/Un',ylab=names(alldata)[i],col=c("steelblue","mediumturquoise","sandybrown"))}))