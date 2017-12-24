diagnArima <- function(ar.par=c(1.2,-0.7),ma.par=c(0.7), d=0, p.test=2, d.test=1, 
                       q.test=1, sd=0.2, n.st=100, nobs=300, const=0, nforward=10, lb.lags=12)
{
        p <- length(ar.par); q <- length(ma.par);
        local.ts <- const + arima.sim(model = list(order=c(p,d,q), ar = ar.par, ma = ma.par), n=nobs+nforward, n.start=n.st, sd = sd)
        
        #---------------- Fit an ARIMA(p.test,d.test,q.test) -----------------#
        arima.mod = order = c(p.test, d.test, q.test)
        local.ts.mean = mean(local.ts)       # demean prior to fitting      
        local.ts.dm = local.ts - local.ts.mean
        arima.fit  =  Arima(local.ts.dm, order = arima.mod, method = "ML")
        
        #----------------------  Forecasting ----------------------#
        forc.co = forecast(arima.fit, nforward)
        
        #----------------------  Diagnose ----------------------#
        df  = nobs - arima.fit$n.cond - p.test - q.test
        AIC <- arima.fit$aic
        BIC <- arima.fit$bic
        Loglik <- arima.fit$loglik
        resid <- arima.fit$residual
        se.e <- sqrt(sum(resid^2)/df)
        JB.P <- jarque.bera.test(resid)$p.value
        LB.P <- Box.test(resid,  lag = 12, type = "Ljung-Box", fitdf = p+q)$p.value
        
        suppressWarnings(s.e <-  sqrt(diag(arima.fit$var.coef)))
        tstat = arima.fit$coef/s.e
        signif   =   2 * (1 - pt(abs(tstat), df)) < 0.05
        prop.sig =  100*sum(signif)/length(signif) 
        
        MAPE <- (1/nforward) * sum(abs(local.ts[(nobs+1):(nobs+nforward)]-forc.co$mean)/local.ts[(nobs+1):(nobs+nforward)])
        results <- c(AIC,BIC,Loglik,se.e,JB.P,LB.P,prop.sig,MAPE)
        return(results)}

performance <- c("AIC", "BIC", "LogLik", "Est.Err.Std","JB P-value", "LB P-value",'Prop.Sig','MAPE')
for (str in c('co.m.fit','ov.m.fit','un.m.fit')) { 
        eval(parse(text=paste(str,'<- matrix(NA,100,8,dimnames=list(NULL,performance))')))}

set.seed(74)
for (i in 1:100){
        co.m.fit[i,] <- diagnArima(p.test=2,q.test=1,d.test=0)
        ov.m.fit[i,] <- diagnArima(p.test=5,q.test=1,d.test=0)
        un.m.fit[i,] <- diagnArima(p.test=1,q.test=1,d.test=0)}

alldata<-lapply(1:8,function(i){cbind(co.m.fit[,i],ov.m.fit[,i],un.m.fit[,i])})
names(alldata) <- performance

# Boxplots
par(mfrow=c(3,3))
invisible(sapply(1:8,function(i){boxplot(alldata[[i]][,1],main='Correctfit',ylab=names(alldata)[i],col="steelblue")}))
par(mfrow=c(3,3))
invisible(sapply(1:8,function(i){boxplot(alldata[[i]][,2],main='Overfit',ylab=names(alldata)[i],col="mediumturquoise")}))
par(mfrow=c(3,3))
invisible(sapply(1:8,function(i){boxplot(alldata[[i]][,3],main='Underfit',ylab=names(alldata)[i],col="sandybrown")}))
par(mfrow=c(3,3))
invisible(sapply(1:8,function(i){boxplot(alldata[[i]],main='Co/Ov/Un',ylab=names(alldata)[i],col=c("steelblue","mediumturquoise","sandybrown"))}))