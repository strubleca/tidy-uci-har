tidy-uci-har
============

The aim of `tidy-uci-har` is to create a tidy version of the UCI HAR dataset
for the "Getting and Cleaning Data" course offered August 4-31, 2014 
on Coursera.

The R script `run_analysis.R` downloads, if not already present, and processes
the raw UCI HAR dataset as follows:

* Step 0. Download and extract the raw data set. (Not in the original specification.)
* Step 1. Merges the training and the test sets to create one data set.
* Step 2. Extracts only the measurements on the mean and standard deviation for 
each measurement.
* Step 3. Uses descriptive activity names to name the activities in the data set.
* Step 4. Appropriately labels the data set with descriptive variable names.
* Step 5. Creates a second, independent tidy data set with the average of each 
variable for each activity and each subject.

## Usage
Use the script by opening an R session and setting your working directory
to the directory containing `run_analysis.R`. Then execute the script with
the R command:

    source("run_analysis.R")

The raw data and a tidy data set named `tidy_UCI_HAR_Dataset.txt` will be
placed in the `data` subdirectory of the current working directory.

## Customization
A few variables at the top of the script can customized at your own risk.

* `dataUrl` the URL of the raw UCI HAR dataset. Currently points to a
  cached copy provided by the course instructors.
* `dataDir` the path to the data directory for storing raw and tidy
  datasets. Currently points to the `"data"` subdirectory of the current
  working directory when the script is executed.
* `rawDataFile` path to the raw data file. Currently set to the name
  `"UCI_HAR_Dataset.zip"` within `dataDir`.
* `rawDataDirectory` path to the raw data directory unzipped 
   from `rawDataFile`. Currently set to `"UCI HAR Dataset"` within
  `dataDir`. It is not recommended to change the name of the directory, as
  it needs to match the ZIP file contents.
* `dateFile` path to the file storing the download date and time for the
  data. Currently set to `"dateDownloaded.txt"` within `dataDir`.
* `tidyDataFile` path to the output file containing the tidy dataset.
  Currently set to `"tidy_UCI_HAR_Dataset.txt"` within `dataDir`.

## Execution transcript
The following is a sample execution transcript.

    > source('run_analysis.R')
    Step 0. Download and extract the raw data set.
            Creating data directory: ./data
            Downloading raw data file: ./data/UCI_HAR_Dataset.zip ...
            Unzipping ./data/UCI_HAR_Dataset.zip to ./data/UCI HAR Dataset
    Step 1. Merges the training and the test sets to create one data set.
    Read 7352 items
    Read 7352 items
    Read 2947 items
    Read 2947 items
    Step 2. Extracts only the measurements on the mean and standard deviation for each
            measurement.
    Step 3. Uses descriptive activity names to name the activities in the data set.
    Step 4. Appropriately labels the data set with descriptive names.
    Step 5. Creates a second, independent tidy data set with the average of each
            variable for each activity and each subject.
    Done.
