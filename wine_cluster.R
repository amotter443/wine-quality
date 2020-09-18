#Read in requisite packages
library(psych)
library(stats)

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



#Kmeans

#Calculate 2-4 k values of kmeans
k2<-kmeans(wine_data,2,nstart=50)
k3<-kmeans(wine_data,3,nstart=50)
k4<-kmeans(wine_data,4,nstart=50)

#Generate dsescriptive statistics about clusters
k2_stats<-describeBy(wine_data,k2$cluster)
k3_stats<-describeBy(wine_data,k3$cluster)
k4_stats<-describeBy(wine_data,k4$cluster)

#Generate difference between clusters
differences<-data.frame(round(abs(k2_stats[[1]][3]-k2_stats[[2]][3])/2), round(abs(k3_stats[[1]][3]-k3_stats[[2]][3]-k3_stats[[3]][3])/3),round(abs(k4_stats[[1]][3]-k4_stats[[2]][3]-k4_stats[[3]][3]-k4_stats[[4]][3])/4))
colnames(differences)<-c("k2","k3","k4")
differences

#Compare means of each group
k2_stats<-data.frame(k2_stats[[1]][3],k2_stats[[2]][3])
colnames(k2_stats)<-c("Group 1","Group 2")
k3_stats<-data.frame(k3_stats[[1]][3],k3_stats[[2]][3],k3_stats[[3]][3])
colnames(k3_stats)<-c("Group 1","Group 2","Group 3")
k4_stats<-data.frame(k4_stats[[1]][3],k4_stats[[2]][3],k4_stats[[3]][3],k4_stats[[4]][3])
colnames(k4_stats)<-c("Group 1","Group 2","Group 3","Group 4")
k2_stats
k3_stats
k4_stats

#Cbind cluster values to the dataset
clustered_wine_data<-cbind(wine_data,k2$cluster,k3$cluster,k4$cluster)

#Use elbow method to determine optimal k value
k_tot.wthnss <- sapply(1:10,function(x){kmeans(wine_data, x, nstart=50)$tot.withinss})
k_tot.wthnss

#Plot kmeans against total within clusters sum of squares
plot(1:10, k_tot.wthnss,type="b", pch = 1,xlab="K",ylab="Total within-clusters sum of squares")


#Hierarchical

#Comparing the 4 linkage methods to find the best one
hc.complete<-hclust(dist(wine_data), method="complete")
hc.average<-hclust(dist(wine_data), method="average")
hc.single<-hclust(dist(wine_data), method="single")
hc.centroid<-hclust(dist(wine_data), method="centroid")
k4_centroid<-cutree(hc.centroid, k=4)
k4_complete<-cutree(hc.complete, k=4)
k4_average<-cutree(hc.average,k=4)
k4_single<-cutree(hc.single,k=4)

#Comparing similarity of k4s
sum(k4_average==k4_single)
sum(k4_average==k4_centroid)
sum(k4_average==k4_complete)

#Average and Complete are most similar with 5101/6497 alligned, compare to k means k4 
sum(k4_complete==k4$cluster)
sum(k4_average==k4$cluster)

#Going with complete for minimum maximum distance between elements

#Plot complete hierarchical cluster
plot(hc.complete,main="Complete Linkage",xlab="",ylab="")

#Remove other plots & k4s
rm(list=c("hc.centroid","hc.single","hc.average","k4_average","k4_centroid","k4_single"))

#Finish making k splits for complete
k2_complete<-cutree(hc.complete, k=2)
k3_complete<-cutree(hc.complete, k=3)

#Generate dsescriptive statistics about clusters
k2_stats<-describeBy(wine_data,k2_complete)
k3_stats<-describeBy(wine_data,k3_complete)
k4_stats<-describeBy(wine_data,k4_complete)

#Generate difference between clusters
differences<-data.frame(round(abs(k2_stats[[1]][3]-k2_stats[[2]][3])/2), round(abs(k3_stats[[1]][3]-k3_stats[[2]][3]-k3_stats[[3]][3])/3),round(abs(k4_stats[[1]][3]-k4_stats[[2]][3]-k4_stats[[3]][3]-k4_stats[[4]][3])/4))
colnames(differences)<-c("k2","k3","k4")
differences

#Compare means of each group
k2_stats<-data.frame(k2_stats[[1]][3],k2_stats[[2]][3])
colnames(k2_stats)<-c("Group 1","Group 2")
k3_stats<-data.frame(k3_stats[[1]][3],k3_stats[[2]][3],k3_stats[[3]][3])
colnames(k3_stats)<-c("Group 1","Group 2","Group 3")
k4_stats<-data.frame(k4_stats[[1]][3],k4_stats[[2]][3],k4_stats[[3]][3],k4_stats[[4]][3])
colnames(k4_stats)<-c("Group 1","Group 2","Group 3","Group 4")
k2_stats
k3_stats
k4_stats

#Comparison to kmeans
clustered_wine_data<-cbind(clustered_wine_data,k2_complete,k3_complete,k4_complete)
sum(clustered_wine_data$k2_complete==clustered_wine_data$`k2$cluster`)
sum(clustered_wine_data$k3_complete==clustered_wine_data$`k3$cluster`)
sum(clustered_wine_data$k4_complete==clustered_wine_data$`k4$cluster`)

