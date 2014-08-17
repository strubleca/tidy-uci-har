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

## Transformations

Several transformations were performed on the raw data set
in preparation for the final tidy data set. The following
subsections with in this section detail the transformation
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
the data type for each column.

* `Subject` - Type: __`integer`__ - Description: The subject ID for the 
observations.
* `Activity` - Type: __`factor`__ - Description: The type of activity being 
performed for the observations.
* `TimeBodyAccelerationMeanX` - Type: __`numeric`__ - Description:
* `TimeBodyAccelerationMeanY`- Type: __`numeric`__ - Description: 
* `TimeBodyAccelerationMeanZ`- Type: __`numeric`__ - Description:
* `TimeBodyAccelerationStandardDeviationX`- Type: __`numeric`__ - Description:
* `TimeBodyAccelerationStandardDeviationY`- Type: __`numeric`__ - Description:
* `TimeBodyAccelerationStandardDeviationZ`- Type: __`numeric`__ - Description:
* `TimeGravityAccelerationMeanX`- Type: __`numeric`__ - Description:
* `TimeGravityAccelerationMeanY`- Type: __`numeric`__ - Description:
* `TimeGravityAccelerationMeanZ`- Type: __`numeric`__ - Description:
* `TimeGravityAccelerationStandardDeviationX`- Type: __`numeric`__ - Description:
* `TimeGravityAccelerationStandardDeviationY`- Type: __`numeric`__ - Description:
* `TimeGravityAccelerationStandardDeviationZ`- Type: __`numeric`__ - Description:
* `TimeBodyAccelerationJerkMeanX`- Type: __`numeric`__ - Description:
* `TimeBodyAccelerationJerkMeanY`- Type: __`numeric`__ - Description:
* `TimeBodyAccelerationJerkMeanZ`- Type: __`numeric`__ - Description:
* `TimeBodyAccelerationJerkStandardDeviationX`- Type: __`numeric`__ - Description:
* `TimeBodyAccelerationJerkStandardDeviationY`- Type: __`numeric`__ - Description:
* `TimeBodyAccelerationJerkStandardDeviationZ`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeMeanX`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeMeanY`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeMeanZ`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeStandardDeviationX`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeStandardDeviationY`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeStandardDeviationZ`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeJerkMeanX`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeJerkMeanY`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeJerkMeanZ`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeJerkStandardDeviationX`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeJerkStandardDeviationY`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeJerkStandardDeviationZ`- Type: __`numeric`__ - Description:
* `TimeBodyAccelerationMagnitudeMean`- Type: __`numeric`__ - Description:
* `TimeBodyAccelerationMagnitudeStandardDeviation`- Type: __`numeric`__ - Description:
* `TimeGravityAccelerationMagnitudeMean`- Type: __`numeric`__ - Description:
* `TimeGravityAccelerationMagnitudeStandardDeviation`- Type: __`numeric`__ - Description:
* `TimeBodyAccelerationJerkMagnitudeMean`- Type: __`numeric`__ - Description:
* `TimeBodyAccelerationJerkMagnitudeStandardDeviation`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeMagnitudeMean`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeMagnitudeStandardDeviation`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeJerkMagnitudeMean`- Type: __`numeric`__ - Description:
* `TimeBodyGyroscopeJerkMagnitudeStandardDeviation`- Type: __`numeric`__ - Description:
* `FrequencyBodyAccelerationMeanX`- Type: __`numeric`__ - Description:
* `FrequencyBodyAccelerationMeanY`- Type: __`numeric`__ - Description:
* `FrequencyBodyAccelerationMeanZ`- Type: __`numeric`__ - Description:
* `FrequencyBodyAccelerationStandardDeviationX`- Type: __`numeric`__ - Description:
* `FrequencyBodyAccelerationStandardDeviationY`- Type: __`numeric`__ - Description:
* `FrequencyBodyAccelerationStandardDeviationZ`- Type: __`numeric`__ - Description:
* `FrequencyBodyAccelerationJerkMeanX`- Type: __`numeric`__ - Description:
* `FrequencyBodyAccelerationJerkMeanY`- Type: __`numeric`__ - Description:
* `FrequencyBodyAccelerationJerkMeanZ`- Type: __`numeric`__ - Description:
* `FrequencyBodyAccelerationJerkStandardDeviationX`- Type: __`numeric`__ - Description:
* `FrequencyBodyAccelerationJerkStandardDeviationY`- Type: __`numeric`__ - Description:
* `FrequencyBodyAccelerationJerkStandardDeviationZ`- Type: __`numeric`__ - Description:
* `FrequencyBodyGyroscopeMeanX`- Type: __`numeric`__ - Description:
* `FrequencyBodyGyroscopeMeanY`- Type: __`numeric`__ - Description:
* `FrequencyBodyGyroscopeMeanZ`- Type: __`numeric`__ - Description:
* `FrequencyBodyGyroscopeStandardDeviationX`- Type: __`numeric`__ - Description:
* `FrequencyBodyGyroscopeStandardDeviationY`- Type: __`numeric`__ - Description:
* `FrequencyBodyGyroscopeStandardDeviationZ`- Type: __`numeric`__ - Description:
* `FrequencyBodyAccelerationMagnitudeMean`- Type: __`numeric`__ - Description:
* `FrequencyBodyAccelerationMagnitudeStandardDeviation`- Type: __`numeric`__ - Description:
* `FrequencyBodyBodyAccelerationJerkMagnitudeMean`- Type: __`numeric`__ - Description:
* `FrequencyBodyBodyAccelerationJerkMagnitudeStandardDeviation`- Type: __`numeric`__ - Description:
* `FrequencyBodyBodyGyroscopeMagnitudeMean`- Type: __`numeric`__ - Description:
* `FrequencyBodyBodyGyroscopeMagnitudeStandardDeviation`- Type: __`numeric`__ - Description:
* `FrequencyBodyBodyGyroscopeJerkMagnitudeMean`- Type: __`numeric`__ - Description:
* `FrequencyBodyBodyGyroscopeJerkMagnitudeStandardDeviation`- Type: __`numeric`__ - Description:
