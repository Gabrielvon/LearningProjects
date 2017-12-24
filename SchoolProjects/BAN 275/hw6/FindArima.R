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


setwd("/Users/gabrielfeng/Documents/R directory/GabRdirectory/BAN 275/hw6")
data <- read.csv('xi in class.csv')
library('forecast')

x1 <- data['x1']
FindArima(x1,1,0,0)
str(x1)
FindArima(x1,2,0,0)
FindArima(x1,3,0,0)
FindArima(x1,2,1,0)
FindArima(x1,2,2,0)
FindArima(x1,2,0,1)
FindArima(x1,2,0,2)
cat('FindArima(2,0,1) is probably the best fit for x1.')
x1.best <- auto.arima(x1)
x1.best # ARIMA(2,0,1) with non-zero mean 

x2 <- data['x2']
FindArima(x2,1,0,0)
FindArima(x2,2,0,0)
FindArima(x2,3,0,0)
FindArima(x2,2,1,0)
FindArima(x2,2,2,0)
FindArima(x2,2,1,1)
FindArima(x2,2,1,2)
cat('FindArima(2,1,1) is probably the best fit for x2.')
x2.best <- auto.arima(x2)
x2.best # ARIMA(2,1,1)

x3 <- data['x3']
FindArima(x3,1,0,0)
FindArima(x3,2,0,0) #In log(s2) : NaNs produced
FindArima(x3,3,0,0) #In sqrt(diag(arima.fit$var.coef)) : NaNs produced
FindArima(x3,2,1,0)
FindArima(x3,2,2,0) #In sqrt(diag(arima.fit$var.coef)) : NaNs produced
FindArima(x3,2,3,0)
FindArima(x3,2,2,1)
FindArima(x3,2,2,2)
cat('FindArima(2,2,1) is probably the best fit for x3.')
x3.best <- auto.arima(x3)
x3.best # ARIMA(2,2,1)

x4 <- data['x4']
FindArima(x4,1,0,0)
FindArima(x4,2,0,0)
FindArima(x4,3,0,0)
FindArima(x4,2,1,0)
FindArima(x4,2,2,0)
FindArima(x4,2,1,1)
FindArima(x4,2,1,2)
cat('FindArima(2,1,1) is probably the best fit for x4.')
x4.best <- auto.arima(x4)
x4.best # ARIMA(2,1,1) with drift 
#should add drift
#x4.best <- auto.arima(x4,xreg=1:nrow(x3))

x4.best.1 <- auto.arima(x4,allowdrift=F,stepwise=F,trace=T) #ARIMA(1,1,2)
x4.best.1
FindArima(x4,1,1,2)

x4.best <- auto.arima(x4)
x4.best
arima(x4,order=c(2,0,1),xreg=1:dim(x4)[1]) #the best fit from professor Sessions.The reason is revealed by the plot of x4.
auto.arima(x4,xreg=1:dim(x4)[1]) # can also be done in this way.

# Step
# 1. Stationary or not: If non-stationary, adjust the data to stationary
# 2. adjust other factor, such seasonal, trend(detrend)
# 3. acf/pacf plot to estimate the order
# 4. play around your estimated orders and observe the AIC
# 5. Select the model with the lowest AIC.


