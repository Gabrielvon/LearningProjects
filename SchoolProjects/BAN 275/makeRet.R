"make.returns" = function(ticker = "AAPL",
                          start = "2000-01-01::", subset = "2005-01-01::" )
{   library(quantmod)
    library(tseries)
    library(timeSeries)
    getSymbols(ticker, from = start)
    cat("\n Full Dataset Start Date: ")
    print(start(get(ticker)))
    cat("\n Subset series start date: ")
    print(start(get(ticker)[subset]))
    cat("\n Subset series end date: ")
    print(end(get(ticker)[subset]))
    local.df = data.frame(get(ticker)[subset])
    print(head(local.df,2))
    local.ts <- timeSeries(get(ticker)[subset])
    print(head(local.ts,2))
    par(mfrow = c(3, 3)) # display plots in a 3x3 matrix
    cat("\n Simple Daily Returns \n")
    # Assumes default source for the data - yahoo
    col.name = paste(ticker,".", "Adjusted",sep = "")
    ts.ret.d = dailyReturn(local.ts[,col.name],
                           type = "arithmetic")[-1]
    #
    cat("\n Class of returns object: "); print(class(ts.ret.d))
    print(head(ts.ret.d, 2))
    tail(ts.ret.d, 2)
    plot(ts.ret.d,  main = paste(ticker,
                                 " Returns \nSimple Daily Returns", sep = ""))
    #
    cat("\n Continuous Daily Returns \n")
    ts.ret.c = dailyReturn(local.ts[,col.name],type ="log")[-1]
    print(head(ts.ret.c, 2))
    tail(ts.ret.c, 2)
    plot(ts.ret.c,  main = paste(ticker,
                                 " Returns \nContinuous Daily Returns", sep = ""))
    #
    #some stat properties
    cat("\n\n", paste(ticker,
                      " Simple Daily Returns", "\n  Mean = \t",
                      colMeans(ts.ret.d), "\n  Stdev = \t",
                      colStdevs(ts.ret.d), sep = ""), "\n")
    cat("\n\n", paste(ticker, " Continuous Daily Returns",
                      "\n  Mean = \t", colMeans(ts.ret.c), "\n  Stdev = \t",
                      colStdevs(ts.ret.c), sep = ""), "\n")
    #
    hist(ts.ret.d, nclass = 12, main = paste(ticker,
                                             " Returns Adj for Split\nSimple Daily Returns",
                                             sep = ""), col = "steelblue")
    hist(ts.ret.c, nclass = 12, main = paste(ticker,
                                             " Returns Adj for Split \n Continuous Daily Ret.",
                                             sep = ""), col = "steelblue")
    #
    ####### ts.ret.c.daily <<- ts.ret.c
    #
    qqnorm(ts.ret.d, main = paste(ticker,
                                  " Returns\n Simple Daily Returns", sep = ""))
    qqnorm(ts.ret.c, main = paste(ticker,
                                  " Returns\n Continuous Daily Ret.", sep = ""))
    ##=========================================================
    cat("\n\n Compound Yearly Returns - Full Series \n")
    # A longer series
    yearly.ret = yearlyReturn(get(ticker), type = "log")
    print(head(yearly.ret,2))
    print(tail(yearly.ret,2))
    barplot(yearly.ret, main = paste(ticker,
                                     " Yearly Aggregated Returns", sep = ""),
            col= "steelblue")
    hist(yearly.ret, nclass = 6, main = paste(ticker,
                                              " Yearly Aggregated Returns", sep = ""), col = "blue")
    qqnorm(yearly.ret[-1],main=paste(ticker,
                                     " Yearly Aggregated Ret.", sep = ""))
    cat("\n Simple Daily Returns:");
    print(jarque.bera.test(ts.ret.d))
    cat("\n Compunded Daily Returns:")
    print(jarque.bera.test(ts.ret.c))
    cat("\n Compunded Yearly Returns:")
    print(jarque.bera.test(yearly.ret))
    #
    cat(paste("\n", ticker, " Compounded Yearly Returns",
              "\n  Mean = \t", colMeans(yearly.ret),
              "\n  Stdev = \t", colStdevs(yearly.ret), sep = ""))
    par(mfrow = c(1,1)) # reset to single graphics page
    cat("\n Done.") 
}
make.returns(ticker = "GS", start = "2000-01-01::",
             subset = "2005-01-01::")