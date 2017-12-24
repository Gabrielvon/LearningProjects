"Wald.ex"<- function() { n=30
                         set.seed(30)
                         x1 <- runif(n)
                         x2 <- runif(n)
                         y <- 2 + .3*x1 + .7*x2 + rnorm(n)
                         #=============== THE HARD WAY ========================= 
                         my.fit <- summary(lm(y ~ x1 +x2))
                         R <- matrix(0,2,3)
                         R[1,1]<- 1
                         n.r = length(R)
                         R[2,2:3] <- 1
                         cat("\n\n Structure of R \n")
                         print(R)
                         r<- c(2,1)
                         n.r = length(r)
                         cat("\n\n Structure of vector r \n")
                         print(r)
                         beta <- coef(my.fit)[,1]
                         avarRb <- R%*%vcov(my.fit)%*%t(R)
                         Wald<- t(R%*%beta - r)%*%solve(avarRb)%*%(R%*%beta - r)
                         p.value = pchisq(Wald,n.r,lower.tail = FALSE)
                         # F stat Wald/2
                         p.value.f = pf(Wald/n.r,n.r,n-n.r-1, lower.tail = FALSE)
                         cat("\n Wald test the hard way. p.value = ",
                             round(p.value,4),"\n")
                         cat("\n Wald/2~F test the hard way. p.value = ",
                             round(p.value.f,4), "\n")
                         #============= THE EASIER WAY – aod Package ==============
                         require(aod)
                         wcp = wald.test(vcov(my.fit),b=beta,L=R,H0=r)$result$chi2[3] 
                         cat("\n Wald tes p.value = ", round(wcp,4), "\n")
                         wfp = wald.test(vcov(my.fit),b=beta,L=R,H0=r, df =
                                                 my.fit$df[2$result$Ftest[4]])
                         cat("\n Wald/2~F p.value = ", round(wfp,4),"\n")
}

x1 = 10+ 20*runif(25)
x2 = 10+ 20*runif(25)
y = 40 + 3*x1 - 5*x2 + .05*x2 +rnorm(25)
fit = lm(y ~ x1 + x2)
require(lmtest)
bptest(fit,~ x1 * x2 + I(x1^2) + I(x2^2))
