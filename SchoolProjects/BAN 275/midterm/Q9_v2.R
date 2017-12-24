
#Simulation 100 times
set.seed(74)
for (i in 1:20) { 
        da.sim <- arima.sim(model = list(order=c(2,1,1), ar = c(1.2,-0.7),
                                         ma = 0.7), n=310,  sd = 0.2)
        #Fitting ARIMA model
        co.m.fit <- Arima(da.sim,order=c(2,1,1),method='ML')
        ov.m.fit <- Arima(da.sim,order=c(5,0,1),method='ML')
        un.m.fit <- Arima(da.sim,order=c(1,0,1),method='ML')
        allfit <- list(co.m.fit,ov.m.fit,un.m.fit)
        
        #Forecasting
        forc.co = forecast(co.m.fit, 10)
        #         plot(forc.co,main='forcasting correct model')
        forc.co.mean = forc.co$mean
        forc.co.se   = forc.co$residuals
        forc.ov = forecast(ov.m.fit, 10)
        #         plot(forc.ov,main='forcasting overfit model')
        forc.ov.mean = forc.co$mean
        forc.ov.se   = forc.co$residuals
        forc.un = forecast(un.m.fit, 10)
        #         plot(forc.un,main='forcasting underfit model')
        forc.un.mean = forc.co$mean
        forc.un.se   = forc.co$residuals
        
        # Collect performance data
        # aic
        AIC[i,]<-sapply(allfit,function(x){x$aic}) 
        # bic
        BIC[i,] <- sapply(allfit,function(x){x$bic})
        # Loglikhood
        LogLik[i,] <- sapply(allfit,function(x){x$loglik})
        
        # Std error
        # Resid <- sapply(allfit, function(x){x$residual[1:300]})
        # df  <- sapply(allfit, 
        #               function(x){300 - x$n.cond - length(x$model$phi[x$model$phi!=0]) - 
        #                                   length(x$model$theta[x$model$theta!=0])})
        SE.E[i,] <- sapply(allfit,function(x){
                Resid <- x$residual[1:300]
                df  <- 300 - x$n.cond - length(x$model$phi[x$model$phi!=0]) - 
                        length(x$model$theta[x$model$theta!=0])
                se.e <- sqrt(sum(Resid^2)/df)
                se.e
        }
        )
        # JarqueBera p value
        JB.P[i,] <- sapply(allfit,function(x){
                Resid <- x$residual[1:300]
                jarque.bera.test(Resid)$p.value
        }
        )
        # LjungBox p value
        LB.P[i,] <- sapply(allfit,function(x){
                Resid <- x$residual[1:300]
                p <- length(x$model$phi[x$model$phi!=0])
                q <- length(x$model$theta[x$model$theta!=0])
                Box.test(Resid,  lag = 12, type = "Ljung-Box", fitdf = p+q)$p.value
        }
        )
        # Proportion of significant p-values
        # MAPE
        MAPE[i,] <- sapply(allfit, function(x){
                m <- 1/10 * sum(abs(da.sim[301:310]-forc.co$mean)/da.sim[301:310])
        })
        
}



### two graphics pages, 3x3 box-plots, correct vs. under-fitted and 
# correct vs over-fitted models???
boxplot(co.m.fit$model)




