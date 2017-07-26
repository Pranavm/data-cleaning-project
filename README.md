## data-cleaning-project

This project was created as part of the data-cleaning course in coursera. 
The repo contains
    - run_analysis.r, An r script that can be used to create an independant tidy data set from the UCI HAR Dataset
    - The code book that explains the trasformations performed on the data to obtain the tidy data

NOTE:
For more informations of the data set and the transformations performed on the data see the CodeBook.md

The run_analysis.r script contains the following functions

#### mergeTrainAndTestData
takes the path of the UCI HAR Directory path as arguments and creates a single file by combining the training and test data

If no argument is provided to the function it is assumed that the data directry is named "UCI HAR Dataset" and is present in the present working directory 

#### extractMeanAndStd
Takes a single argument, the path of the data directory, default is "UCI HAR Dataset"

Returns the data.frame with only mean and std columns extracted from the data set

Also writes the extracted data back to the data.txt file

#### insertActivityNames
Takes a single argument, the path of the data directory, default is "UCI HAR Dataset"

Returns the data.frame with the activity indices replaced by activity names

Also writes the result to the data.txt file

#### nameVariables
Takes a single argument, the path of the data directory, default is "UCI HAR Dataset"

Returns the data.frame with the default column values replaced with the names given in the features.txt files

Also writes the result to data.txt file

#### getSubjectAndActivityAvg
Takes a single argument, the path of the data directory, default is "UCI HAR Dataset"

Returns a new tidy data.frame with the average of all mean and std values for each activity and each subject. For more info see the CodeBook.md

Writes the result to tidy.txt file

Running the script

- Clone the repo
- From the directory that contains the data set, run the following command from the R Console

```R
source("path/to/repo/data-cleaning-project/run_analysis")
```

This will write the two tidy data sets to "UCI HAR Dataset/data/data.txt" and "UCI HAR Dataset/data/tidy.txt"

If the data directory is not named appropriately this will throw errors

In that case after sourceing the file ignore the errors and from the r console call

```R
getSubjectAndActivityAvg()
```

NOTES:
- The functions write to the same file, so they should be executed in the order given here, otherwise you might get unpredictable results

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.


