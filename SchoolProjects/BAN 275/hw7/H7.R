# homework 7

# Rate of process:
# GDP, DEXUSEU and GE have problem. Others done.

rm(list=ls())
library(quantmod)
library(fUnitRoots)
library(tseries)
library(forecast)

################## GDP ##################
getSymbols(Symbols='GDP', src='FRED',from='1980-01-01',to='2005-10-01')
lc <- match(c('1980-01-01','2005-10-01'),row.names(as.matrix(GDP)))
GDP.ts <- ts(GDP[lc[1]:lc[2]])
max.lag = floor((12*(length(GDP.ts)/100)^0.25))

plot(GDP.ts)
adf.GDP <- adfTest(GDP.ts,lag=8,type='c')
# ct: 12, 8; c: 12, 8;
adf.GDP@test
summary(adf.GDP@test$lm)

### First differencing
plot(diff(GDP.ts,1,1))
adf.GDP <- adfTest(diff(GDP.ts,1,1),lag=1,type='ct')
# ct: 12, 6, 1;
adf.GDP@test
summary(adf.GDP@test$lm)
# GDP ~ I(1)

### Fit an arima
FindArima(GDP.ts,1,1,1,xreg=1:length(GDP.ts))

# auto.arima(GDP.ts)
# auto.arima(GDP.ts,d=1)
# auto.arima(GDP.ts,d=2)
# auto.arima(GDP.ts,d=3)
# auto.arima(GDP.ts,ic='bic')
# auto.arima(GDP.ts,ic="bic")


################## CPIAUCSL ##################
getSymbols(Symbols='CPIAUCSL', src='FRED',from='1980-01-01',to='2005-01-01')
lc <- match(c('1980-01-01','2005-01-01'),row.names(as.matrix(CPIAUCSL)))
CPIAUCSL.ts <- ts(CPIAUCSL[lc[1]:lc[2]])
max.lag = floor((12*(length(CPIAUCSL.ts)/100)^0.25))
plot(CPIAUCSL.ts)
adf.CPIAUCSL <- adfTest(CPIAUCSL.ts,lag=12,type='ct')
#ct: 15, 13, 12, 11, 10, 2;
adf.CPIAUCSL@test
summary(adf.CPIAUCSL@test$lm)

### First differencing
plot(diff(CPIAUCSL.ts,1,1))
adf.CPIAUCSL <- adfTest(diff(CPIAUCSL.ts,1,1),lag=11,type='c')
#ct: 15; #c: 15, 11(good);
adf.CPIAUCSL@test
summary(adf.CPIAUCSL@test$lm)
# CPIAUCSL ~ I(1) with constant

### Fit an arima
CPIAUCSL.fit <- FindArima(CPIAUCSL.ts,0,1,2,xreg=1:length(CPIAUCSL.ts))
CPIAUCSL.fit <- FindArima(CPIAUCSL.ts,4,2,4,include.mean=FALSE)
CPIAUCSL.fit <- FindArima(CPIAUCSL.ts,1,0,1,xreg=1:length(CPIAUCSL.ts),include.mean=TRUE)
auto.arima(CPIAUCSL.ts,d=1,xreg=1:length(CPIAUCSL.ts))
auto.arima(CPIAUCSL.ts,d=0,stationary=T,allowdrift=T) # ARIMA(1,1,2) with drift  
### CPI is not done yet ###


################## DEXUSEU ##################
getSymbols(Symbols='DEXUSEU', src='FRED',from='2002-01-01',to='2005-01-01')
lc <- match(c('2002-01-01','2004-12-31'),row.names(as.matrix(DEXUSEU))) #no data on 2005-01-01
DEXUSEU.ts <- ts(na.omit(DEXUSEU[lc[1]:lc[2]]))
max.lag = floor((12*(length(DEXUSEU.ts)/100)^0.25))
plot(DEXUSEU.ts)
adf.DEXUSEU <- adfTest(DEXUSEU.ts,lag=2,type='ct')
#ct: 19, 17, 7;
adf.DEXUSEU@test
summary(adf.DEXUSEU@test$lm)

### First differencing
plot(diff(DEXUSEU.ts,1,1))
adf.DEXUSEU <- adfTest(diff(DEXUSEU.ts,1,1),lag=19,type='c')
#ct: 20; #c: 19(good);
adf.DEXUSEU@test
summary(adf.DEXUSEU@test$lm)
# DEXUSEU ~ I(1) with constant

# ### Second differencing
# plot(diff(DEXUSEU.ts,1,2))
# adf.DEXUSEU <- adfTest(diff(DEXUSEU.ts,1,2),lag=20,type='nc')
# #ct: 20; #c: 20; #nc: 20(good)
# adf.DEXUSEU@test
# summary(adf.DEXUSEU@test$lm)
# DEXUSEU ~ I(2)

### Fit an arima
DEXUSEU.fit <- FindArima(DEXUSEU.ts,3,1,4,xreg=1:length(DEXUSEU.ts))#aic = -25146.3
fDEXUSEU.fit <- FindArima(DEXUSEU.ts,4,1,4,xreg=1:length(DEXUSEU.ts))#aic = -25146.3
# for all d(1) with constant, cannot pass normality test??
DEXUSEU.fit <- FindArima(DEXUSEU.ts,0,2,0)#aic = -25146.33
# for all d(2) and d(1), cannot pass normality test.??
summary(DEXUSEU.fit)
auto.arima(DEXUSEU.ts) # ARIMA(0,1,0) AIC=-28028.94


################## UNRATE ##################
getSymbols(Symbols='UNRATE', src='FRED',from='1980-01-01',to='2005-01-01')
lc <- match(c('1980-01-01','2005-01-01'),row.names(as.matrix(UNRATE)))
UNRATE.ts <- ts(UNRATE[lc[1]:lc[2]])
max.lag = floor((12*(length(UNRATE.ts)/100)^0.25))
UNRATE.ts <- ts(UNRATE)
plot(UNRATE.ts)
adf.UNRATE <- adfTest(UNRATE.ts,lag=12,type='c')
#ct: 15; #c: 15, 12;
adf.UNRATE@test
summary(adf.UNRATE@test$lm)

### First differencing
# plot(diff(UNRATE.ts,1,1))
# adf.UNRATE <- adfTest(diff(UNRATE.ts,1,1),lag=9,type='nc')
# #ct: 15; #c: 15; #nc: 15, 9(good)
# adf.UNRATE@test
# summary(adf.UNRATE@test$lm)
# # UNRATE ~ I(1)

### Fit an arima
UNRATE.fit <- FindArima(UNRATE.ts, 4,0,0) ##??
summary(UNRATE.fit)
auto.arima(UNRATE.ts,d=1) # ARIMA(2,1,2)


################## INDPRO ##################
getSymbols(Symbols='INDPRO', src='FRED',from='1980-01-01',to='2005-01-01')
lc <- match(c('1980-01-01','2005-10-01'),row.names(as.matrix(INDPRO)))
INDPRO.ts <- ts(INDPRO[lc[1]:lc[2]])
max.lag = floor((12*(length(INDPRO.ts)/100)^0.25))
INDPRO.ts <- ts(INDPRO)
plot(INDPRO.ts)
adf.INDPRO <- adfTest(diff(INDPRO.ts,1,1),,lag=11,type='ct')
#ct: 15, 11;
adf.INDPRO@test
summary(adf.INDPRO@test$lm)

# ### First differencing
# plot(diff(INDPRO.ts,1,1))
# adf.INDPRO <- adfTest(diff(INDPRO.ts,1,1),,lag=2,type='c')
# #ct: 15, 10; #c: 15, 10, 2(good);
# adf.INDPRO@test
# summary(adf.INDPRO@test$lm)
# # INDPRO ~ I(1)

# Fit an arima
INDPRO.fit <- FindArima(INDPRO.ts, 4,0,3) ##???
summary(INDPRO.fit)
auto.arima(INDPRO.ts) # ARIMA(1,2,2)

################## GE ##################
getSymbols(Symbols='GE', src='yahoo',from='2010-01-01',to='2015-03-15')
GE.ts <- ts(GE$GE.Adjusted)
max.lag = floor((12*(length(GE.ts)/100)^0.25))
plot(GE.ts)

### First differencing
plot(diff(GE.ts,1,1))
adf.GE <- adfTest(diff(GE.ts,1,1),,lag=22,type='nc')
#ct: 22; #c: 22; #nc:  22
adf.GE@test
summary(adf.GE@test$lm)

### Second differencing
plot(diff(GE.ts,1,2))
adf.GE <- adfTest(diff(GE.ts,1,2),,lag=22,type='nc')
#ct: 22; #c: 22; #nc: 22(good);
adf.GE@test
summary(adf.GE@test$lm)
# GE ~ I(2)

# Fit an arima
GE.fit <- FindArima(GE.ts, 2,2,2)
summary(GE.fit)
auto.arima(GE.ts,d=2) #AIC=61.44
auto.arima(GE.ts,d=1) #AIC=45.67
auto.arima(GE.ts,xreg=1:length(GE.ts)) # ARIMA(0,1,0) AIC=45.8
