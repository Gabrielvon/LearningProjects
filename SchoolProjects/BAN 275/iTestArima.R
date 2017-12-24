iTestArima = function(arima.fit, nobs, lb.lags = c(6,12,18,24))
        
        # nobs, a strictly positive integer, is length of output
        # series fitting arima.fit, before un-differencing. 
        
{
        library(timeSeries)
        library(tseries)   # for ts.plot() and jarque.bera.test()
        p <- length(arima.fit$model$phi[arima.fit$model$phi!=0])
        q <- length(arima.fit$model$theta[arima.fit$model$theta!=0])
        d <- length(arima.fit$model$Delta[arima.fit$model$Delta!=0])
        
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
        cat("\n AIC = ", arima.fit$aic)
        cat("\n BIC = ", arima.fit$bic, "\n\n")
        
        #------------  Model Diagnostics for Validation  ----------------------------
        plot(residuals(arima.fit)/sqrt(arima.fit$sigma2), 
             main = paste("Standardized Residuals Plot(",p,d,q,")"), 
             ylab = "Standardized Residuals" ) 
        
        abline(-3,0, lty= 2, col = "blue")
        abline(-2,0, lty= 2, col = "blue")
        abline( 2,0, lty= 2, col = "blue")
        abline( 3,0, lty= 2, col = "blue")
        
        
        
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