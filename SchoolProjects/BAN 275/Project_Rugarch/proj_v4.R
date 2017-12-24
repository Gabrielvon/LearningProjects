# Rugarch Project
library(quantmod)
library(rugarch)
library(FinTS)
library(tseries)
library(timeSeries)
library(fUnitRoots)
library(forecast)

###--------------------- A Function ---------------------###
iTestArima.f = function(arima.fit, nobs, lb.lags = c(6,12,18,24))
        # nobs, a strictly positive integer, is length of output
        # series fitting arima.fit, before un-differencing. 
        
{
        library(timeSeries)
        library(tseries)   # for ts.plot() and jarque.bera.test()
        p <- length(arima.fit$model$phi[arima.fit$model$phi!=0])
        q <- length(arima.fit$model$theta[arima.fit$model$theta!=0])
        d <- length(arima.fit$model$Delta[arima.fit$model$Delta!=0])
        
        
        #------------  Model Diagnostics for Validation  ----------------------------
        
        #------------ Test residuals for normality   
        print(jarque.bera.test(na.omit(residuals(arima.fit))))
        qqnorm(residuals(arima.fit), main = 
                       paste("Normal Probability Plot(",p,d,q,")"))
        
        
        #------------- Test for Autocorrelation
        lb.mat = matrix(0,length(lb.lags),3)
        dimnames(lb.mat) = list(NULL, c("To.Lag", "Statistic" , "p.value"))
        index = 1
        
        for (i in lb.lags){
                result  =  Box.test(na.omit(residuals(arima.fit)),  lag = i, 
                                    type = "Ljung-Box", fitdf = p+q)
                lb.mat[index,] =  c(i,result$statistic, result$p.value)
                index = index +1 
        }        
        
        acf(residuals(arima.fit), na.action=na.pass, lag.max = 12,  main = 
                    paste("ACF Residuals(",p,d,q,")"))
        acf(residuals(arima.fit), na.action=na.pass, lag.max = 12, type = "partial", 
            main = paste("PACF Residuals(",p,d,q,")"))
        
        cat("\n Ljung-Box Test\n\n" )
        print(lb.mat) 
        
        cat("\n ===========================  The end ==========================\n")
}


###--------------------- Data Preparation ---------------------###
getSymbols('CFI',src='yahoo',from='2010-01-01',to='2015-03-31',return.class='timeSeries')
# write.csv(CFI,file='CFI-rawdata')
chartSeries(CFI,theme='white')
CFI.ts <- CFI[,c(5,6)]
ArchTest(CFI.ts)
Vol.log <- dailyReturn(CFI.ts[,1],type='log')[-1]
Adj.log <- dailyReturn(CFI.ts[,2],type='log')[-1]
# CFI.pv <- cbind(Vol.log,Adj.log)


###------ Determine ARMA component -------###
arfima.fit <- suppressWarnings(arfima(Adj.log))
summary(arfima.fit)$coef
iTestArima.f(arfima.fit,200)
arma.p <- length(arfima.fit$ar) #3
arma.q <- length(arfima.fit$ma) #3

###------ Guidance for GARCH order -------###
# arch.list=list()
# tmp <- 0
# for (p in 1:3) {
#         arch.spec <- ugarchspec(variance.model=list(model='sGARCH',
#                                                     garchOrder=c(p,1),
#                                                     external.regressors=Vol.log,
#                                                     variance.targeting=F
#         ),
#         mean.model=list(armaOrder=c(3,3),include.mean=F,
#                         archm=F,arfima=F,archpow=1
#         ),
#         distribution.model='std')
#         arch.fit = ugarchfit(spec=arch.spec, data=Adj.log,
#                              solver.control=list(trace = 1))
#         tmp = tmp + 1
#         arch.list[[tmp]] = arch.fit
# }
# info.mat = sapply(arch.list, infocriteria)
# info.mat

###--------------------- Modeling ---------------------###
# Fit GARCH
sG.spec <- ugarchspec(variance.model=list(model='sGARCH',garchOrder=c(1,2),
                                          external.regressors=timeSeries(Vol.log)),
                      mean.model=list(armaOrder=c(3,3),include.mean=T),
                      distribution.model='sstd')
show(sG.spec)
sG.fit <- ugarchfit(sG.spec,Adj.log)
show(sG.fit)
plot(sG.fit,which='all')

# Fit EGARCH
eG.spec <- ugarchspec(variance.model=list(model='eGARCH',garchOrder=c(1,2),
                                          external.regressors=timeSeries(Vol.log)),
                      mean.model=list(armaOrder=c(3,3),include.mean=T, 
                                      external.regressors=NULL),
                      distribution.model='sstd')
show(eG.spec)
eG.fit <- ugarchfit(eG.spec,data=Adj.log,solver.control=list(trace=0))
show(eG.fit)
plot(eG.fit,which='all')


###--------------------- Prediction ---------------------###
# Predict GARCH
bootp.sG <- ugarchboot(sG.fit,method='Partial',n.ahead=50,n.bootpred=50)
show(bootp.sG)
plot(bootp.sG,which='all')
bootf.sG <- ugarchboot(sG.fit,method='Full',n.ahead=50,n.bootpred=50)
show(bootf.sG)
plot(bootf.sG,which='all')


# Predict EGARCH
bootp.eG <- ugarchboot(eG.fit,method='Partial',n.ahead=50,n.bootpred=50)
show(bootp.eG)
plot(bootp.eG,which='all')
bootf.eG <- ugarchboot(eG.fit,method='Full',n.ahead=50,n.bootpred=50)
show(bootf.eG)
plot(bootf.eG,which='all')


