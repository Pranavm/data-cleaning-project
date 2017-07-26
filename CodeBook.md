## Code Book

### The Data Set
The Data Set Used for this project is the Human Activity Recognition Using Smartphones Dataset

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### Feature Selection 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

### Data Set Contents
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### Data Set Files

The data set contained the following files

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 


### Cleaning Data
For creating the tidy data only the following files were used 

- train/X_train.txt 
- test/X_test.txt
- train/y_train.txt
- test/y_test.txt
- train/subject_train.txt,
- test/subject_test.txt

In addition to these files features.txt was used obtain the variable names 
and activity_labels.txt to get the activity names

The functions in the rscript run_analysis.R performs the following trasformations on the data in the 6 files mentioned above 

#### mergeTrainAndTestData
This function performs the follwing transformations on the data

- STEP 1 : The X_train and X_test data are read in as data.table values, rbind is used to combine them    

```R
    combineddata  <- rbind(traindata, testdata)
```
- STEP 2 : Data in y_trains and y_test are read in as vectors, they are concatenated
```R
combinedlabels <- c(trainlabels, testlabels)
```
- STEP 3 : Data in subject_train and subject_test are read in as vectors, they are concatenated
```
combinedsubject <- c(trainsubject, testsubject)
```
- STEP 4 : cbind is used add y (activity label) and subject (the vectors created in STEP 2 & 3) as columns to the data.frame created in STEP1
```R
data <- cbind(Activity = combinedlabels, Subject = combinedsubject, combineddata)
```

NOTE:
- The cbind adds Activity and Subject as the first two columns
- write.table has row.names set to FALSE

#### extractMeanAndStd
This function takes the data.frame created by mergeTrainAndTestData and extracts the mean and sd data.

- STEP 1 : Read in the data.frame created by the mergeTrainAndTestData function
- STEP 2 : Read in the featurelist in the features.txt file as a vector
- STEP 3 : Use grep to find the indices of the features that give mean and std values
```R
meanstdfeatures <- grep("(-mean\\(\\))|(-std\\(\\))", featurelist)
```
- STEP 4 : Selects from the data.frame only those columns that correspond to the indices obtained above. Used select in dplyr to do this
```R
data <- data[, meanstdfeatures]
```
- STEP 5 : Writes the data from STEP 4 to file and returns it

NOTE:
-write.table has row.names set to FALSE

#### insertActivityNames
Reads in the data extracted by the previous functions and gives meaningfull names to activity labels

- STEP 1 : Reads the activity labels from activity.txt as data.frame
- STEP 2 : Reads in the data extracted by the previous function
- STEP 3 : Merges the data in the two data frames Using the activity_index since it,s present in both data frames
```R
data <- merge(data, activitytable, by.x = "V1", by.y = "V1")[,union(names(activitytable), names(data)),with = FALSE]
```
- STEP 4 : Drops the activity index column from the result, since activity name is sufficient
- STEP 5 : Writes back the data frame to the file

NOTE:
In STEP3 order of columns is maintained during merge

#### nameVariables
Reads in the data.frame from the previous function and gives meaningfull names to the variables

- STEP 1 : Reads in the data.frame from the previous function
- STEP 2 : Reads in the feature list from features.txt
- STEP 3 : Takes the subset of features with mean and std
- STEP 4 : Adds activity and Subject to the front of the feature list since those are the first two columns in the data frame
- STEP 5 : Set the names of the data frame to the feature list created at STEP 4
- STEP 6 : Writes back the frame to the file

#### getSubjectAndActivityAvg
Reads in the tidy data set from the previous function and creates anohter indepented tidy data set

- STEP 1 : Reads in the data.frame from the previous function
- STEP 2 : Use group_by function from the dplyr package to the data frame by Activity and Subject in that order
- STEP 3 : Use summarize_all function in the dplyer package to compute the average of each variable for each combination of activity and subject.  
```R
groupedbyactsub <- group_by(data, Activity, Subject)
newdata <- summarize_all(groupedbyactsub, mean)
```

- STEP 4 : Writes the new data.frame to file named tidy.txt
NOTE:
- write.table has row.names set to FALSE
- THe new data.frame has 180 rows corresponding to 6 activities with data for 30 subjects each and 68 columns of which 2 are the activity label and the subject id, the remaining 66 columns are the average of the 66 mean and std variables for those 180 activity and subject combinations

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
