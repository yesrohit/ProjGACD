
library(data.table)
library(dplyr)

setwd("C:/Users/mittroh/Desktop/Data Science Course Track/GettingCleaningData_3/Course Project/UCI HAR Dataset/train")


## TRAINING DATA
Y_train = read.csv('y_train.txt', header = FALSE, col.names = "Activity")
subject_train = read.csv('subject_train.txt', header= FALSE, col.names = "Subject")
names <- read.csv("./../features.txt", sep="\n" ,header = FALSE, as.is = TRUE)
names = as.vector(names[,1])

X_train = read.table('X_train.txt', header=FALSE)
colnames(X_train) = as.vector(names)
TrainSet = cbind(subject_train,Y_train,Type="Train",X_train)


##TEST DATA
setwd("C:/Users/mittroh/Desktop/Data Science Course Track/GettingCleaningData_3/Course Project/UCI HAR Dataset/test")
Y_test = read.csv('y_test.txt', header = FALSE, col.names = "Activity")
subject_test = read.csv('subject_test.txt', header= FALSE, col.names = "Subject")
names <- read.csv("./../features.txt", sep="\n" ,header = FALSE, as.is = TRUE)
names = as.vector(names[,1])
X_test = read.table('X_test.txt', header=FALSE)
colnames(X_test) = as.vector(names)
TestSet = cbind(subject_test,Y_test,Type="Test",X_test)

##TRAINING AND TEST DATASET
CompleteData = rbind(TrainSet, TestSet)


##COLUMNS HAVING STANDARD DEVIATION OR MEAN IN THEM
stdORmeanCol = c(grep("mean",colnames(CompleteData)),grep("std",colnames(CompleteData)))

CompleteDataSTD_MEAN = CompleteData[,c(1:3,stdORmeanCol)]

Activitynames <- as.vector(read.csv("./../activity_labels.txt", sep="\n" ,header = FALSE, stringsAsFactors = FALSE)[,1])
ActivityDescription <-numeric(0)

for(i in 1:length(CompleteDataSTD_MEAN[,1]))
    ActivityDescription[i] = Activitynames[as.numeric(CompleteDataSTD_MEAN[i,2])]

CompleteDataSTD_MEAN_ActDesc = cbind(CompleteDataSTD_MEAN[,c(1:3)],ActivityDescription,CompleteDataSTD_MEAN[4:dim(CompleteDataSTD_MEAN)[2]])
stdMeanDataTable = data.table(CompleteDataSTD_MEAN_ActDesc)

finalresult = datTabset[,lapply(.SD, mean), by=list(Subject,ActivityDescription), ]
setwd('./..')
write.table(finalresult, file="Final.txt", row.names=FALSE)

