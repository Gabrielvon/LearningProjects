library(timeSeries)
require(urca)
emp = read.csv("Employment.csv")
#head(uscndf)
emp = timeSeries(emp[,2:3])
head(emp)
plot(emp, main = "Employment")
ca.test = ca.jo(emp, "eigen", "trend", 5, spec = "transitory")
#ca.test.sum =
summary(ca.test)

n.eq = ncol(uscnts)
alpha.hat = matrix(0, n.eq, n.eq)
for(i in 1:n.eq)alpha.hat[, i] = ca.test@W[,i]/ca.test@Vorg[1,i]
cat("\n\n Unnormalized Adjustment Coefficients\n")
print(alpha.hat)

long.imp = alpha.hat%*%t(ca.test@Vorg[1:n.eq,1:n.eq]) 
cat("\n\n Long Run Impact Matrix: alpha*beta'\n") 
print(long.imp)

cat("\n\n Gamma matrix coefficients'\n")
ca.test@GAMMA

plot(ca.test)
plotres(ca.test)
cajorls(ca.test, r = 1)
summary(ca.po(cbind(y1,y2), demean = "constant", lag = "short" , type = "Pz"))