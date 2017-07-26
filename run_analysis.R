library(dplyr)
library(data.table)
library(sqldf)

# Takes the data home directory as argument and combines the 
# files in the test and train directories and writes the resultant
# data.table to the "data" directory
# The inertial signal folder is ignored
mergeTrainAndTestData <- function(d = "UCI HAR Dataset") {
    combineddirpath = paste(d, "data", sep = "/")
    if (!dir.exists(combineddirpath)) {
        dir.create(combineddirpath)
    }
    combinedfilepath <- paste(d, "data", "data.txt", sep = "/")

    traindata     <- fread(paste(d, "train/X_train.txt", sep = "/"))
    testdata      <- fread(paste(d, "test/X_test.txt", sep = "/"))
    combineddata  <- rbind(traindata, testdata)
    
    trainlabels   <- scan(paste(d, "train/y_train.txt", sep = "/"), integer())
    testlabels    <- scan(paste(d, "test/y_test.txt", sep = "/"), integer())
    combinedlabels <- c(trainlabels, testlabels)
    
    trainsubject    <- scan(paste(d, "train/subject_train.txt", sep = "/"), integer())
    testsubject     <- scan(paste(d, "test/subject_test.txt", sep = "/"), integer())
    combinedsubject <- c(trainsubject, testsubject)
    
    data <- cbind(Activity = combinedlabels, Subject = combinedsubject, combineddata)
    write.table(data, combinedfilepath, row.names = FALSE, col.names = FALSE)
    data
}

#Takes the data file created by the mergeTrainAndTestData function
#And extracts only the mean and std columns and write backs to the file

extractMeanAndStd <- function(d = "UCI HAR Dataset") {
    datadirpath <- paste(d, "data", sep = "/")
    if (!dir.exists(datadirpath)) {
        mergeTrainAndTestData(d)
    }
    featurelist <- scan(paste(d, "features.txt", sep = "/"), list("",""))
    featurelist <- featurelist[[2]]
    meanstdfeatures <- grep("(-mean\\(\\))|(-std\\(\\))", featurelist) + 2
    meanstdfeatures <- c(1, 2, meanstdfeatures)
    datafilepath <- paste(d, "data/data.txt", sep = "/")
    data <- fread(datafilepath)
    data <- data[, meanstdfeatures, with = FALSE]
    write.table(data, datafilepath, row.names = FALSE, col.names = FALSE)
    data
}

#Inserts the descriptive names of the activities

insertActivityNames <- function(d = "UCI HAR Dataset") {
    datadirpath  <- paste(d, "data", sep = "/")
    datafilepath <- paste(datadirpath, "data.txt", sep = "/") 
    if (!dir.exists(datadirpath)) {
        mergeTrainAndTestData(d)
        extractMeanAndStd(d)
    }
    activityfilepath <- paste(d, "activity_labels.txt", sep = "/")
    activitytable <- read.table(activityfilepath)
    names(activitytable) <- c("V1", "Activity")
    data <- fread(datafilepath)
    #Merges the data by maitaining the order of columns
    data <- merge(data, activitytable, by.x = "V1", by.y = "V1")[,union(names(activitytable), names(data)),with = FALSE]
    data <- select(data, -V1)
    write.table(data, datafilepath, row.names = FALSE, col.names = FALSE)
    data
}

#Give descriptive names to variables

nameVariables <- function(d = "UCI HAR Dataset") {
    datadirpath  <- paste(d, "data", sep = "/")
    datafilepath <- paste(datadirpath, "data.txt", sep = "/")
    if (!dir.exists(datadirpath)) {
        mergeTrainAndTestData(d)
        extractMeanAndStd(d)
        insertActivityNames(d)
    }
    #Get the feature names
    featurelist <- read.table(paste(d, "features.txt", sep = "/"))
    featurelist <- featurelist[[2]]
    meanstdfeatures <- grep("(-mean\\(\\))|(-std\\(\\))", featurelist, value = TRUE)
    meanstdfeatures <- c("Activity", "Subject", meanstdfeatures)
    
    data <- read.table(datafilepath)
    names(data) <- meanstdfeatures
    write.table(data, datafilepath, row.names = FALSE)
    data
}

getSubjectAndActivityAvg <- function(d = "UCI HAR Dataset") {
    datadirpath  <- paste(d, "data", sep = "/")
    datafilepath <- paste(datadirpath, "data.txt", sep = "/")
    tidyfilepath <- paste(datadirpath, "tidy.txt", sep = "/")
    if (!dir.exists(datadirpath)) {
        mergeTrainAndTestData(d)
        extractMeanAndStd(d)
        insertActivityNames(d)
        nameVariables(d)
    }
    
    data <- read.table(datafilepath, header = TRUE)
    data <- data[2:nrow(data),]
    #Gruop by activity and average
    groupedbyactsub <- group_by(data, Activity, Subject)
    activitysummary <- summarize_all(groupedbyactsub, mean)
    write.table(activitysummary, tidyfilepath, row.names = FALSE)
    activitysummary
}
getSubjectAndActivityAvg()