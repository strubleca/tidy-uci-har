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

# Step 0.  --------------------------------------------------------------------
# Download and extract the raw data set

# Initialize variables used throughout the script.
# The data URL, local data directory and local file name for the raw data.
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataDir <- "../data"   ## Put this a level up. Don't put raw data in repo.
rawDataFile <- file.path(dataDir, "UCI_HAR_Dataset.zip")
dateFile <- file.path(dataDir, "dateDownloaded.txt")
rawDataDir <- file.path(dataDir, "UCI HAR Dataset") # dir name from ZIP file.

# Create the data directory for storing the raw data and download the file,
# if they don't exist.
if (!file.exists(dataDir)) {
    writeLines(paste("Creating data directory:", dataDir))
    dir.create(dataDir)
}

# Download the raw data file
if (!file.exists(rawDataFile)) {
    writeLines(paste("Downloading raw data file:", rawDataFile, "..."))
    # Select a download method that will work on Mac OS X (Darwin) or
    # other operating systems.
    os <- Sys.info()["sysname"]
    if (os == "Darwin") {
        downloadMethod <- "curl"
    } else {
        downloadMethod <- "auto" # Default on other operating systems
    }
    download.file(dataUrl, destfile=rawDataFile, method=downloadMethod)
    dateDownloaded <- date()
    writeLines(dateDownloaded, con=dateFile)
    writeLines("Done.")
}

# Unzip the data set
if (!file.exists(rawDataDir)) {
    writeLines(paste("Unzipping", rawDataFile, "to", rawDataDir))
    unzip(rawDataFile, exdir = dataDir, setTimes = TRUE)  
    writeLines("Done.")
}

# Step 1. ---------------------------------------------------------------------
# Merges the training and the test sets to create one data set. 

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

# Read the specification from the labels file.
activityLabels <- read.table(file.path(rawDataDir, "activity_labels.txt"),
                             header=FALSE,
                             stringsAsFactors=FALSE)
names(activityLabels) <- c("Class", "Name")
activityOrder  <- match(allY, activityLabels$Class)
allActivities  <- activityLabels$Name[activityOrder]

# Step 4. ---------------------------------------------------------------------
# Appropriately labels the data set with descriptive variable names.

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

# Rule 6. Mag is replaced with Magnitude.
niceNames <- gsub("Mag", "Magnitude", niceNames)

# Rule 7. Remove dashes (-)
niceNames <- gsub("-", "", niceNames)

# Assign new names to the desired feature data
colnames(desiredX) <- niceNames

# Step 5. ---------------------------------------------------------------------
# Creates a second, independent tidy data set with the average of each variable
# for each activity and each subject.

# Use plyr to aggregrate the data. The allSubject and allActivities vectors
# are now used to index and group the desired data columns. plyr adds two
# columns named "Subject" and "Activity" to the output indicating how the
# data were grouped. The colMeans function computes the column means for
# each data subset.
tidyDat <- ddply(desiredX, 
                 .(Subject=allSubject, Activity=allActivities), 
                 colMeans)
