

set.seed(57)
e2 = 0.1*rnorm(8) # time series to use for MA?
e1 = 0.1*rnorm(3) # white noise?
e = c(e1,e2)

x1 =  arima.sim(model = list(order=c(0,0,2), ma = c(1.2,-0.8)), n=8, innov = e2, n.start =3, start.innov = e1  )   

x = rep(0,11) 
## Generate autocorrelated series.
# x[1] = e[1] 
# x[2] = e[2] + 1.2*e[1]
# x[3] = e[3] + 1.2*e[2] -0.8*e[1]
# x[4] = e[4] + 1.2*e[3] -0.8*e[2] 
# x[5] = e[5] + 1.2*e[4] -0.8*e[3] 

for(i in 6:11) x[i] = e[i] + 1.2*e[i-1] -0.8*e[i-2] 
head(x1,8)
x[4:11]
sum(abs(x[4:11] - head(x1,8)))

x1.ns =  arima.sim(model = list(order=c(0,1,2), ma = c(1.2,-0.8)), n=8, innov = e2, n.start =3, start.innov = e1  )   
head(x1.ns,8)
cumsum(c(0,x[4:10])) #??

