library(timeSeries)
library(quantmod)
library(tseries)

setwd('/Users/gabrielfeng/Documents/R directory/BAN 275/hw3')
dt <- read.csv('H3 x1-x5(1).csv')[,-1]

#Q1:
par(mfcol=c(2,2))
for ( i in 1:5) {
        t.acf <- acf(dt[,i],50)
        t.pacf <- pacf(dt[,i],50)
}

#Q2
x4 <- dt$x4
x5 <- dt$x5
acf(diff(x5))
acf(diff(x5), type = "partial")
sum = sum(diff(x5) - x4[-1])
cor(x5,x4) 
cor(diff(x5),x4[-1])

#Q3
require(xts)   # for proper lag
x2 <- timeSeries(dt$x2)
fit.lag <- summary(lm(x2 ~ lag(x2), na.action = na.omit))
fit.lag


#################test for as.xts##################
# for numeric object
rm(x2)
x2.num <- dt[,2]
x2.ts <- as.xts(x2.num)
summary(lm(x2.ts ~ lag(x2.ts), na.action = na.omit))

# for data frame object
rm(x2)
x2.df <- as.data.frame(x2)
x2.ts <- as.xts(x2.df)
fit.lag <- summary(lm(x2.ts ~ lag(x2.ts), na.action = na.omit))

# for timeserises object without using as.xts
rm(x2)
x2 <- dt[,2]
x2.ts <-as.timeSeries(x2)
fit.lag <- summary(lm(x2.ts ~ lag(x2.ts), na.action = na.omit))

# my way
x2.ts <- timeSeries(dt$x2)
fit.lag <- summary(lm(x2.ts ~ lag(x2.ts), na.action = na.omit))
fit.lag

