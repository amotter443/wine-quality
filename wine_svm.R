#Read in requisite packages
library(e1071)
library(purrr)
library(Metrics)
library(mlbench)
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


#Tune SVM to find best parameters
cv.svm<-tune(svm,type~.,data=train)
cv.svm$best.model

#Apply best model to test set
svm_model<-svm(type ~., data=train, type="C-classification",kernel="radial",epsilon=0.1,gamma=0.08333333,cost=1)
summary(svm_model)

#Predict type of wine based on model
svmfit<-predict(svm_model,newdata=test[,-13])
#Build confusion matrix
t<-table(true=test$type, svmfit)
t
#Use to determine accuracy and false positive rate
accuracy<-t[2,2]/(t[2,1]+t[2,2])
false_positive<-t[1,2]/(t[1,1]+t[1,2])
accuracy
false_positive

#Convert predicted values to numeric
svmfit = as.numeric(svmfit)
svmfit[which(svmfit==1)]<-0
svmfit[which(svmfit==2)]<-1

#Calculate area under ROC as performance metric
ROC_wine <- roc(test$type, svmfit)
plot(ROC_wine, col = "blue")
pROC::auc(ROC_wine)
