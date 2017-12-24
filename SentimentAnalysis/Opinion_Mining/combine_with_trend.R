library(data.table)
require(quantmod)
require(reshape)
require(plyr)
library(caret)
train = fread("prepdata_v1.csv",data.table=FALSE)
getSymbols('AAPL',from='2014-10-07')
AAPL = AAPL[1:254,] #2014/10/08-2015/10/08
delta=data.frame(d=index(Cl(AAPL)),return=as.numeric(Delt(Cl(AAPL))))
delta$trend = rep(NA,nrow(delta))
for(i in 2:nrow(delta)){
  if (delta[i,2]>0){
    delta$trend[i] = 1
  }
  if (delta[i,2]<0){
    delta$trend[i] = 0
  }
}
delta = delta[-1,]
colnames(delta)[1]="Fixeddates"
delta$Fixeddates= as.character(delta$Fixeddates)

######predict the effect on the same day######
train1 = merge(train,delta,by="Fixeddates",all.x=T)
train1 = train1[order(rev(train1$Fixeddates)),] 
train1 = na.omit(train1)
#write.csv(train1,"text_trend_1.csv",row.names=F)
set.seed(10086)
index = createDataPartition(train1$trend,p=0.7,list=F)
training = train1[index,]
testing = train1[-index,]
testing_x = testing[,-4]
testing_y = testing[,4]
write.csv(training,"train_trend_1.csv",row.names=F)
write.csv(testing_x,"test_trend_1.csv",row.names=F)
write.csv(testing_y,"y_trend_1.csv",row.names=F)
#####Reduce the opinions less that 10 characters#####
# remove_list = c()
# for(i in 1:nrow(train1)){
#   if (nchar(train1[i,"Articles"])<60){
#     remove_list = c(remove_list,i)
#   }
# }

###########################
##Evaluation 
###########################
###Naive Bayes
y_nb =read.csv("TF-IDF_NB.csv")
confusionMatrix(testing_y,y_nb[,3]) ##55.78% - chi2 : 70000;  55.84%- chi:10000
#hist(y_nb[,3])
###SGD
y_sgd =read.csv("TF-IDF_SGD.csv")
confusionMatrix(testing_y,y_sgd[,3]) ##57.14%  - chi2 : 70000;  57.89%- chi:10000
#hist(y_sgd[,3])

#hist(testing_y)


#####training 
y_nb_train = read.csv("TF-IDF_NB_train.csv")
confusionMatrix(training[,4],y_nb_train[,3]) ##97.7% - chi2 : 70000;  96.19%- chi:10000
y_sgd_train = read.csv("TF-IDF_SGD_train.csv")
confusionMatrix(training[,4],y_sgd_train[,3]) ##99.15% - chi2 : 70000;  92.13%- chi:10000


########Diagonsis: Overfitting problems



