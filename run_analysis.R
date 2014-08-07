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

# Download the raw data set ---------------------------------------------------

# The data URL, local data directory and local file name for the raw data.
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataDir <- "../data"
rawDataFile <- file.path(dataDir, "UCI_HAR_Dataset.zip")
dateFile <- file.path(dataDir, "dateDownloaded.txt")
rawDataDir <- file.path(dataDir, "UCI HAR Dataset") # dir name from ZIP file.

# Create the data directory for storing the raw data and download the file,
# if they don't exist.
if (!file.exists(dataDir)) {
    writeLines(paste("Creating data directory:", dataDir))
    dir.create(dataDir)
}

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
