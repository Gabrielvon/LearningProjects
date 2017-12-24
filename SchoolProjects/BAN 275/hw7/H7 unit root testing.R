library(quantmod) 
library(timeSeries)
require(tseries)


#getSymbols("DEXUSEU", src = "FRED" ) 
#head(DEXUSEU,2) 
#tail(DEXUSEU,2) 
#install.packages("fUnitRoots")
require(fUnitRoots)
require(quantmod)

#max.lag = floor((12*(length(df$x1)/100)^0.25))
#
##x1
#adf.test = adfTest(df$x1, lag = 3, type = "c")
#adf.test@test
#summary(adf.test@test$lm)




getSymbols("GDP", src = "FRED" ) 
gdp = timeSeries(GDP["1980-01-01::2005-10-01"]) 
head(gdp)
tail(gdp)
# max.lag = floor((12*(length(gdp)/100)^0.25))  #12
# adf.test = adfTest(gdp, lags = 3, type = "nc")
# adf.test@test
# summary(adf.test@test$lm)
# cat("\n AIC = ", AIC(adf.test@test$lm))
# cat("\n AIC = ", BIC(adf.test@test$lm), "\n")



getSymbols("CPIAUCSL", src = "FRED" ) #["1980-01-01::2005-10-01"]
cpi = timeSeries(CPIAUCSL["1980-01-01::2005-01-01"]) 
head(cpi)
tail(cpi)

month = rep(1:12,26)[1:301]
max.lag = floor((12*(length(cpi)/100)^0.25))  #15
dummy.df = dummy(month)[,-1] #???
tcpi = 1:length(cpi);  
tcpi.sq = tcpi^2;
seas.fit = lm(diff(cpi) ~ dummy.df[,2] + tcpi + dummy.df[,11] ,  na.action =na.omit) 
summary(seas.fit)

adf.test = adfTest(cpi, lags = 13 , type = "ct")
adf.test
summary(adf.test@test$lm)
cat("\n AIC = ", AIC(adf.test@test$lm))
cat("\n BIC = ", BIC(adf.test@test$lm), "\n")
acf(residuals(adf.test@test$lm), lag.max = 24)
acf(residuals(adf.test@test$lm), lag.max = 24, type = "partial")
plot(diff(cpi))

getSymbols("DEXUSEU", src = "FRED" ) #["1980-01-01::2005-10-01"]
fx.usEu = timeSeries(DEXUSEU["2002-01-01::2005-01-01"]) 
head(fx.usEu )
tail(fx.usEu )
# max.lag = floor((12*(length(fx.usEu)/100)^0.25))  #20
# adf.test = adfTest(fx.usEu@.Data, lags = 1 , type = "nc")
# adf.test@test
# summary(adf.test@test$lm)
# cat("\n AIC = ", AIC(adf.test@test$lm))
# cat("\n BIC = ", BIC(adf.test@test$lm), "\n")
# 
# 
# plot(diff(log(fx.usEu@.Data)), type = "l")




#
getSymbols("UNRATE", src = "FRED" ) #["1980-01-01::2005-10-01"]
unrate = timeSeries(UNRATE["1980-01-01::2005-01-01"]) 
head(unrate)
tail(unrate)
# max.lag = floor((12*(length(unrate)/100)^0.25))  #15
# adf.test = adfTest(diff(unrate@.Data, lags = 3 , type = "ct"))
# adf.test@test
# summary(adf.test@test$lm)
# cat("\n AIC = ", AIC(adf.test@test$lm))
# cat("\n BIC = ", BIC(adf.test@test$lm), "\n")




#
getSymbols("INDPRO", src = "FRED" ) #["1980-01-01::2005-10-01"]
indpro = timeSeries(INDPRO["1980-01-01::2005-01-01"]) 
#head(indpro)
#tail(indpro)
#max.lag = floor((12*(length(unrate)/100)^0.25))  #15
#adf.test = adfTest(indpro@.Data, lags = 3 , type = "ct")
#adf.test@test
#summary(adf.test@test$lm)
#cat("\n AIC = ", AIC(adf.test@test$lm))
#cat("\n BIC = ", BIC(adf.test@test$lm), "\n")
#
#plot(indpro)


getSymbols("GE", src = "yahoo" ) #["1980-01-01::2005-10-01"]
ge = timeSeries(GE["2010-01-01::2015-03-15", "GE.Adjusted"]) 
#head(ge)
#tail(ge)
#max.lag = floor((12*(length(ge)/100)^0.25))  #22
#adf.test = adfTest(ge@.Data, lags = 1 , type = "ct")
#adf.test@test
#summary(adf.test@test$lm)
#cat("\n AIC = ", AIC(adf.test@test$lm))
#cat("\n BIC = ", BIC(adf.test@test$lm), "\n")
#
#plot(ge)