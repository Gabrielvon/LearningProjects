# homework 7
rm(list=ls())
library(quantmod)
library(fUnitRoots)
library(tseries)
library(forecast)

FindArima = function(data, p=1, d=1, q=1, lb.lags = c(6,12,18,24), xreg=NULL
                     , include.mean=TRUE)
{
        library(timeSeries)
        library(tseries)   # for ts.plot() and jarque.bera.test()
        local.ts <- data
        nobs <- dim(data)[1]
        
        #----------------------  Fit an ARIMA(1,1,1)------------------------------
        arima.mod = c(p, d, q)
        local.ts.mean = sapply(data,mean)       # demean prior to fitting      
        local.ts.dm = local.ts - local.ts.mean
        arima.fit  =  arima(local.ts.dm, order = arima.mod, 
                            xreg=xreg, include.mean=include.mean, 
                            method = "ML")
        
        #-------  set up info for a parameter estimates table ---------------------
        df  = nobs - arima.fit$n.cond - p - q
        s.e =  round(sqrt(diag(arima.fit$var.coef)), 4)
        stack.par = round(c(arima.fit$coef),4)
        tstat = round(stack.par/s.e, 4)
        
        #-------   Parameter Estimates Table ---------------------------------------
        cat("\nParameter Estimates Table (Demeaned Series)\n\n")        
        results = data.frame(matrix(0,(p+q),4))
        
        colnames(results) = c("Estimate", "Std.err", "t.stat", "p.value" ) 
        rnames = NULL
        
        if(p > 0) {
                for(i in 1:p){
                        rnames  = c(rnames, paste("ar", i, sep = ""))
                        results[i,] = c(arima.fit$coef[i], s.e[i], tstat[i], 
                                        2 * (1 - pt(abs(tstat[i]), df)))
                }
        }
        
        if(q > 0) {
                
                for(i in (p+1):(p+q)){
                        rnames  = c(rnames, paste("ma", (i-p), sep = ""))
                        results[i,] = c(arima.fit$coef[i], s.e[i], tstat[i],
                                        2 * (1 - pt(abs(tstat[i]), df)))
                }
        }
        
        rownames(results) = rnames
        print(round(results,6))
        cat("\n df = ", df)
        cat("\n var.e = ", sum(residuals(arima.fit)^2)/df)
        cat("\n se.e = ", sqrt(sum(residuals(arima.fit)^2)/df))
        cat("\n AIC = ", arima.fit$aic, "\n\n")
        
        #------------  Model Diagnostics for Validation  ----------------------------
        plot(residuals(arima.fit)/sqrt(arima.fit$sigma2), 
             main = paste("Standardized Residuals Plot(",p,d,q,")"), 
             ylab = "Standardized Residuals" ) 
        
        abline(-3,0, lty= 2, col = "blue")
        abline(-2,0, lty= 2, col = "blue")
        abline( 2,0, lty= 2, col = "blue")
        abline( 3,0, lty= 2, col = "blue")
        
        
        #------------ Test residuals for normality   
        print(jarque.bera.test(residuals(arima.fit)))
        qqnorm(residuals(arima.fit), main = 
                       paste("Normal Probability Plot(",p,d,q,")"))
        
        
        #------------- Test for Autocorrelation
        lb.mat = matrix(0,length(lb.lags),3)
        dimnames(lb.mat) = list(NULL, c("To.Lag", "Statistic" , "p.value"))
        index = 1
        
        for (i in lb.lags){
                result  =  Box.test(residuals(arima.fit),  lag = i, 
                                    type = "Ljung-Box", fitdf = p+q)
                lb.mat[index,] =  c(i,result$statistic, result$p.value)
                index = index +1 
        }	
        
        acf(residuals(arima.fit), lag.max = 12,  main = 
                    paste("ACF Residuals(",p,d,q,")"))
        acf(residuals(arima.fit), lag.max = 12, type = "partial", 
            main = paste("PACF Residuals(",p,d,q,")"))
        
        cat("\n Ljung-Box Test\n\n" )
        print(lb.mat) 
        
        cat("\n ===========================  The end ==========================\n")
}

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
adf.GDP <- adfTest(diff(GDP.ts,1,1),lag=6,type='ct')
# ct: 12, 6, 1;
adf.GDP@test
summary(adf.GDP@test$lm)
# GDP ~ I(1)

### Fit an arima
FindArima(GDP.ts,1,1,1,xreg=1:length(GDP.ts))


################## CPIAUCSL ##################
getSymbols(Symbols='CPIAUCSL', src='FRED',from='1980-01-01',to='2005-01-01')
lc <- match(c('1980-01-01','2005-01-01'),row.names(as.matrix(CPIAUCSL)))
CPIAUCSL.ts <- ts(CPIAUCSL[lc[1]:lc[2]])
max.lag = floor((12*(length(CPIAUCSL.ts)/100)^0.25))
plot(CPIAUCSL.ts)
adf.CPIAUCSL <- adfTest(CPIAUCSL.ts,lag=2,type='ct')
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
FindArima(CPIAUCSL.ts,1,1,2,include.mean=T)


################## DEXUSEU ##################
getSymbols(Symbols='DEXUSEU', src='FRED',from='2002-01-01',to='2005-01-01')
lc <- match(c('2002-01-02','2004-12-31'),row.names(as.matrix(DEXUSEU))) #no data on 2005-01-01
DEXUSEU.ts <- ts(na.omit(DEXUSEU[lc[1]:lc[2]]))
max.lag = floor((12*(length(DEXUSEU.ts)/100)^0.25))
plot(DEXUSEU.ts)
adf.DEXUSEU <- adfTest(DEXUSEU.ts,lag=7,type='ct')
#ct: 19, 17, 7;
adf.DEXUSEU@test
summary(adf.DEXUSEU@test$lm)

### First differencing
plot(diff(DEXUSEU.ts,1,1))
adf.DEXUSEU <- adfTest(diff(DEXUSEU.ts,1,1),lag=19,type='c')
#ct: 19; #c: 19(good);
adf.DEXUSEU@test
summary(adf.DEXUSEU@test$lm)
# DEXUSEU ~ I(1) with constant

### Fit an arima
FindArima(DEXUSEU.ts,4,1,4,include.mean=T)


################## UNRATE ##################
getSymbols(Symbols='UNRATE', src='FRED',from='1980-01-01',to='2005-01-01')
lc <- match(c('1980-01-01','2005-01-01'),row.names(as.matrix(UNRATE)))
UNRATE.ts <- ts(UNRATE[lc[1]:lc[2]])
max.lag = floor((12*(length(UNRATE.ts)/100)^0.25))
plot(UNRATE.ts)
adf.UNRATE <- adfTest(UNRATE.ts,lag=14,type='ct')
#ct: 15; #c: 15, 12;
adf.UNRATE@test
summary(adf.UNRATE@test$lm)

### First differencing
plot(diff(UNRATE.ts,1,1))
adf.UNRATE <- adfTest(diff(UNRATE.ts,1,1),lag=,type='nc')
#ct: 15; #c: 15; #nc: 15, 2(good)
adf.UNRATE@test
summary(adf.UNRATE@test$lm)
# UNRATE ~ I(1)

### Fit an arima
FindArima(UNRATE.ts, 1,1,2)


################## INDPRO ##################
getSymbols(Symbols='INDPRO', src='FRED',from='1980-01-01',to='2005-01-01')
lc <- match(c('1980-01-01','2005-10-01'),row.names(as.matrix(INDPRO)))
INDPRO.ts <- ts(INDPRO[lc[1]:lc[2]])
max.lag = floor((12*(length(INDPRO.ts)/100)^0.25))
plot(INDPRO.ts)
adf.INDPRO <- adfTest(INDPRO.ts,lag=2,type='ct')
#ct: 15,13,2; #c: 15, 12, 2;
adf.INDPRO@test
summary(adf.INDPRO@test$lm)

plot(diff(INDPRO.ts,1,1))
adf.INDPRO <- adfTest(diff(INDPRO.ts,1,1),lag=2,type='c')
#ct: 15; #c: 15,10,2;
adf.INDPRO@test
summary(adf.INDPRO@test$lm)

# Fit an arima
FindArima(INDPRO.ts, 1,1,2, include.mean=T)


################## GE ##################
getSymbols(Symbols='GE', src='yahoo',from='2010-01-01',to='2015-03-15')
GE.ts <- ts(GE$GE.Adjusted)
max.lag = floor((12*(length(GE.ts)/100)^0.25))
plot(GE.ts)
adf.GE <- adfTest(GE.ts,,lag=22,type='nc')
#ct: 22; #c: 22; #nc:  22
adf.GE@test
summary(adf.GE@test$lm)

### First differencing
plot(diff(GE.ts,1,1))
adf.GE <- adfTest(diff(GE.ts,1,1),,lag=22,type='nc')
#ct: 22; #c: 22; #nc: 22
adf.GE@test
summary(adf.GE@test$lm)
# GE ~ I(1)

# Fit an arima
GE.fit <- FindArima(GE.ts, 0,1,0)

