#==============================================================================
# run_analysis.R
#
# Run an analysis to tidy the UCI HAR Dataset according to the course project
# instructions for the "Getting and Cleaning Data" course on Coursera.
#
# Date Created:
#     Wed Aug  6 21:42:17 2014
# 
# Author:
#     Craig Struble <strubleca@yahoo.com>
#==============================================================================

library(plyr) # Use plyr for final aggregation of data by column means.

# Initialize variables used throughout the script. ----------------------------

# The data URL
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# The local data directory for where the data should be placed. 
dataDir <- "./data"  

# Name of the raw data file
rawDataFile <- file.path(dataDir, "UCI_HAR_Dataset.zip")

# The top level directory name of the raw data. From the ZIP file.
rawDataDir <- file.path(dataDir, "UCI HAR Dataset")

# The file containing the date the raw data was downloaded.
dateFile <- file.path(dataDir, "dateDownloaded.txt")

# The final tidy data file.
tidyDataFile <- file.path(dataDir, "tidy_UCI_HAR_Dataset.txt")

# Step 0.  --------------------------------------------------------------------
# Download and extract the raw data set.

writeLines(strwrap("Step 0. Download and extract the raw data set.",
                   exdent=8))

# Create the data directory for storing the raw data and download the file,
# if they don't exist.
if (!file.exists(dataDir)) {
    writeLines(paste("        Creating data directory:", dataDir))
    dir.create(dataDir)
}

# Download the raw data file
if (!file.exists(rawDataFile)) {
    writeLines(paste("        Downloading raw data file:", rawDataFile, "..."))
    # Select a download method that will work on Mac OS X (Darwin) or
    # other operating systems.
    os <- Sys.info()["sysname"]
    if (os == "Darwin") {
        try(download.file(dataUrl, 
                          destfile=rawDataFile, 
                          method="curl", 
                          quiet=TRUE))
    } else {
        # XXX: Untested! Don't have another machine to use.
        # Try to download file using default method. 
        try(download.file(dataUrl, 
                          destfile=rawDataFile,
                          quiet=TRUE))
    }
    
    if (!file.exists(rawDataFile)) {
        writeLines(paste("        Could not download data file:", rawDataFile))
        writeLines("        Manually download ZIP file.")
        writeLines("Stopping script execution.")
        stop() # Stop script execution.        
    }
    
    dateDownloaded <- date()
    writeLines(dateDownloaded, con=dateFile)
}

# Unzip the data set
if (!file.exists(rawDataDir)) {
    writeLines(paste("        Unzipping", rawDataFile, "to", rawDataDir))
    unzip(rawDataFile, exdir = dataDir, setTimes = TRUE)  
}

# Step 1. ---------------------------------------------------------------------
# Merges the training and the test sets to create one data set. 

writeLines(
    strwrap("Step 1. Merges the training and the test sets to create one data set.",
            exdent=8))

trainDataDir <- file.path(rawDataDir, "train")
testDataDir <- file.path(rawDataDir, "test")

# Read the training and test sets. The X, y, and subject data are kept
# separate until later to ease column selection from the X data.
trainX <- read.table(file.path(trainDataDir,"X_train.txt"), 
                     header=FALSE,
                     comment.char="")
trainSubject <- scan(file.path(trainDataDir,"subject_train.txt"))
trainY <- scan(file.path(trainDataDir,"y_train.txt"))

testX <- read.table(file.path(testDataDir,"X_test.txt"), 
                    header=FALSE,
                    comment.char="")
testSubject <- scan(file.path(testDataDir,"subject_test.txt"))
testY <- scan(file.path(testDataDir,"y_test.txt"))

# Combine the training and test sets. Since these files have the same
# structure, it's sufficient to combine them row wise.
allX <- rbind(trainX, testX)
allSubject <- c(trainSubject, testSubject)
allY <- c(trainY, testY)

# Step 2. ---------------------------------------------------------------------
# Extracts only the measurements on the mean and standard deviation for each 
# measurement.

writeLines(
    strwrap("Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.",
            exdent=8))

# Read in the feature names to get names for the columns.
features <- read.table(file.path(rawDataDir, "features.txt"),
                       header=FALSE,
                       stringsAsFactors=FALSE) # don't turn names into factors
names(features) <- c("Column", "Name") # label data.frame columns

# All of the mean and standard deviation names desired have mean() and std() 
# in the feature names. Search the feature names for these patterns to find
# matching column indices.
desiredColumns <- grep("(mean|std)\\(\\)", features$Name)

# Now store only the desired X data and assign column names.
desiredX <- allX[,desiredColumns]
names(desiredX) <- features$Name[desiredColumns]

# Step 3. ---------------------------------------------------------------------
# Uses descriptive activity names to name the activities in the data set.

writeLines(
    strwrap("Step 3. Uses descriptive activity names to name the activities in the data set.",
            exdent=8))

# Read the specification from the labels file.
activityLabels <- read.table(file.path(rawDataDir, "activity_labels.txt"),
                             header=FALSE,
                             stringsAsFactors=FALSE)
names(activityLabels) <- c("Class", "Name")
activityOrder  <- match(allY, activityLabels$Class)
allActivities  <- activityLabels$Name[activityOrder]

# Step 4. ---------------------------------------------------------------------
# Appropriately labels the data set with descriptive variable names.

writeLines(
    strwrap("Step 4. Appropriately labels the data set with descriptive names.",
            exdent=8))

# Initialize to the current column names.
niceNames <- colnames(desiredX)

# The names are transformed into slightly more readable form using a few
# basic rules.
#
# Rule 1. The first letter t is replaced with Time.
niceNames <- gsub("^t", "Time", niceNames)

# Rule 2. The first letter f is replaced with Frequency.
niceNames <-gsub("^f", "Frequency", niceNames)

# Rule 3. mean() is replaced with Mean.
niceNames <- gsub("mean\\(\\)", "Mean", niceNames)

# Rule 4. std() is replaced with StandardDeviation.
niceNames <- gsub("std\\(\\)", "StandardDeviation", niceNames)

# Rule 5. Acc is replaced with Acceleration.
niceNames <- gsub("Acc", "Acceleration", niceNames)

# Rule 6. Gyro is replaced with Gyroscope.
niceNames <- gsub("Gyro", "Gyroscope", niceNames)

# Rule 7. Mag is replaced with Magnitude.
niceNames <- gsub("Mag", "Magnitude", niceNames)

# Rule 8. Remove dashes (-)
niceNames <- gsub("-", "", niceNames)

# Rule 9. Replace BodyBody with Body
niceNames <- gsub("BodyBody", "Body", niceNames)

# Assign new names to the desired feature data
colnames(desiredX) <- niceNames

# Step 5. ---------------------------------------------------------------------
# Creates a second, independent tidy data set with the average of each variable
# for each activity and each subject.

writeLines(
    strwrap("Step 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.",
            exdent=8))

# Use plyr to aggregrate the data. The allSubject and allActivities vectors
# are now used to index and group the desired data columns. plyr adds two
# columns named "Subject" and "Activity" to the output indicating how the
# data were grouped. The colMeans function computes the column means for
# each data subset.
tidyDat <- ddply(desiredX, 
                 .(Subject=allSubject, Activity=allActivities), 
                 colMeans)

# Write the final tidy dataset out.
write.table(tidyDat, tidyDataFile, row.names=F)

writeLines("Done.")
