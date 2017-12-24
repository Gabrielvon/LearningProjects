setwd('/Users/gabrielfeng/Documents/R directory/BAN 275/hw8')
lrt <- read.csv('lrtwald(1).csv')
hackm <- read.csv('hachmwk(1).csv')
library(aod)
library(lmtest)
library(sandwich)

######--------------------------- Q1 ---------------------------######
## a)
lrt.fit <- lm(y~x.1+x.2+x.3,lrt)
# Create R and r
# B2=-3*B1 ===> 0*B0-3*B1-1*B2+0*B3=0
beta <- coef(lrt.fit)
R <- matrix(c(0,3,1,0), 1, 4)
r <- 0
# Run wald test
lrt.wald <- wald.test(vcov(lrt.fit), b=beta, L=R, H0=r)
wcp <- lrt.wald$result$chi2[3]
cat("Wald tes p.value = ", round(wcp,4), '\n')
lrt.wald.f <- wald.test(vcov(lrt.fit), b=beta, L=R, H0=r, df =lrt.fit$df.residual)
wfp <- lrt.wald.f$result$Ftest[4]
cat("Wald/2~F p.value = ", round(wfp,4), '\n')
# Comment: Both p value are close and larger than 0.05, which means we should 
# reject the H0. That is, the regress has is heteroscedastic.

## b)
# B2=-3*B1
lrt.fit.null <- lm(y~I(x.1-3*x.2)+x.3,lrt) # null
lrt.fit.alter <- lm(y~x.1+x.2+x.3,lrt) # alternative
# Log-likelihood Test
nobs=length(lrt.fit.null$residual)
LR <- nobs * (log(abs(sum(lrt.fit.null$coef)))-log(abs(sum(lrt.fit.alter$coef))))
1-pchisq(LR,lrt.fit.alter$df) # p-value
# Log-likelihood Test using lrtest()
lrtest(lrt.fit.null,lrt.fit.alter)
# Comment: Both p-value are larger than 0.05, which means we cannot reject H0. 
# That is, the model with restriction is better fit for the lrtwald data.

## Partial F-test
SSE.null <- sum(lrt.fit.null$residuals^2)
SSE.alter <- sum(lrt.fit.alter$residuals^2)
s1 <- (SSE.null - SSE.alter) / length(r)
s2 <- SSE.alter / lrt.fit.alter$df #(50-3-1)
fstat <- s1/s2 # fstat 
1-pchisq(fstat,1) # p-value
1-pf(fstat,1,lrt.fit$df.resid) # this is the correct way
# Comment: Same result as former one.

######--------------------------- Q2 ---------------------------######
head(hackm)
hackm.fit <- lm(y~x.1+x.2+x.3,hackm)
print(summary(hackm.fit))
bptest(hackm.fit)
# Comment: p-value is less than 0.05, which means we should reject H0. That is,
# The regression is heteroscedastic.

# Test to see if the coefficient on x3 is statistically significant using the 
# output from the lm fit and a HAC adjusted lm fit.
hackm.hac.se <- sqrt(diag(vcovHAC(hackm.fit)))
tbl <- summary(hackm.fit)$coefficients
tbl[,2] <- hackm.hac.se
tbl[,3] <- tbl[,1]/tbl[,2]
tbl[,4] <- 2*(1-pt(tbl[,3],hackm.fit$df.residual,lower.tail=F))
tbl
summary(hackm.fit)$coefficients
# Comment: Comparing coefficients from first fit and the fit after HAC adjucted, we find that
# estiamte of x.3 is significant in first fit, while it is not significant in the
# other fit.
