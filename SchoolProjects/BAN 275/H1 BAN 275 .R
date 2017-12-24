

# 1) Use the quantmod getSymbols() function to get your stock data for the period 2013-01-01 to 2014-12-31, from yahoo. (You will need “from” and “to” arguments here.)  
# 2) Plot the data for the closing stock price.
# 3) Use a quantmod function to obtain the daily log returns for the closing stock price. 
# 4) Plot the data for the daily closing log returns for the stock.
# 5) Create a histogram for the returns data. 
# 6) Find the maximum closing price for each week and plot that data.



#install.packages(quantmod)

library(quantmod)

# 1)
getSymbols('SPY',src='yahoo')
spy.sub <- SPY['2013-01-01::2014-12-31',]

# 2)
chartSeries(spy.sub,theme='white',TA =
                    "addBBands();addVo();addEMA()")
plot(spy.sub[,'SPY.Close'],main="The Closing Stock Price", xlab="Date",ylab="Price")

# 3)
d.log.ret <- dailyReturn(spy.sub,type='log')

# 4)
par(col.axis='black',mfrow=c(2,1),mar=c(3,4,3,1))
plot(d.log.ret,main='Daily Closing Log Return',xlab='Date',ylab='Log Return')

# 5)
hist(d.log.ret,breaks=30,col='blue',main='Daily Closing Log Return',xlab='Date',ylab='Log Return')

# 6)
w.max <- apply.weekly(spy.sub,FUN=function(x) { max(Cl(x)) } )
plot(w.max)
