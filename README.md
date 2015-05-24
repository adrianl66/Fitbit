# README
There are 4 files in this github repository
- run_analysis.R program which downloads, uncompresses and processes the data file and writes the tidy file output.txt
- output.txt which is the tidy file written by run_analysis.R
- Codebook.md markdown document which describes the output.txt variables
- This README.md markdown document which provides an overall high level explanation. For detailed program explanations
please refer to the comments in the run_analysis.R program file.

## Downloading the dataset and File structure used
The program downloads the raw data zip file into the current working directory and uncompresses it into the "UCI HAR Dataset" subdirectory which contains
- a) activity_labels.txt : Maps from integer to the activity label for example 1 is WALKING, 2 is WALKING_UPSTAIRS etc up to 6 which is LAYING
- b) features.txt : 561 Labels for c2) and d2)
- c) train directory which contains  
			c1) subject_train.txt : List of subject_ids  
			c2) X_train : training dataset observations with 561 columns (features)  
			c3) Y_train : training dataset activity_ids (coded as an integer from 1 to 6 as described in a)
- d) test directory which contains
			d1) subject_test.txt : List of subject_ids  
			d2) X_test : training dataset observations with 561 columns (features)  
			d3) Y_test: training dataset activity_ids (coded as an integer from 1 to 6 as described in a)

## The program then:
- Merges the training and test data set into one dataset
- Extracts only the measurements on the mean and standard deviation
- Uses descriptive activity names for the activities in the dataset
- Labels the dataset with descriptive and valid R names
- Creates a tidy dataset called "output.txt in the current working directory with the average of each variable for each activity and each subject
- Reads in and Views the tidy dataset in R Studio (Alternately you can read in the file  
yourself by using)    
read.table("./output.txt",header=TRUE,sep= " ")  