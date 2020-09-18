#Read in requisite packages
library(e1071)
library(purrr)
library(Metrics)
library(mlbench)
library(keras)


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


#Indicate the y value as its own vector
train_targets<-train[,4]
train<-train[,c(1:3,5:13)]
test_targets<-test[,4]
test<-test[,c(1:3,5:13)]

#Calculate mean and sd to standardize x values
mean <- apply(train, 2, mean)
std <- apply(train, 2, sd)
train<- scale(train, center = mean, scale = std)
test<- scale(test, center = mean, scale = std)

#Create the model using the housing data model from housing-Kaggle2, except dropping 
#4 inputs each iteration to prevent overfitting
nn_model <- keras_model_sequential() %>% 
  layer_dense(units = 128, activation = "relu", 
              input_shape = dim(train)[[2]])    %>% 
  layer_dropout(rate=0.33) %>% 
  layer_dense(units = 64, activation = "relu") %>% 
  layer_dense(units = 32, activation = "relu") %>% 
  layer_dense(units = 1)

#View a summary of the model
summary(nn_model)

#Compile using RMSLE as the cost function loss value
nn_model %>% compile(optimizer = 'adam',loss = "mean_squared_logarithmic_error")
#Pass batches 1/10 of the training set through each epoch so there will be 10 iterations
#per epoch
nn_model %>% fit(train, train_targets,batch_size = 458, epochs=1000, verbose = 1)

#Use constructed model to predict test ys
nnfit<-predict_proba(nn_model,test)
#Measure RMSLE against actual ys 
error<-rmsle(test_targets,nnfit)
error #0.1698515
