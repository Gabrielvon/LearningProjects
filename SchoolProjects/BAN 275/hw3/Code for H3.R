#Code for creating and answering assignment H3


# This is the code that generated the data along with the code
# that was needed to answer the H3 assignment. As such, it does not 
# need to read in from the .csv file!! I have primarily worked with 
# a data frame - except for the coercing to xts and timeSeries 
# objects for proper use of the lag() function. 

set.seed(1783)
e = rnorm(230, sd = 1)
acf(e, lwd=2)
acf(e, type = "partial",, lwd=2)

x1 =  arima.sim(list(order = c(1,0,0), ar = 0.8), n = 200, innov = e, n.start = 30 )
x2 =  arima.sim(list(order = c(1,0,0), ar = -0.8), n = 200, innov = e, n.start = 30 )
x3 =  arima.sim(list(order = c(2,0,0), ar = c(1.7, -.8)) , n = 200, innov = e, n.start = 30)
x4 =  e[31:230]
x5 = cumsum(e[31:230])

dt = data.frame(x1,x2,x3,x4,x5)

par(mfrow= c(1,2))
for(i in 1:ncol(dt)){
        acf(dt[,i], main = paste("ACF x",i,sep = ''),lwd = 2)
        acf(dt[,i],type = "partial",main = paste("PACF x",i,sep = ''),lwd = 2)
}


acf(diff(dt$x5),lwd = 2)
acf(diff(dt$x5), type = "partial", lwd = 2)
sum = sum(diff(dt$x5) - x4[-1])
cor(dt$x5,x4) 
cor(diff(dt$x5),x4[-1])


require(xts)   # for proper lag
fit = summary(lm(dt$x2 ~ lag(as.xts(dt$x2)), na.action = na.omit))
fit

# The above code executes properly on my pc 
# if it fails on your system use the timSeries version given below

require(timeSeries)
fit = summary(lm(dt$x2 ~ lag(as.timeSeries(dt$x2)), na.action = na.omit))
fit   

head(dt$x2,2)	
head(as.xts(dt$x2),2)
head(as.timeSeries(dt$x2))	
head(lag(as.xts(dt$x2)),2)
