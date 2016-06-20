## script Pre_process_data_tidy.R - but renamed run_analysis.R
## C Zingler 18-6-2016
## output tidy.txt



## remember set working directory prior to script run
## use getwd() - setwd() to achieve this



library(reshape2)  ## necessary for melt and dcast functions - install.packages("reshape") 			
                    ##needs to be run first if never loaded before


filename <- "UCI_dta.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename )  ## method="curl' not required if Windows pc
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

## Load activity labels (walking standing etc) + features - (type of measurement taken in 
## multi dimention)

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

## Extract only the data on mean and standard deviation (parse the data to only that required 
## for Analysis

featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)


## Load the datasets in to tables

train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

## merge datasets and add labels for subject and activity undertaken on measure

allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresWanted.names)

## turn activities & subjects into factors

allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

## split the tabular data on factors - then recombine as unique observations of means and std 
## deviations under observational variable colunm and observational readings row

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

## write the tidy data to a file called Tidy.txt for further analytics

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
