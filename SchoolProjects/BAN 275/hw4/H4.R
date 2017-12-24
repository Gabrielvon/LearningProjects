
# Question 1
acf.plus = function(ticker = "AAPL", start = "2010-01-01::",   col.name = "Close") {
        library(timeSeries)
        library(quantmod)
        library(tseries)
        
        #For acf and pacf plot
        p.acf <- function (data,title) {
                acf(data,na.action=na.pass,main=title)
                pacf(data,na.action=na.pass,main=title)
        }
        
        #Geting data and plot ts and ts.diff
        dat = getSymbols(ticker, from = start,  
                         auto.assign = 
                                 getOption("get.Symbols.auto.assign",FALSE),
                         )
        ts = as.timeSeries(Cl(dat))
        par(mfrow=c(1,2))
        plot(ts,main='Original Close') 
        ts.diff <- diff(ts)
        plot(ts.diff,main='Difference of Close')
        
        #plot acf and pacf
        par(mfrow=c(2,2))
        p.acf(ts,'ts')
        p.acf(ts.diff,'ts.diff')
        
        #Computing log return and plot
        cl.log.ret <- log(ts[-1]/ts[-nrow(ts)])
        #par(mfrow=c(1,1))
        plot(cl.log.ret,type='l',main='Log Return')
        
        #Convert into ma()
        library(forecast)
        #par(mfrow=c(1,2))
        cl.log.ret.ma <- ma(cl.log.ret,7)
        plot(cl.log.ret.ma,lwd=1,type='l',main='MA of Log Return')        
        p.acf(cl.log.ret.ma,'cl.log.ret.ma')
        
        #Regress
        summary(lm(ts~lag(ts)))
        
}

acf.plus('SPY')



# Question 2
# Plot the original triangle
par(mfrow=c(1,1))
curve(1-abs(x),-2,2, xlim=c(-2,2),main='Stationary Triangle',xlab='Phi.1',ylab='Phi.2')
curve(-x^2/4,-2,2,add=T)
abline(h=-1)

# Determine the space under condition (1) and (2)
cat('The space is inside the blue boundaries')
curve(abs(x)-1,-1,1,add=T,col='blue')
curve(1-abs(x),-1,1,add=T,col='blue')

# The proporting inside the region
prop <- 1 - (2*2*0.5)/(0.5*2*4)
cat('The proportion for question a) is', prop)

# Test the pairs I chose
cat('The two pairs I choose is c(-1.2, -0.9) and c(0.7, -0.8)')
z1 <- c(-1.2, -0.9)
z2 <- c(0.7, -0.8)
z1.rt<-polyroot(c(1,-z1))
z2.rt<-polyroot(c(1,-z2))
abs(z1.rt)
abs(z2.rt)
cat('Both z1 and z2 are greater than 1')

# Simulation
par(mfrow=c(1,2))
x1 <- arima.sim(list(order = c(2,0,0), ar = z1), n = 200, n.start = 30 )
acf(x1)
x2 <- arima.sim(list(order = c(2,0,0), ar = z2), n = 200, n.start = 30 )
acf(x2)
