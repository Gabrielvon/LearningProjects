"sim.reg" = function(n = 50, k = 5, reps = 1000, seed = 30)
{
	set.seed(seed)
	x <- matrix(runif(n * k), n, k)
	betas <- 20 + 15 * runif(k + 1)
	ones <- rep(1, n)
	x <- cbind(ones, x)
	y <- x %*% betas + rnorm(n)
	cat("\n Initial betas: ", betas) 
	ols.fit <- lm(y ~ (-1) + x)
	summary(ols.fit)
	#single run
	cat("\n  \t\t\t Population\t\tEstimate \n")
	for(i in 1:(k + 1)) {
		cat("\n Beta[",(i-1), "]: ",betas[i] , "\t\t",ols.fit$coefficients[i] )
	}
	# Estimated Beta distributions - fixed betas - vary X and e
	Betas <- matrix(0, reps, (k + 1))
	index = 1
	while(index <= reps) {
		x <- matrix(runif(n * k), n, k)
		x <- cbind(ones, x)
		y <- x %*% betas + rnorm(n)
		ols.fit <- lm(y ~ (-1) + x)
		Betas[index,  ] <- ols.fit$coefficients
		index <- index + 1
	}
	
	par(mfrow = c(3, 3))
	for(i in 1:(k + 1))
		{   
		   hist(Betas[, i], xlab = paste("Beta ", (i-1), sep = ""))
 	       qqnorm(Betas[, i], xlab = paste("Beta ",(i-1), sep = "") )
         
       }
	
	means   = apply(Betas, 2, mean)
		
	cat("\n  \t\t\t Population\t\t Average Estimate \n")
	for(i in 1:(k + 1)) {
		cat("\n Beta[",(i-1), "]: ",betas[i] , "\t\t",means[i] )
	}	
	
    cat("\n")
}



sim.reg()