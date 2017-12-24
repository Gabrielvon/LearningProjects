require("fUnitRoots")
library(quantmod)
library(tseries)
library(timeSeries)

getSymbols('AAPL')
AAPL.ts=data.frame(get('AAPL'))
l.aapl.adj = log(AAPL.ts$"AAPL.Adjusted") 
nobs = length(l.aapl.adj)
adf.test = adfTest(ts(l.aapl.adj), lag = 5, type = "ct") 
print(adf.test@test)
print(summary(adf.test@test$lm))

adf.test = adfTest(ts(l.aapl.adj), lag = 5, type = "c")
adf.test = adfTest(ts(l.aapl.adj), lag = 5, type = "nc") 

dl.aapl.adj = diff(l.aapl.adj,1)
acf(dl.aapl.adj)
pacf(dl.aapl.adj)

############# unit root test ############
df = read.csv("xi in class.csv")


library(forecast)
#x1
max.lag = floor((12*(length(df$x1)/100)^0.25))

adf.test = adfTest(df$x1, lag = 11, type = "c")
adf.test@test
summary(adf.test@test$lm)
arima(df$x1,order=c(2,0,1),method='ML')
auto.arima(df$x1)

#x2
max.lag = floor((12*(length(df$x2)/100)^0.25))
adf.test = adfTest(df$x2, lag = 4, type = "nc")
adf.test@test
summary(adf.test@test$lm)
# get rid of the estimate with a p-value that larger than 0.05

adf.test = adfTest(diff(df$x2,1,1), lag = 3, type = "nc")
adf.test@test
summary(adf.test@test$lm)
# x2 ~ I(1)
# arima(p,1,q)
# auto.arima(df$x2)

#x3
max.lag = floor((12*(length(df$x3)/100)^0.25))
adf.test = adfTest(df$x3, lag = 5, type = "ct")
adf.test@test
summary(adf.test@test$lm)

adf.test = adfTest(diff(df$x3), lag = 4, type = "nc")
adf.test@test
summary(adf.test@test$lm)

adf.test = adfTest(diff(df$x3,1,2), lag = 3, type = "nc")
adf.test@test
summary(adf.test@test$lm)


#x4
adf.test = adfTest(df$x4, lag = 3, type = "ct")
adf.test@test
summary(adf.test@test$lm)
# adjust lag first, then adjust type

#slotNames(adf.test@test$lm$residuals)
#residuals(adf.test@test$lm)
