# Rugarch Project
library(quantmod)
library(rugarch)
library(FinTS)
library(tseries)
library(timeSeries)
library(fUnitRoots)
library(forecast)


###--------------------- Data Preparation ---------------------###
getSymbols('CFI',src='yahoo',from='2010-01-01',to='2015-03-31',return.class='timeSeries')
# write.csv(CFI,file='CFI-rawdata')
chartSeries(CFI,theme='white')
CFI.ts <- CFI[,c(5,6)]
ArchTest(CFI.ts)
Vol.log <- dailyReturn(CFI.ts[,1],type='log')[-1]
Adj.log <- dailyReturn(CFI.ts[,2],type='log')[-1]
# CFI.pv <- cbind(Vol.log,Adj.log)


###------ Determine ARFIMA component -------###
arfima.fit <- suppressWarnings(arfima(Adj.log))
summary(arfima.fit)
iTestArima.f(arfima.fit,200)
arma.p <- length(arfima.fit$ar) #3
arma.q <- length(arfima.fit$ma) #3

arima.fit <- arima(Adj.log,order=c(1,0,3))
iTestArima(arima.fit,200)

###------ Determine ARFIMA component -------###
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
sG.spec <- ugarchspec(variance.model=list(model='sGARCH',
                                          garchOrder=c(1,2),
                                          external.regressors=Vol.log,
                                          variance.targeting=F
),
mean.model=list(armaOrder=c(2,3),include.mean=T,
                archm=F,arfima=F,archpow=1
),
distribution.model='sstd')
show(sG.spec)
sG.fit <- ugarchfit(sG.spec,Adj.log,
                    #fit.control = list(stationarity = 1),
                    solver.control=list(trace=0))
show(sG.fit)
plot(sG.fit,which='all')

# Fit EGARCH
eG.spec <- ugarchspec(variance.model=list(model='eGARCH',
                                          garchOrder=c(1,1),
                                          variance.targeting=F
),
mean.model=list(armaOrder=c(3,3),include.mean=T,
                archm=F,arfima=F,archpow=1,
                external.regressors=Vol.log
),
distribution.model='std')
show(eG.spec)
eG.fit <- ugarchfit(eG.spec,data=Adj.log,solver.control=list(trace=0))
show(eG.fit)
plot(eG.fit,which='all')


###--------------------- Prediction ---------------------###
# Predict GARCH
bootp.sG <- ugarchboot(sG.fit,method='Partial',n.ahead=50,n.bootpred=50)
show(bootp.sG)
bootf.sG <- ugarchboot(sG.fit,method='Full',n.ahead=50,n.bootpred=50)
show(bootf.sG)

# Predict EGARCH
bootp.eG <- ugarchboot(eG.fit,method='Partial',n.ahead=50,n.bootpred=50)
show(bootp.eG)
bootf.eG <- ugarchboot(eG.fit,method='Full',n.ahead=50,n.bootpred=50)
show(bootf.eG)

