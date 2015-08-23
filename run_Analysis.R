library(plyr)
setwd("D:\\Documents\\Downloads\\GCD\\Week 3\\Docs\\UCI HAR Dataset")

dataSubTrain <- read.table(file.path("train","subject_train.txt"),header=F)
dataSubTest <- read.table(file.path("test","subject_test.txt"),header=F)


dataActTrain <- read.table(file.path("train","Y_train.txt"),header=F)
dataActTest <- read.table(file.path("test","Y_test.txt"),header=F)


dataFeaturesTrain <- read.table(file.path("train","X_train.txt"),header=F)
dataFeaturesTest <- read.table(file.path("test","X_test.txt"),header=F)

#str(dataSubTrain)
#str(dataSubTest)
#str(dataActTrain)
#str(dataActTest)
#str(dataFeaturesTrain)
#str(dataFeaturesTest)

dataSubject<-rbind(dataSubTrain,dataSubTest)
dataActivity<-rbind(dataActTrain,dataActTest)
dataFeatures<-rbind(dataFeaturesTrain,dataFeaturesTest)

names(dataSubject) <-c("subject")
names(dataActivity) <-c("activity")

featurColNnames<-read.table("features.txt",header=F)
names(dataFeatures) <-featurColNnames$V2

#featurColNnames

#mergedData<-merge(dataSubject,dataActivity)
mergedData<-cbind(dataSubject,dataActivity)
#mergedData
mergedData<-cbind(dataFeatures,mergedData)
#mergedData


#dataSubject
#dataActivity

subsetFeatureNames<-featurColNnames$V2[grep("mean\\(\\)|std\\(\\)", featurColNnames$V2)]

selNames<-c(as.character(subsetFeatureNames), "subject", "activity" )
#selNames
mergedData<-subset(mergedData,select=selNames)
str(mergedData)



actLabels <- read.table("activity_labels.txt",header = F)

names(mergedData)<-gsub("^t", "time", names(mergedData))
names(mergedData)<-gsub("^f", "frequency", names(mergedData))
names(mergedData)<-gsub("Acc", "Accelerometer", names(mergedData))
names(mergedData)<-gsub("Gyro", "Gyroscope", names(mergedData))
names(mergedData)<-gsub("Mag", "Magnitude", names(mergedData))
names(mergedData)<-gsub("BodyBody", "Body", names(mergedData))

#names(mergedData)




dataOutput <- aggregate(. ~subject + activity, mergedData, mean)
dataOutput<-dataOutput[order(dataOutput$subject,dataOutput$activity),]
write.table(dataOutput, file = "tidyOutput.txt",row.name=FALSE)

