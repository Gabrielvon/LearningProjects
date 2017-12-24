# hw8
library(quantmod)
library(tseries)
library(timeSeries)
library(rugarch)
library(FinTS)

getSymbols('CFI',src='yahoo',from='2010-01-01',to='2015-03-31',return.class='timeSeries')
chartSeries(CFI,theme='white')
CFI.logR <- dailyReturn(Ad(CFI),type='log')[-1]
ArchTest(CFI.logR)
hist(CFI.logR)
plot.ts(CFI.logR)

# Fit GARCH
# sG.spec <- ugarchspec(variance.model=list(model='sGARCH',garchOrder=c(1,1)))
sG.spec <- ugarchspec(variance.model=list(model='sGARCH',garchOrder=c(1,1),variance.targeting=F),
                      mean.model=list(armaOrder=c(0,0),include.mean=T),
                      distribution.model='norm')
sG.fit <- ugarchfit(sG.spec,CFI.log)
show(sG.fit)
plot(sG.fit,which='all')
bootp <- ugarchboot(sG.fit,method='Partial',n.ahead=50,n.bootpred=50)
show(bootp)
bootf <- ugarchboot(sG.fit,method='Full',n.ahead=50,n.bootpred=50)
show(bootf)

# Fit EGARCH
eG.spec <- ugarchspec(variance.model=list(model='eGARCH',garchOrder=c(1,1)))
eG.fit <- ugarchfit(eG.spec,CFI.log)
show(eG.fit)
plot(eG.fit,which='all')
bootp <- ugarchboot(eG.fit,method='Partial',n.ahead=50,n.bootpred=50)
show(bootp)
bootf <- ugarchboot(eG.fit,method='Full',n.ahead=50,n.bootpred=50)
show(bootf)
