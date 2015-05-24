run_analysis <- function() {
    ## Downloads the Samsung dataset into the current working directory and unzips it
    ## Merges the training and test data set into one dataset
    ## Extracts only the measurements on the mean and standard deviation
    ## Uses descriptive activity names for the activities in the dataset
    ## Labels the dataset with descriptive and valid R names
    ## Creates a tidy dataset called "output.txt in the current working directory with the average of each variable for each activity and each subject
    ## Reads in and Views the tidy dataset in R Studio
  
    library(downloader) #Library for download function
    library(dplyr)
  
    getActivityName <- function(id = 1:6) {
        ## Function that returns the Activity Name in a string based on
        ## the parameter id it is called with
        ## Reads the activity_labels table with the id and returns the corresponding
        ## activity name
    
        if (id < 1 || id > 6) {
            # There are only 6 valid activity types
            print("Invalid Activity ID")
            return (NULL)
        } else {
            # Return associated activity name as a character string
            return(as.character(activity_labels[id,]$V2))
        }
    }
  
    ## download data file and uncompress it into the "UCI HAR Dataset" directory
    ## which contains
    ## a) activity_labels.txt : Maps from integer to the activity label
    ##    for example 1 is WALKING, 2 is WALKING_UPSTAIRS etc up to 6 which is LAYING
    ## b) features.txt : 561 Labels for c2) and d2)
    ## c) train directory which contains
    ##    c1) subject_train.txt : List of subject_ids
    ##    c2) X_train : training dataset observations with 561 columns (features)
    ##    c3) Y_train : training dataset activity_ids (coded as an integer from 1 to 6 as described in a)
    ## d) test directory which contains
    ##    d1) subject_test.txt : List of subject_ids
    ##    d2) X_test : training dataset observations with 561 columns (features)
    ##    d3) Y_test: training dataset activity_ids (coded as an integer from 1 to 6 as described in a)
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download(url,dest="dataset.zip",mode="wb")
    unzip("dataset.zip")
    
    ## set working directory
    setwd("./UCI HAR Dataset")
  
    ## read activity labels and features
    activity_labels <- read.table("./activity_labels.txt")
    features <- read.table("./features.txt")
  
    ## Find Column names which have "mean" and "std" in their names
    ## Build an index so that we can subset the data later
    meanStdColIndex <- grepl("mean|std",features$V2) #Index where TRUE means the column names contain "mean" or "std"
    meanStdColNames <- grep("mean|std",features$V2, value = TRUE) #List of Column Names
  
    ## Valid names in R must not have "(",")" or "-" so remove those
    meanStdColNames <- gsub("\\(","",meanStdColNames)
    meanStdColNames <- gsub("\\)","",meanStdColNames)
    meanStdColNames <- gsub("-","",meanStdColNames)
  
    ## read training dataset data
    setwd("./train")
    training_subjects <- read.table("./subject_train.txt")
    training_data <- read.table("./X_train.txt")
    training_data_activity_ids <- read.table("./Y_train.txt")
  
    ## modify column name to a descriptive name "SubjectID", "Activity ID"
    training_subjects <- tbl_df(training_subjects)
    training_subjects <- rename(training_subjects,SubjectID=V1)
  
    training_data_activity_ids <- tbl_df(training_data_activity_ids)
    training_data_activity_ids <- rename(training_data_activity_ids, ActivityID = V1)
  
    # For the training_data Select only the columns containing "mean" and "std" in their names
    training_data <- training_data[,meanStdColIndex]
    colnames(training_data) <- as.character(meanStdColNames) #add in the column names
  
    ## Add in the descriptive activity names using the getActivityName function described earlier
    training_data_activity_ids <- mutate(training_data_activity_ids, ActivityID = getActivityName(ActivityID))
  
    ## Read test dataset data
    setwd("../test")
  
    test_subjects <- read.table("./subject_test.txt")
    test_data <- read.table("./X_test.txt")
    test_data_activity_ids <- read.table("./Y_test.txt")
  
    ## modify column name to a descriptive name "SubjectID", "Activity ID"
    test_subjects <- tbl_df(test_subjects)
    test_subjects <- rename(test_subjects,SubjectID=V1)
  
    test_data_activity_ids <- tbl_df(test_data_activity_ids)
    test_data_activity_ids <- rename(test_data_activity_ids, ActivityID = V1)
  
    # For the test_data Select only the columns containing "mean" and "std" in their names
    test_data <- test_data[,meanStdColIndex]
    colnames(test_data) <- as.character(meanStdColNames) #add in the column names
  
    ## Add in the descriptive activity names using the getActivityName function defined earlier
    test_data_activity_ids <- mutate(test_data_activity_ids, ActivityID = getActivityName(ActivityID))
  
    ## Back up to the original working directory (which contains the UCI HAR Dataset directory)
    ## Write output tidy dataset here
    setwd("../../")
  
    ## Combine training observations and activity_ids (X_train & Y_train)
    df_train <- cbind(training_subjects,training_data_activity_ids,training_data)
  
    ## Combine test observations and activity_ids (X_train & Y_train)
    df_test <- cbind(test_subjects,test_data_activity_ids,test_data)
  
    ## Combine test and training dataset
    df <- rbind(df_train,df_test)
    #print(" Combined test and training data dimensions")
    #print(dim(df))
  
    df <- tbl_df(df)
  
    ## Calculate average of each variable for each activity and each subject
    df <- group_by(df,ActivityID,SubjectID) # group by ActivityId and SubjectID
    df <- summarise_each(df,funs(mean)) #get mean of each column
  
    print("Tidy Dataset Dimensions")
    print(dim(df))
    
    ## Write tidy dataset to file
    write.table(df,"./output.txt",row.name=FALSE)
    
    ## View the tidy dataset
    df_new <- read.table("./output.txt",header=TRUE,sep= " ")
    View(df_new)
  
}