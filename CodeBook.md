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
only measurements containing mean() and std() would be included. This
results in 66 selected columns. Other possible columns include meanFreq()
and angle metrics interacting with some means. These additional columns,
however, are not included because they are not strictly means or standard
deviations of measures, but other values altogether.

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
* Rule 9. BodyBody is replaced with Body (to fix apparent typo in `features.txt`)

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
the units are not immediately apparent. The final dimensions of the data
set are 180 rows by 68 columns.

* `Subject` __`integer`__  
The subject ID for the measurements in the same row. Possible
values are 1 through 30.
* `Activity` __`factor`__  
The type of activity being performed for the measurements in the 
same row. Possible values are `LAYING`, `SITTING`, `STANDING`, `WALKING`,
`WALKING_DOWNSTAIRS`, `WALKING_UPSTAIRS`.
* `TimeBodyAccelerationMeanX` __`numeric`__  
Mean of the mean time domain 
body linear acceleration signals
in the X direction. 
* `TimeBodyAccelerationMeanY` __`numeric`__  
Mean of the mean time domain
body linear acceleration signals
in the Y direction.
* `TimeBodyAccelerationMeanZ` __`numeric`__  
Mean of the mean time domain 
body linear acceleration signals
in the Z direction.
* `TimeBodyAccelerationStandardDeviationX` __`numeric`__  
Mean standard deviations of time domain 
body linear acceleration signals
in the X direction.
* `TimeBodyAccelerationStandardDeviationY` __`numeric`__  
Mean standard deviations of time domain
body linear acceleration signals
in the Y direction.
* `TimeBodyAccelerationStandardDeviationZ` __`numeric`__  
Mean standard deviations of time domain
body linear acceleration signals
in the Z direction.
* `TimeGravityAccelerationMeanX` __`numeric`__  
Mean of the mean time domain
gravity linear acceleration signals
in the X direction.
* `TimeGravityAccelerationMeanY` __`numeric`__  
Mean of the mean time domain
gravity linear acceleration signals
in the Y direction.
* `TimeGravityAccelerationMeanZ` __`numeric`__  
Mean of the mean time domain
gravity linear acceleration signals
in the Z direction.
* `TimeGravityAccelerationStandardDeviationX` __`numeric`__  
Mean standard deviations of time domain
gravity linear acceleration signals
in the X direction.
* `TimeGravityAccelerationStandardDeviationY` __`numeric`__  
Mean standard deviations of time domain
gravity linear acceleration signals
in the Y direction.
* `TimeGravityAccelerationStandardDeviationZ` __`numeric`__  
Mean standard deviations of time domain
gravity linear acceleration signals
in the Z direction.
* `TimeBodyAccelerationJerkMeanX` __`numeric`__  
Mean of the mean time domain 
jerk signals derived
from body linear acceleration
in the X direction.
* `TimeBodyAccelerationJerkMeanY` __`numeric`__  
Mean of the mean time domain
jerk signals derived
from body linear acceleration
in the Y direction.
* `TimeBodyAccelerationJerkMeanZ` __`numeric`__  
Mean of the mean time domain
jerk signals derived
from body linear acceleration
in the Z direction.
* `TimeBodyAccelerationJerkStandardDeviationX` __`numeric`__  
Mean standard deviations of time domain
jerk signals derived
from body linear acceleration
in the X direction.
* `TimeBodyAccelerationJerkStandardDeviationY` __`numeric`__  
Mean standard deviations of time domain
jerk signals derived
from body linear acceleration
in the Y direction.
* `TimeBodyAccelerationJerkStandardDeviationZ` __`numeric`__  
Mean standard deviations of time domain
jerk signals derived
from body linear acceleration
in the Z direction.
* `TimeBodyGyroscopeMeanX` __`numeric`__  
Mean of the mean time domain
body gyroscope angular velocity signals
in the X direction.
* `TimeBodyGyroscopeMeanY` __`numeric`__  
Mean of the mean time domain
body gyroscope angular velocity signals
in the Y direction.
* `TimeBodyGyroscopeMeanZ` __`numeric`__  
Mean of the mean time domain
body gyroscope angular velocity signals
in the Z direction.
* `TimeBodyGyroscopeStandardDeviationX` __`numeric`__  
Mean standard deviations of time domain
body gyroscope angular velocity signals
in the X direction.
* `TimeBodyGyroscopeStandardDeviationY` __`numeric`__  
Mean standard deviations of time domain
body gyroscope angular velocity signals
in the Y direction.
* `TimeBodyGyroscopeStandardDeviationZ` __`numeric`__  
Mean standard deviations of time domain
body gyroscope angular velocity signals
in the Z direction.
* `TimeBodyGyroscopeJerkMeanX` __`numeric`__  
Mean of the mean time domain
jerk signals derived
from body gyroscope angular velocity
in the X direction.
* `TimeBodyGyroscopeJerkMeanY` __`numeric`__  
Mean of the mean time domain
jerk signals derived
from body gyroscope angular velocity
in the Y direction.
* `TimeBodyGyroscopeJerkMeanZ` __`numeric`__  
Mean of the mean time domain
jerk signals derived
from body gyroscope angular velocity
in the Z direction.
* `TimeBodyGyroscopeJerkStandardDeviationX` __`numeric`__  
Mean standard deviations of time domain
jerk signals derived
from body gyroscope angular velocity
in the X direction.
* `TimeBodyGyroscopeJerkStandardDeviationY` __`numeric`__  
Mean standard deviations of time domain
jerk signals derived
from body gyroscope angular velocity
in the Y direction.
* `TimeBodyGyroscopeJerkStandardDeviationZ` __`numeric`__  
Mean standard deviations of time domain
jerk signals derived
from body gyroscope angular velocity
in the Z direction.
* `TimeBodyAccelerationMagnitudeMean` __`numeric`__  
Mean of the mean magnitudes of time domain
body linear acceleration signals.
* `TimeBodyAccelerationMagnitudeStandardDeviation` __`numeric`__  
Mean standard deviations of the magnitudes of time domain
body linear acceleration signals.
* `TimeGravityAccelerationMagnitudeMean` __`numeric`__  
Mean of the mean magnitudes of time domain
gravity linear acceleration signals.
* `TimeGravityAccelerationMagnitudeStandardDeviation` __`numeric`__  
Mean standard deviations of the magnitudes of time domain
gravity linear acceleration signals.
* `TimeBodyAccelerationJerkMagnitudeMean` __`numeric`__  
Mean of the mean magnitudes of time domain
jerk signals derived
from body linear acceleration.
* `TimeBodyAccelerationJerkMagnitudeStandardDeviation` __`numeric`__  
Mean standard deviations of the magnitudes of time domain
jerk signals derived
from body linear acceleration.
* `TimeBodyGyroscopeMagnitudeMean` __`numeric`__  
Mean of the mean magnitudes of time domain
body gyroscope angular velocity signals.
* `TimeBodyGyroscopeMagnitudeStandardDeviation` __`numeric`__  
Mean standard deviations of the magnitudes of time domain
body gyroscope angular velocity signals.
* `TimeBodyGyroscopeJerkMagnitudeMean` __`numeric`__  
Mean of the mean magnitudes 
of time domain
jerk signals derived
from body gyroscope angular velocity.
* `TimeBodyGyroscopeJerkMagnitudeStandardDeviation` __`numeric`__  
Mean standard deviations of the magnitudes 
of time domain
jerk signals derived
from body gyroscope angular velocity.
* `FrequencyBodyAccelerationMeanX` __`numeric`__  
Mean of the mean frequency domain 
body linear acceleration signals
in the X direction.
* `FrequencyBodyAccelerationMeanY` __`numeric`__  
Mean of the mean frequency domain
body linear acceleration signals
in the Y direction.
* `FrequencyBodyAccelerationMeanZ` __`numeric`__  
Mean of the mean frequency domain
body linear acceleration signals
in the Z direction.
* `FrequencyBodyAccelerationStandardDeviationX` __`numeric`__  
Mean standard deviations of frequency domain
body linear acceleration signals
in the X direction.
* `FrequencyBodyAccelerationStandardDeviationY` __`numeric`__  
Mean standard deviations of frequency domain
body linear acceleration signals
in the Y direction.
* `FrequencyBodyAccelerationStandardDeviationZ` __`numeric`__  
Mean standard deviations of frequency domain
body linear acceleration signals
in the Z direction.
* `FrequencyBodyAccelerationJerkMeanX` __`numeric`__  
Mean of the mean frequency domain
jerk signals derived
from body linear acceleration
in the X direction.
* `FrequencyBodyAccelerationJerkMeanY` __`numeric`__  
Mean of the mean frequency domain
jerk signals derived
from body linear acceleration
in the Y direction.
* `FrequencyBodyAccelerationJerkMeanZ` __`numeric`__  
Mean of the mean frequency domain
jerk signals derived
from body linear acceleration
in the Z direction.
* `FrequencyBodyAccelerationJerkStandardDeviationX` __`numeric`__  
Mean standard deviations of frequency domain
jerk signals derived
from body linear acceleration
in the X direction.
* `FrequencyBodyAccelerationJerkStandardDeviationY` __`numeric`__  
Mean standard deviations of frequency domain
jerk signals derived
from body linear acceleration
in the Y direction.
* `FrequencyBodyAccelerationJerkStandardDeviationZ` __`numeric`__  
Mean standard deviations of frequency domain
jerk signals derived
from body linear acceleration
in the Z direction.
* `FrequencyBodyGyroscopeMeanX` __`numeric`__  
Mean of the mean frequency domain 
body gyroscope angular velocity signals
in the X direction.
* `FrequencyBodyGyroscopeMeanY` __`numeric`__  
Mean of the mean frequency domain
body gyroscope angular velocity signals
in the Y direction.
* `FrequencyBodyGyroscopeMeanZ` __`numeric`__  
Mean of the mean frequency domain
body gyroscope angular velocity signals
in the Z direction.
* `FrequencyBodyGyroscopeStandardDeviationX` __`numeric`__  
Mean standard deviations of frequency domain
body gyroscope angular velocity signals
in the X direction.
* `FrequencyBodyGyroscopeStandardDeviationY` __`numeric`__  
Mean standard deviations of frequency domain
body gyroscope angular velocity signals
in the Y direction.
* `FrequencyBodyGyroscopeStandardDeviationZ` __`numeric`__  
Mean standard deviations of frequency domain
body gyroscope angular velocity signals
in the Z direction.
* `FrequencyBodyAccelerationMagnitudeMean` __`numeric`__  
Mean of the mean magnitudes of frequency domain
body linear acceleration signals.
* `FrequencyBodyAccelerationMagnitudeStandardDeviation` __`numeric`__  
Mean standard deviations of the magnitudes of frequency domain
body linear acceleration signals.
* `FrequencyBodyAccelerationJerkMagnitudeMean` __`numeric`__  
Mean of the mean magnitudes of frequency domain
jerk signals derived
from body linear acceleration.
* `FrequencyBodyAccelerationJerkMagnitudeStandardDeviation` __`numeric`__  
Mean standard deviations of magnitudes of frequency domain
jerk signals derived
from body linear acceleration.
* `FrequencyBodyGyroscopeMagnitudeMean` __`numeric`__  
Mean of the mean magnitudes of frequency domain
body gyroscope angular velocity signals.
* `FrequencyBodyGyroscopeMagnitudeStandardDeviation` __`numeric`__  
Mean standard deviations of magnitudes of frequency domain 
body gyroscope angular velocity signals.
* `FrequencyBodyGyroscopeJerkMagnitudeMean` __`numeric`__  
Mean of the mean magnitudes of frequency domain
jerk signals derived
from body gyroscope angular velocity.
* `FrequencyBodyGyroscopeJerkMagnitudeStandardDeviation` __`numeric`__  
Mean standard deviations of magnitudes of frequency domain
jerk signals derived
from body gyroscope angular velocity.
