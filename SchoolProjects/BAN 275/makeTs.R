# This program takes a stock ticker, obtains the data, creates a
# timeSeries object, stores it
# globally, plots the data and a subset of the data.
# Packages Required:  timeseries, quantmod, xts and zoo to run.
make.ts = function(ticker = "AAPL", start = "2012-01-01::",
                      sub.from= "2013-01-01", return.it = FALSE )
{
        require(quantmod)
        require(timeSeries)
        require(tseries)
        # get the data
        getSymbols(ticker, from = start)
        # create a timeSereis object
        local.ts <- timeSeries(get(ticker))
        # global, permanent storage
        new.ts <<- local.ts
        # look at a few obs, works like print(local.ts[1:6, ])
        print(head(local.ts,2))
        par(mfrow=c(2,2))
        # plot values of Closing price
        y.range = range(local.ts[, 4])
        plot(local.ts[, 4], plot.type = "single",
             main = paste(ticker, " - ", start(local.ts),
                          " - ", end(local.ts), sep = "" ), ylim = y.range)
        # subset the data
        begin.date = sub.from
        end.date   = end(local.ts)
        smpl <- timeDate(local.ts@positions) > timeDate(begin.date)
        #plot the subset
        y.range = range(local.ts[smpl, 4])
        plot(local.ts[smpl, 4], plot.type = "single",
             main = paste(ticker, ": ", begin.date, " - ",
                          end.date, sep = "" ), ylim = y.range)
        #create a plot of total monthly volume –
        #aggregate monthly sum then plot to.monthly - quantmod
        local.ts.mvol <- to.monthly(as.xts(local.ts))
        head(local.ts.mvol)
        barplot((local.ts.mvol[,5]/10^6),
                main = paste(ticker,
                             " - Monthly Total Volume in Millions",
                             sep=""), col = "blue")
        #obtain end of month HLOC data
        chartSeries(local.ts.mvol, theme = "white")
        if(return.it)  return(local.ts) 
        else cat("\n") 
}
aapl.ts = make.ts( return.it = TRUE )
head(aapl.ts)
tail(aapl.ts)
class(aapl.ts)
