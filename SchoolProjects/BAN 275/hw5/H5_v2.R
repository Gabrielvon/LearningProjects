"an.arima" = function( ar.par = 0.7, ma.par = 0.5, d = 1, 
                       p.test = 1, 
                       q.test = 1, 
                       d.test = 1,
                       const = 25, sd = .01, seed = 94721, nobs = 100,  
                       nforward = 20, lb.lags = c(6,12,18,24), verify = FALSE)
{
        library(forecast)     #94721
        library(timeSeries)
        library(tseries)   # for ts.plot() and jarque.bera.test()
        
        
        p = length(ar.par)
        q = length(ma.par)
        
        # check chosen parameters for non-stationarity & non-invertibility
        redo = FALSE
        if(p > 0){ ar.roots =  abs(polyroot(c(1,  - ar.par))) <= 1
                   if(sum(ar.roots) > 0){ cat("\n AR component is nonstationary", "\n")
                                          redo = TRUE }
        }
        if(q > 0){ ma.roots =  abs(polyroot(c(1,  - ma.par))) <= 1
                   if(sum(ma.roots)> 0){ cat("\n MA component is noninvertible", "\n")
                                         redo = TRUE }
        }
        if(redo){  return("Simulation not feasible.") } 
        
        
        
        #----------------- simulate an ARIMA(1,1,1) ----------------------------- 
        
        set.seed(seed)
        n.st = 100      # fixed start up
        
        cat(paste("\n\nSimulated: ARIMA(", ar.par, ",", d, ",", ma.par, ")\n\n", 
                  sep = ""))
        
        local.ts <- const + arima.sim(model = list(order=c(p,d,q), ar = ar.par,
                                                   ma = ma.par), n=nobs, n.start = n.st,  sd = sd)      
        
        #------------- creating a timeSeries object for plotting -----------------
        
        time = 1:(nobs+d)            # period counter
        local.ts <- timeSeries(local.ts, time)
        print(head(local.ts))
        plot(local.ts@.Data[,1], type="l", ylab = "y(t)")
        title(paste("ARIMA(", ar.par, ",", d, ",", ma.par, "1)", sep = ""))
        global.ts <<- local.ts
        
        # ---------  Identification step -----  ACF and PACF plots -----------------
        
        acf(local.ts@.Data[,1], lag.max = 12,  main = "ACF y(t)")
        acf(local.ts@.Data[,1], lag.max = 12, type = "partial", main = "PACF y(t)")
        if(d > 0) {
                d.local.ts = na.omit(diff(local.ts@.Data[,1], lag = 1, diff = d))
                acf(d.local.ts, lag = 12, main = "ACF  diff(y(t))")
                acf(d.local.ts, lag = 12, type = "partial", main = "PACF  diff(y(t))")
        }
        
        
        #----------------------  Fit an ARIMA(p.test,d.test,q.test)-------------------------------
        
        cat(paste("\n\nFitting: ARIMA(", p.test, ",", d.test, ",", q.test, ")\n", 
                  sep = ""))
        arima.mod = order = c(p.test, d.test, q.test)
        local.ts.mean = mean(local.ts)       # demean prior to fitting      
        local.ts.dm = local.ts - local.ts.mean
        arima.fit  =  arima(local.ts.dm, order = arima.mod, method = "ML")
        
        #-------  set up info for a parameter estimates table ---------------------
        
        df  = nobs - arima.fit$n.cond - p.test - q.test
        s.e =  round(sqrt(diag(arima.fit$var.coef)), 4)
        stack.par = round(c(arima.fit$coef),4) # ", arima.fit$model$ma), 4)
        tstat = round(stack.par/s.e, 4)
        
        #-------   Parameter Estimates Table ---------------------------------------
        
        cat("\nParameter Estimates Table (Demeaned Series)\n")        
        results = data.frame(matrix(0,(p.test+q.test),4))
        
        colnames(results) = c("Estimate", "Std.err", "t.stat", "p.value" ) 
        rnames = NULL
        
        if(p.test > 0) {
                for(i in 1:p.test){
                        rnames  = c(rnames, paste("ar", i, sep = ""))
                        results[i,] = c(arima.fit$coef[i], s.e[i], tstat[i], 
                                        2 * (1 - pt(abs(tstat[i]), df)))
                }
        }
        
        if(q.test > 0) {
                
                for(i in (p.test+1):(p.test+q.test)){
                        rnames  = c(rnames, paste("ma", (i-p.test), sep = ""))
                        results[i,] = c(arima.fit$coef[i], s.e[i], tstat[i],
                                        2 * (1 - pt(abs(tstat[i]), df)))
                }
        }
        
        rownames(results) = rnames
        print(round(results,6))
        cat("\n df = ", df)
        cat("\n var.e = ", sum(residuals(arima.fit)^2)/df)
        cat("\n se.e = ", sqrt(sum(residuals(arima.fit)^2)/df))
        cat("\n AIC = ", arima.fit$aic,"\n\n")      
        
        if(p.test > 0)
                cat("AR Polynomial roots = ", 
                    round(abs(polyroot(c(1,  - arima.fit$coef[1:p.test]))), 4), "\n")
        if(q.test > 0)
                cat("MA Polynomial roots = ", 
                    round(abs(polyroot(c(1,  - arima.fit$coef[(p.test+1):(p.test+q.test)]))), 4), "\n\n")
        
        
        #------------  Model Diagnostics for Validation  --------------------------
        #
        plot(residuals(arima.fit)/sqrt(arima.fit$sigma2), 
             main = "Standardized Residuals Plot", ylab = "Standardized Residuals" ) 
        
        abline(-3,0, lty= 2, col = "blue")
        abline(-2,0, lty= 2, col = "blue")
        abline( 2,0, lty= 2, col = "blue")
        abline( 3,0, lty= 2, col = "blue")
        
        
        
        
        #------------ Test residuals for normality 
        
        print(jarque.bera.test(residuals(arima.fit)))
        qqnorm(residuals(arima.fit), main = "Normal Probability Plot")
        
        #------------- Test for Autocorrelation
        
        lb.mat = matrix(0,length(lb.lags),3)
        dimnames(lb.mat) = list(NULL, c("To.Lag", "Statistic" , "p.value"))
        index = 1
        
        for (i in lb.lags){
                result  =  Box.test(residuals(arima.fit),  lag = i, 
                                    type = "Ljung-Box", fitdf = p.test+q.test)
                lb.mat[index,] =  c(i,result$statistic, result$p.value)
                index = index +1 
        }        
        
        acf(residuals(arima.fit), lag.max = 12,  main = 
                    paste("ACF Residuals(",p.test,",",d.test,",",q.test,")",seq=""))
        acf(residuals(arima.fit), lag.max = 12, type = "partial", 
            main = paste("PACF Residuals(",p.test,",",d.test,",",q.test,")",seq=""))
        
        
        cat("\n Ljung-Box Test\n" )
        print(lb.mat) 
        
        
}

"root.finder" = function(coefs = c(1,-0.7259,-0.0758 ), ar.order = T)
{
        # Program is set up to receive AR(p) roots from an arima.mle fit object.
        # as per Zivot and Wang page 83, for the characteristic eqn of the 
        # form a(z) = 1 - a1*z . . . ap*z^p = 0 
        # If used this way for AR coeffficients - stationarity requiress all unit roots to 
        # lie OUTSIDE the unit circle see the plot.
        # You can use the program for polynomials in the form a1*x^p + ... + ap*x + c = 0
        # by using the concatenate command c(c,a1, ... ap) in the function call 
        # The default plot axes limits are set at [-5,+5] in both dimensions. 
        # If a root falls outside this range you will get a warning. 
        
        coef = as.complex(coefs)
        p = length(coef)
        params <- vector("complex", p)
        if(!ar.order) {
                for(i in 1:p)
                        params[(p + 1 - i)] = coef[i]
        }
        else params <- coef
        roots <- polyroot(params)
        plot(roots, xlim = c(-5, 5), ylim = c(-5, 5))
        symbols(0, 0, circles = 1, add = T, inches = F, col = 5)
        cat("\n  Lag polynomial coefficients: ", coefs)
        cat("\n\n\t Polynomial Roots  \t Modulus \n")
        if(length(roots) == 1)
                cat("\n\t ", round(roots, digits = 4), "\t\t", round(abs(roots), digits = 4), "\n")
        else for(i in 1:length(roots))
                cat("\n \t ", round(roots[i], digits = 4), "\t\t", round(abs(roots[i]), digits = 4), "\n")
        cat("\n")
}


# pdf(file=paste("Allfigures-H5(WanliFeng)",".pdf"))
### For arima(0,0,2)
root.finder(coef=c(1,0.4,0.5),ar.order=F)
# Correct Model
suppressWarnings(an.arima(ar.par = 0, d = 0, ma.par = c(.4,0.5),
                          p.test=0, q.test=2, d.test=0, sd = 0.1, 
                          seed = 3595, verify = TRUE, nobs = 100))
# Over-fit Model
an.arima(ar.par = numeric(), d = 0, ma.par = c(.4,0.5), 
         p.test=0, q.test=3, d.test=0, sd = 0.1, 
         seed = 3595, verify = TRUE, nobs = 100)
# Under-fit Model
an.arima(ar.par = numeric(), d = 0, ma.par = c(.4,0.5), 
         p.test=0, q.test=1, d.test=0, sd = 0.1, 
         seed = 3595, verify = TRUE, nobs = 100)

### For arima(3,1,2)
root.finder(coef=c(1,0.3,-0.2,-0.2),ar.order=T)
root.finder(coef=c(1,0.4,0.5),ar.order=F)
# Correct Model
an.arima(ar.par = c(0.3,-0.2,-0.2), d = 2, ma.par = c(0.4,0.5),
         p.test=3, q.test=2, d.test=1, sd = 0.1,
         seed = 3595, verify = TRUE, nobs = 500)
# Over-fit Model
an.arima(ar.par = c(0.3,-0.2,-0.2), d = 2, ma.par = c(0.4,0.5), 
         p.test=4, q.test=2, d.test=1, sd = 0.1,
         seed = 3595, verify = TRUE, nobs = 500)
# Under-fit Model
an.arima(ar.par = c(0.3,-0.2,-0.2), d = 2, ma.par = c(0.4,0.5), 
         p.test=2, q.test=2, d.test=1, sd = 0.1,
         seed = 3595, verify = TRUE, nobs = 500)
# dev.off()