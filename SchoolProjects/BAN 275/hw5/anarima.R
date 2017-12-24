"an.arima" = function( ar.par = 0.7, ma.par = 0.5, d = 1,
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
	

#----------------------  Fit an ARIMA(1,1,1)-------------------------------
	
	arima.mod = order = c(p, d, q)
	local.ts.mean = mean(local.ts)       # demean prior to fitting      
	local.ts.dm = local.ts - local.ts.mean
	arima.fit  =  arima(local.ts.dm, order = arima.mod, method = "ML")
	
	#-------  set up info for a parameter estimates table ---------------------
	
	df  = nobs - arima.fit$n.cond - p - q
	s.e =  round(sqrt(diag(arima.fit$var.coef)), 4)
	stack.par = round(c(arima.fit$coef),4) # ", arima.fit$model$ma), 4)
	tstat = round(stack.par/s.e, 4)
	
	#-------   Parameter Estimates Table ---------------------------------------
 
    cat("\nParameter Estimates Table (Demeaned Series)\n")	
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
	cat("\n se.e = ", sqrt(sum(residuals(arima.fit)^2)/df), "\n\n")
	
	if(p > 0)
		cat("AR Polynomial roots = ", 
             round(abs(polyroot(c(1,  - arima.fit$coef[1:p]))), 4), "\n")
	if(q > 0)
		cat("MA Polynomial roots = ", 
             round(abs(polyroot(c(1,  - arima.fit$coef[(p+1):(p+q)]))), 4), "\n\n")


	#------------  Model Diagnostics for Validation  --------------------------
	#-
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
                              type = "Ljung-Box", fitdf = p+q)
		 lb.mat[index,] =  c(i,result$statistic, result$p.value)
		 index = index +1 
	 }	
	
	acf(residuals(arima.fit), lag.max = 12,  main = "ACF Residuals")
	acf(residuals(arima.fit), lag.max = 12, type = "partial", 
                               main = "PACF Residuals")
   
	    
    cat("\n Ljung-Box Test\n" )
	print(lb.mat) 
	                                                                                



#------- Plot forecasts and forcast prediction intervals
	
	forc = predict(arima.fit, nforward)
	forc.mean = forc$pred[1:nforward]
	forc.se   = forc$se[1:nforward]
	quant     = qnorm(0.975)
	upper     = forc.mean + local.ts.mean + quant*forc.se # pred intervals
	lower     = forc.mean + local.ts.mean - quant*forc.se # pred intervals

	if(verify)  forecast.data = (cbind((forc.mean+ local.ts.mean), lower, upper))    
	
	y.hi      = max(local.ts@.Data[,1], upper, lower) # max value for the plot
	y.lo      = min(local.ts@.Data[,1], upper, lower) # min value for the pot
	filler    = c(rep(NA, (nobs+d)))              # Pad with NAs
	upper     = c(filler, upper)  
	lower     = c(filler, lower)  
	pad       = c(local.ts@.Data[,1], rep(NA,nforward ))
	
	
	plot(pad, type = "l", col = "blue", ylim = c(y.lo, y.hi), 
 		 main = paste("ARIMA(",p,",",d,",",q,")","\nForecast horizon = ",nforward, 
			          " periods.", sep = ""), ylab = "y(t)") 
	lines(c(filler[-1],local.ts@.Data[(nobs+d),1],forc.mean + local.ts.mean), 
		  col = "red", lwd = 1.5)

	lines(upper, col = "red", lwd = 1.5 )
	lines(lower, col = "red", lwd = 1.5 )
	abline(v = seq(0,(nobs+nforward),10), col="lightgray")
    abline(h = seq(y.lo,y.hi,(y.hi-y.lo)/10), col="lightgray")
	
	
	
# Verification 
    if(verify)
	{
	   cat("\n\n ========= forecast Package Results ============ \n") 	
	   library(forecast) 
       auto.fit = auto.arima(global.ts, d = 1, max.p = p, max.q = q)
       print(auto.fit)
       forc = forecast(auto.fit, h = nforward)
       print(forc) 
	   print(forecast.data)
       plot(forc)  
	}
	
		
  cat("\n ===========================  The end ==========================\n")


}

# demo in notes
an.arima(ar.par = c(-.5, .3), ma.par = c(.4,0.5),sd = 0.1, seed = 3595, verify = TRUE )

