##
rm(list=ls())


################ Read data ############################
s1.all <- read.csv('xi in class.csv')
s1 <- s1.all[,2]
s2 <- s1.all[,3]
s3 <- s1.all[,4]
s4 <- s1.all[,5]


##################################################################################
library(tseries)
plot.ts(s1)
acf(s1)
pacf(s1)
p <- 2;
d <- 0;
q <- 1;

arima.mod <- c(p,d,q)
s1.fit  =  arima(s1, order = arima.mod, method = "ML")

s.e =  round(sqrt(diag(s1.fit$var.coef)), 4)
stack.par = round(c(s1.fit$coef),4)    
tstat = round(stack.par/s.e, 4)						
s1.fit
tstat	
s1.fit$aic

plot(residuals(s1.fit)/sqrt(s1.fit$sigma2), 
     main = "Standardized Residuals Plot", ylab = "Standardized Residuals" ) 

jarque.bera.test(residuals(s1.fit))  

index <- 1;
lb.mat <- matrix(0,3,3)
dimnames(lb.mat) <- list(NULL, c('To.Lag', 'Statistic', 'p.value'))
for (i in c(6,12,18)){
        result  =  Box.test(residuals(s1.fit),  lag = i, 
                            type = "Ljung-Box", fitdf = p+q)
        lb.mat[index,] =  c(i,result$statistic, result$p.value)
        index = index +1 
}	
lb.mat  

acf(residuals(s1.fit), lag.max = 12,  main = "ACF Residuals")
acf(residuals(s1.fit), lag.max = 12, type = "partial", 
    main = "PACF Residuals")

#####################################################################

library(forecast)
auto.arima(s5)



### HW 
# Order: arima(p,d,q)
# Ljung-Box
# J-B
# Plot of residual
# AIC
