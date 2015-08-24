---
title: "CodeBook"
author: "RohitMittal"
date: "August 23, 2015"
output: html_document
---

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:


```r
library(data.table)
library(dplyr)

setwd("C:/Users/mittroh/Desktop/Data Science Course Track/GettingCleaningData_3/Course Project/UCI HAR Dataset/train")
```

Files X_train, subject_train.txt and y_train are loaded into dataframes using corresponding names and converted into dataframes. 



```r
## TRAINING DATA
Y_train = read.csv('y_train.txt', header = FALSE, col.names = "Activity")
```

```
## Warning in file(file, "rt"): cannot open file 'y_train.txt': No such file
## or directory
```

```
## Error in file(file, "rt"): cannot open the connection
```

```r
subject_train = read.csv('subject_train.txt', header= FALSE, col.names = "Subject")
```

```
## Warning in file(file, "rt"): cannot open file 'subject_train.txt': No such
## file or directory
```

```
## Error in file(file, "rt"): cannot open the connection
```

```r
names <- read.csv("./../features.txt", sep="\n" ,header = FALSE, as.is = TRUE)
```

```
## Warning in file(file, "rt"): cannot open file './../features.txt': No such
## file or directory
```

```
## Error in file(file, "rt"): cannot open the connection
```

```r
names = as.vector(names[,1])
```

```
## Error in names[, 1]: object of type 'builtin' is not subsettable
```

```r
X_train = read.table('X_train.txt', header=FALSE)
```

```
## Warning in file(file, "rt"): cannot open file 'X_train.txt': No such file
## or directory
```

```
## Error in file(file, "rt"): cannot open the connection
```

```r
colnames(X_train) = as.vector(names)
```

```
## Error in as.vector(x, mode): cannot coerce type 'builtin' to vector of type 'any'
```

Once the data is loaded, it is saved into a single dataset Trainset:

```r
TrainSet = cbind(subject_train,Y_train,Type="Train",X_train)
```

```
## Error in cbind(subject_train, Y_train, Type = "Train", X_train): object 'subject_train' not found
```


Similarly for the test dataset:

```r
##TEST DATA
setwd("C:/Users/mittroh/Desktop/Data Science Course Track/GettingCleaningData_3/Course Project/UCI HAR Dataset/test")
Y_test = read.csv('y_test.txt', header = FALSE, col.names = "Activity")
subject_test = read.csv('subject_test.txt', header= FALSE, col.names = "Subject")
names <- read.csv("./../features.txt", sep="\n" ,header = FALSE, as.is = TRUE)
names = as.vector(names[,1])
X_test = read.table('X_test.txt', header=FALSE)
colnames(X_test) = as.vector(names)
TestSet = cbind(subject_test,Y_test,Type="Test",X_test)
```

Finally, once the training and test datasets are prepared, they are combined using rbind:

```r
##TRAINING AND TEST DATASET
CompleteData = rbind(TrainSet, TestSet)
```

```
## Error in rbind(TrainSet, TestSet): object 'TrainSet' not found
```

The combined dataset has more than 560 columns. Using grep function, column names containing the word 'mean' or 'std' are extracted. stdORmeanCol represent all these column numbers. This is then used to extract data from the combined dataset into a dataset called "CompleteDataSTD_MEAN"


```r
##COLUMNS HAVING STANDARD DEVIATION OR MEAN IN THEM
stdORmeanCol = c(grep("mean",colnames(CompleteData)),grep("std",colnames(CompleteData)))
CompleteDataSTD_MEAN = CompleteData[,c(1:3,stdORmeanCol)]
```

Next, we need to add descriptions for the activity type. This was found in the activity_labels.txt file. 
The descriptions were extracted and matched to the activity in the completeDataSTD_Mean[i,2]


```r
Activitynames <- as.vector(read.csv("./../activity_labels.txt", sep="\n" ,header = FALSE, stringsAsFactors = FALSE)[,1])
```

```
## Warning in file(file, "rt"): cannot open file './../activity_labels.txt':
## No such file or directory
```

```
## Error in file(file, "rt"): cannot open the connection
```

```r
ActivityDescription <-numeric(0)

for(i in 1:length(CompleteDataSTD_MEAN[,1]))
    ActivityDescription[i] = Activitynames[as.numeric(CompleteDataSTD_MEAN[i,2])]
```

```
## Error: object 'Activitynames' not found
```

```r
CompleteDataSTD_MEAN_ActDesc = cbind(CompleteDataSTD_MEAN[,c(1:3)],ActivityDescription,CompleteDataSTD_MEAN[4:dim(CompleteDataSTD_MEAN)[2]]) ##Add column of Activity Description next to the Activity column.
```

```
## Error in data.frame(..., check.names = FALSE): arguments imply differing number of rows: 10299, 0
```

```r
colnames(CompleteDataSTD_MEAN_ActDesc)
```

```
##  [1] "Subject"                            
##  [2] "Activity"                           
##  [3] "Type"                               
##  [4] "ActivityDescription"                
##  [5] "1 tBodyAcc-mean()-X"                
##  [6] "2 tBodyAcc-mean()-Y"                
##  [7] "3 tBodyAcc-mean()-Z"                
##  [8] "41 tGravityAcc-mean()-X"            
##  [9] "42 tGravityAcc-mean()-Y"            
## [10] "43 tGravityAcc-mean()-Z"            
## [11] "81 tBodyAccJerk-mean()-X"           
## [12] "82 tBodyAccJerk-mean()-Y"           
## [13] "83 tBodyAccJerk-mean()-Z"           
## [14] "121 tBodyGyro-mean()-X"             
## [15] "122 tBodyGyro-mean()-Y"             
## [16] "123 tBodyGyro-mean()-Z"             
## [17] "161 tBodyGyroJerk-mean()-X"         
## [18] "162 tBodyGyroJerk-mean()-Y"         
## [19] "163 tBodyGyroJerk-mean()-Z"         
## [20] "201 tBodyAccMag-mean()"             
## [21] "214 tGravityAccMag-mean()"          
## [22] "227 tBodyAccJerkMag-mean()"         
## [23] "240 tBodyGyroMag-mean()"            
## [24] "253 tBodyGyroJerkMag-mean()"        
## [25] "266 fBodyAcc-mean()-X"              
## [26] "267 fBodyAcc-mean()-Y"              
## [27] "268 fBodyAcc-mean()-Z"              
## [28] "294 fBodyAcc-meanFreq()-X"          
## [29] "295 fBodyAcc-meanFreq()-Y"          
## [30] "296 fBodyAcc-meanFreq()-Z"          
## [31] "345 fBodyAccJerk-mean()-X"          
## [32] "346 fBodyAccJerk-mean()-Y"          
## [33] "347 fBodyAccJerk-mean()-Z"          
## [34] "373 fBodyAccJerk-meanFreq()-X"      
## [35] "374 fBodyAccJerk-meanFreq()-Y"      
## [36] "375 fBodyAccJerk-meanFreq()-Z"      
## [37] "424 fBodyGyro-mean()-X"             
## [38] "425 fBodyGyro-mean()-Y"             
## [39] "426 fBodyGyro-mean()-Z"             
## [40] "452 fBodyGyro-meanFreq()-X"         
## [41] "453 fBodyGyro-meanFreq()-Y"         
## [42] "454 fBodyGyro-meanFreq()-Z"         
## [43] "503 fBodyAccMag-mean()"             
## [44] "513 fBodyAccMag-meanFreq()"         
## [45] "516 fBodyBodyAccJerkMag-mean()"     
## [46] "526 fBodyBodyAccJerkMag-meanFreq()" 
## [47] "529 fBodyBodyGyroMag-mean()"        
## [48] "539 fBodyBodyGyroMag-meanFreq()"    
## [49] "542 fBodyBodyGyroJerkMag-mean()"    
## [50] "552 fBodyBodyGyroJerkMag-meanFreq()"
## [51] "4 tBodyAcc-std()-X"                 
## [52] "5 tBodyAcc-std()-Y"                 
## [53] "6 tBodyAcc-std()-Z"                 
## [54] "44 tGravityAcc-std()-X"             
## [55] "45 tGravityAcc-std()-Y"             
## [56] "46 tGravityAcc-std()-Z"             
## [57] "84 tBodyAccJerk-std()-X"            
## [58] "85 tBodyAccJerk-std()-Y"            
## [59] "86 tBodyAccJerk-std()-Z"            
## [60] "124 tBodyGyro-std()-X"              
## [61] "125 tBodyGyro-std()-Y"              
## [62] "126 tBodyGyro-std()-Z"              
## [63] "164 tBodyGyroJerk-std()-X"          
## [64] "165 tBodyGyroJerk-std()-Y"          
## [65] "166 tBodyGyroJerk-std()-Z"          
## [66] "202 tBodyAccMag-std()"              
## [67] "215 tGravityAccMag-std()"           
## [68] "228 tBodyAccJerkMag-std()"          
## [69] "241 tBodyGyroMag-std()"             
## [70] "254 tBodyGyroJerkMag-std()"         
## [71] "269 fBodyAcc-std()-X"               
## [72] "270 fBodyAcc-std()-Y"               
## [73] "271 fBodyAcc-std()-Z"               
## [74] "348 fBodyAccJerk-std()-X"           
## [75] "349 fBodyAccJerk-std()-Y"           
## [76] "350 fBodyAccJerk-std()-Z"           
## [77] "427 fBodyGyro-std()-X"              
## [78] "428 fBodyGyro-std()-Y"              
## [79] "429 fBodyGyro-std()-Z"              
## [80] "504 fBodyAccMag-std()"              
## [81] "517 fBodyBodyAccJerkMag-std()"      
## [82] "530 fBodyBodyGyroMag-std()"         
## [83] "543 fBodyBodyGyroJerkMag-std()"
```


Finally, we group the data table by the subject and activity and find the mean for each of the mean/std variable and write it to the file "Final.txt""


```r
stdMeanDataTable = data.table(CompleteDataSTD_MEAN_ActDesc)

finalresult = datTabset[,lapply(.SD, mean), by=list(Subject,ActivityDescription), ]
setwd('./..')
write.table(finalresult, file="Final.txt", row.names=FALSE)
```
