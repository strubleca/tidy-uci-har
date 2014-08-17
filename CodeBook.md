Code Book for tidy_UCI_HAR_Dataset.txt
======================================

The course project for "Getting and Cleaning Data" 
offered August 4-31, 2014 on [Coursera](http://www.coursera.org)
was to download and tidy the 
[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
available from the University of California, Irvine Machine Learning Repository.

The data set's abstract provided at UCI is

> Human Activity Recognition database built from the recordings of 30 subjects
> performing activities of daily living (ADL) while carrying a 
> waist-mounted smartphone with embedded inertial sensors.

Accelerometer and gyroscope readings were taken for 30 subjects in six
different activity categories: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, 
SITTING, STANDING, LAYING. The resulting data consisted of 10299 observations
(rows) with 561 measurements (columns). 

Subjects in the study were divided into training and test sets,
and the resulting observations for those subjects were divided as well.

Based on the description provided by the original authors,
the underlying problem being addressed is to develop
a classifier that can recognize different activity types
from the activity readings.

It should be noted that these
data are not in their rawest form, but transformations of sliding window
time course observations also present in the data set. Because the
course project does not require using the time course observations
directly, they were ignored during processing. 

## Preprocessing By Original Authors

According to the original documentation in `features_info.txt`, the
raw data were preprocessed as follows:

> The features selected for this database come from the accelerometer
> and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These
> time domain signals (prefix 't' to denote time) were captured at a
> constant rate of 50 Hz. Then they were filtered using a median
> filter and a 3rd order low pass Butterworth filter with a corner
> frequency of 20 Hz to remove noise. Similarly, the acceleration
> signal was then separated into body and gravity acceleration signals
> (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth
> filter with a corner frequency of 0.3 Hz.

It is not immediately clear from this description what the units for
measurement are.

Further preprocessing was performed by the original authors as follows:

> Subsequently, the body linear acceleration and angular velocity
> were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and
> tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional
> signals were calculated using the Euclidean norm (tBodyAccMag,
> tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

> Finally a Fast Fourier Transform (FFT) was applied to some of these
> signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ,
> fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to
> indicate frequency domain signals).

## Cached Data Set Copy

Per the instructions for the course project,
the raw data was downloaded from the URL

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

which contains a cached copy of the original data set.

## Transformations

Several transformations were performed on the raw data set
in preparation for the final tidy data set. The following
subsections within this section detail the transformation
performed.

### Merging Training and Test Datasets

The first step specified in the course project stated,

> Merges the training and the test sets to create one data set.

Measurement data from training and test sets are kept in the
`X_train.txt` and `X_test.txt` files in the respective `train`
and `test` directories. To merge these data, the `rbind()` function
in R was used, to perform row-wise concatenation. The resulting
data are kept in the `allX` variable as a matrix.

The subject and activity vectors 
were also read in from `subject_train.txt` (and `_test.txt`) 
and `y_train.txt` (and `_test.txt`) respectively.
These vectors parallel the rows of the measurement data,
as indicated by the number of lines in these files.
As such, concatinating the vectors was used to merge the data sets.
The concatenated vectors are kept in the `allSubjects` and
`allY` variables.

### Measurement Selection

The second step specified in the course project stated,

> Extracts only the measurements on the mean and standard 
> deviation for each measurement.

Based on reading the raw data set's code book, it was determined that
only measurements containing mean() and std() would be included.

The selected columns from `allX` are placed into the `desiredX` variable.

### Activity Naming

The third step of the course project stated,

> Uses descriptive activity names to name the activities in 
> the data set.

The `activity_labels.txt` file in the top level raw data directory
contains a mapping from integer activity code to descriptive text.
The contents of this file were read in, and activity codes replaced
by their corresponding descriptive text.
The resulting replacement was stored in the `allActivities` 
character vector.

### Variable Name Modifications

The fourth step of the course project stated,

> Appropriately labels the data set with descriptive variable names.

Variable names from the original raw dataset were modified to be
slightly more readable. All variable names use 
[camel case](http://en.wikipedia.org/wiki/CamelCase)
as their standard.
The resulting names are a bit long, but capture the information
present in the original data set.
Were this data intended 
to be analyzed using spreadsheet software like
Microsoft Excel, more compact variable names would be preferred.

The variable name transformation rules used are:

* Rule 1. The first letter t is replaced with Time.
* Rule 2. The first letter f is replaced with Frequency.
* Rule 3. mean() is replaced with Mean.
* Rule 4. std() is replaced with StandardDeviation.
* Rule 5. Acc is replaced with Acceleration.
* Rule 6. Gyro is replaced with Gyroscope.
* Rule 7. Mag is replaced with Magnitude.
* Rule 8. Remove dashes (-)

### Aggregation

The fifth and final step of the course project stated,

> Creates a second, independent tidy data set with the average of each 
> variable for each activity and each subject.

To accomplish the aggregation,
the `plyr` package was used
to group the rows of the `desiredX` matrix
by the values in the `allSubject` and `allActivities` vectors.
Two new columns named `Subject` and `Activity` are added
to the resulting matrix, and the remaining columns contain
the column means for the row groups in `desiredX`.
The `colMeans()` function was applied to each group
to obtain the column means.

## Variables
These are the variable descriptions for the columns in 
`tidy_UCI_HAR_Dataset.txt`. R types for the columns are used to describe
the data type for each column. All measurement variables are aggregations
by the mean of the original data columns. As stated in
the 
[Preprocessing By Original Authors](#preprocessing-by-original-authors)
section above,
the units are not immediately apparent.

* `Subject` The subject ID for the observations.  __`integer`__
* `Activity` The type of activity being performed for the observations. __`factor`__ 
* `TimeBodyAccelerationMeanX` Time domain signals of __`numeric`__
* `TimeBodyAccelerationMeanY` Time domain signals of __`numeric`__ 
* `TimeBodyAccelerationMeanZ` Time domain signals of __`numeric`__
* `TimeBodyAccelerationStandardDeviationX` Time domain signals of __`numeric`__
* `TimeBodyAccelerationStandardDeviationY` Time domain signals of __`numeric`__
* `TimeBodyAccelerationStandardDeviationZ` Time domain signals of __`numeric`__
* `TimeGravityAccelerationMeanX` Time domain signals of __`numeric`__
* `TimeGravityAccelerationMeanY` Time domain signals of __`numeric`__
* `TimeGravityAccelerationMeanZ` Time domain signals of __`numeric`__
* `TimeGravityAccelerationStandardDeviationX` Time domain signals of __`numeric`__
* `TimeGravityAccelerationStandardDeviationY` Time domain signals of __`numeric`__
* `TimeGravityAccelerationStandardDeviationZ` Time domain signals of __`numeric`__
* `TimeBodyAccelerationJerkMeanX` Time domain signals of __`numeric`__
* `TimeBodyAccelerationJerkMeanY` Time domain signals of __`numeric`__
* `TimeBodyAccelerationJerkMeanZ` Time domain signals of __`numeric`__
* `TimeBodyAccelerationJerkStandardDeviationX` Time domain signals of __`numeric`__
* `TimeBodyAccelerationJerkStandardDeviationY` Time domain signals of __`numeric`__
* `TimeBodyAccelerationJerkStandardDeviationZ` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeMeanX` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeMeanY` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeMeanZ` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeStandardDeviationX` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeStandardDeviationY` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeStandardDeviationZ` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeJerkMeanX` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeJerkMeanY` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeJerkMeanZ` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeJerkStandardDeviationX` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeJerkStandardDeviationY` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeJerkStandardDeviationZ` Time domain signals of __`numeric`__
* `TimeBodyAccelerationMagnitudeMean` Time domain signals of __`numeric`__
* `TimeBodyAccelerationMagnitudeStandardDeviation` Time domain signals of __`numeric`__
* `TimeGravityAccelerationMagnitudeMean` Time domain signals of __`numeric`__
* `TimeGravityAccelerationMagnitudeStandardDeviation` Time domain signals of __`numeric`__
* `TimeBodyAccelerationJerkMagnitudeMean` Time domain signals of __`numeric`__
* `TimeBodyAccelerationJerkMagnitudeStandardDeviation` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeMagnitudeMean` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeMagnitudeStandardDeviation` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeJerkMagnitudeMean` Time domain signals of __`numeric`__
* `TimeBodyGyroscopeJerkMagnitudeStandardDeviation` Time domain signals of __`numeric`__
* `FrequencyBodyAccelerationMeanX` Frequency domain signals of __`numeric`__
* `FrequencyBodyAccelerationMeanY` Frequency domain signals of __`numeric`__
* `FrequencyBodyAccelerationMeanZ` Frequency domain signals of __`numeric`__
* `FrequencyBodyAccelerationStandardDeviationX` Frequency domain signals of __`numeric`__
* `FrequencyBodyAccelerationStandardDeviationY` Frequency domain signals of __`numeric`__
* `FrequencyBodyAccelerationStandardDeviationZ` Frequency domain signals of __`numeric`__
* `FrequencyBodyAccelerationJerkMeanX` Frequency domain signals of __`numeric`__
* `FrequencyBodyAccelerationJerkMeanY` Frequency domain signals of __`numeric`__
* `FrequencyBodyAccelerationJerkMeanZ` Frequency domain signals of __`numeric`__
* `FrequencyBodyAccelerationJerkStandardDeviationX` Frequency domain signals of __`numeric`__
* `FrequencyBodyAccelerationJerkStandardDeviationY` Frequency domain signals of __`numeric`__
* `FrequencyBodyAccelerationJerkStandardDeviationZ` Frequency domain signals of __`numeric`__
* `FrequencyBodyGyroscopeMeanX` Frequency domain signals of __`numeric`__
* `FrequencyBodyGyroscopeMeanY` Frequency domain signals of __`numeric`__
* `FrequencyBodyGyroscopeMeanZ` Frequency domain signals of __`numeric`__
* `FrequencyBodyGyroscopeStandardDeviationX` Frequency domain signals of __`numeric`__
* `FrequencyBodyGyroscopeStandardDeviationY` Frequency domain signals of __`numeric`__
* `FrequencyBodyGyroscopeStandardDeviationZ` Frequency domain signals of __`numeric`__
* `FrequencyBodyAccelerationMagnitudeMean` Frequency domain signals of __`numeric`__
* `FrequencyBodyAccelerationMagnitudeStandardDeviation` Frequency domain signals of __`numeric`__
* `FrequencyBodyBodyAccelerationJerkMagnitudeMean` Frequency domain signals of __`numeric`__
* `FrequencyBodyBodyAccelerationJerkMagnitudeStandardDeviation` Frequency domain signals of __`numeric`__
* `FrequencyBodyBodyGyroscopeMagnitudeMean` Frequency domain signals of __`numeric`__
* `FrequencyBodyBodyGyroscopeMagnitudeStandardDeviation` Frequency domain signals of __`numeric`__
* `FrequencyBodyBodyGyroscopeJerkMagnitudeMean` Frequency domain signals of __`numeric`__
* `FrequencyBodyBodyGyroscopeJerkMagnitudeStandardDeviation` Frequency domain signals of __`numeric`__
