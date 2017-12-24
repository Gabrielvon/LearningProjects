install.packages("fUnitRoots")
require("fUnitRoots")

df = read.csv("xi in class.csv")

max.lag = floor((12*(length(df$x1)/100)^0.25))

#x1
adf.test = adfTest(df$x1, lag = 3, type = "c")
adf.test@test
summary(adf.test@test$lm)


#x2
adf.test = adfTest(df$x2, lag = 4, type = "nc")
adf.test@test
summary(adf.test@test$lm)

adf.test = adfTest(diff(df$x2), lag = 3, type = "nc")
adf.test@test
summary(adf.test@test$lm)

#x3
adf.test = adfTest(df$x3, lag = 5, type = "ct")
adf.test@test
summary(adf.test@test$lm)

adf.test = adfTest(diff(df$x3), lag = 4, type = "nc")
adf.test@test
summary(adf.test@test$lm)

adf.test = adfTest(diff(df$x3,1,2), lag = 3, type = "nc")
adf.test@test
summary(adf.test@test$lm)


#x4
adf.test = adfTest(df$x4, lag = 3, type = "ct")
adf.test@test
summary(adf.test@test$lm)

#slotNames(adf.test@test$lm$residuals)
#residuals(adf.test@test$lm)