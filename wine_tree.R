#Read in requisite packages
library(randomForest)
library(tree)
library(Metrics)
library(purrr)
library(pROC)

#Read in data
wine_data<-read.csv("winequality.csv")[2:14]
wine_data$type[wine_data$type==2]<-0
#0 is red
#1 is white

#Split into training-test with 70-30 split
set.seed(314)
train_ind <- sample(seq_len(nrow(wine_data)), size = floor(0.7 * nrow(wine_data)))
train <- wine_data[train_ind, ]
test <- wine_data[-train_ind, ]


#3.1. Predict classification into white and red wines

#Determine which random forest model has the highest accuracy based on the number of features included
rfs<-map(1:12,function(x)randomForest(as.factor(type)~.,mtry=x,wine_data,importance=TRUE))
accuracy<-map_dbl(1:12,function(x)rfs[[x]]$confusion[1,3]+rfs[[x]]$confusion[2,3])
accuracy<-round((1-accuracy)*100,3)
accuracy_results<-data.frame(NumFeatures=seq(1:12),accuracy)
accuracy_results
max(accuracy_results$accuracy)

#Highest accuracy with 4/5 features, going with 5
error.table<-rfs[[5]]$confusion[,1:2]
error.table
accuracy<-error.table[2,2]/(error.table[2,1]+error.table[2,2])
false_positive<-error.table[1,2]/(error.table[1,1]+error.table[1,2])
accuracy
false_positive

#Examine importance of each individual feature
importance<-rfs[[5]]$importance[,3:4]
rffitted<-predict(rfs[[5]],newdata=test[,-13])

#Convert predicted values to numeric
rffitted = as.numeric(rffitted)
rffitted[which(rffitted==1)]<-0
rffitted[which(rffitted==2)]<-1

#Calculate area under ROC as performance metric
ROC_wine <- roc(test$type, rffitted)
plot(ROC_wine, col = "blue")
pROC::auc(ROC_wine)

#3.2. Predict sugar contents

#Determine which random forest model has the lowest RMSLE based on the number of features included
rfs<-map(1:12,function(x)randomForest(residual.sugar~.,mtry=x,train,importance=TRUE))
error<-map_dbl(1:12,function(x)min(rfs[[x]]$mse))
#Save the results in their own dataframe
error_results<-data.frame(NumFeatures=seq(1:12),error)
error_results
min(error_results$error)

#Using 9 features has lowest MSE at 1.992916
#Determine the importance of each variable by node purity or % change
importance<-rfs[[9]]$importance
rffitted<-predict(rfs[[9]],newdata=test[-4])
rmsle(test$residual.sugar,rffitted)


