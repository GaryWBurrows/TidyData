## Codebook - Getting and Cleaning Data Course Project ##


### Objective ###

This Codebook describes the data sets, variables, and methodology used for a course project associated with the May 4 2015 Coursera class titled "Getting and Cleaning Data". The overall objective of this project was to start with a collection of data sets comprise raw data, use a R Programming script to:

-	load the files
-	merge the measurement files into a single data set
-	extract a special subset of the variables measured
-	use the label files to assign descriptive names to the variables and categorical data
-	compute the mean of each remaining variable for each combination of the categorical variables

###Data Sets and Variables###

The raw data for this project was collected from the sensors on a Samsung Galaxy S smartphone while 30 people were selected to conduct various activities. The people were separated into 2 groups, a "*test group*" (9 people) and a "*train group*" (21 people). The assignment to the groups was random. The raw data was collected and placed into 8 data sets consisting of; observations for the sensor measurements ( **sensorTest** and **sensorTrain** ), observations of the activity being performed (**activityTest** and **activityTrain**), observations of the subject performing the activity (**subjectTest** and **subjectTrain**), the names of the 6 activities for which sensor measurements were collected (**activityNames**), and the names of the 561 variables measured (**featureNames**).

The data sets are contained in a directory titled "**UCI HAR Dataset**" which is assume to be in the working directory. These sets, their associated files, and the variables are summarized as follows.

- **activityNames**
	- contained in the file */UCI HAR Dataset/activity_labes.txt*
	- contains a column of 6 different activities which are performed by the subjects
- **featureNames**
	- contained in the file */UCI HAR Dataset/features.txt* 
	- contains a column with 561 names describing the sensor variable measured
	- each row provides the name of the variable in the corresponding column of
		- sensorTest
		- sensorTrain
- **subjectTest and subjectTrain**
	- subjectTest is contained in the file */UCI HAR Dataset/test/subject_test.txt*
	- subjectTrain is contained in the file */UCI HAR Dataset/train/subject_train.txt*
	- each data set contains a column an integers
	- each integer identifies a subject
	- this is a variable of type *Categorical*
	- the range of this variable is {1, 2, 3, 4, ... , 30} as 30 subjects participated
	- each row in subjectTest corresponds to a row of observations in sensorTest
		- identifies the subject performing an activity
	- each row in subjectTrain corresponds to a row of observations in sensorTrain
		- identifies the subject performing an activity 
- **sensorTest and sensorTrain**
	- sensorTest is contained in the file */UCI HAR Dataset/test/X_test.txt*
	- sensorTrain is contained in the file */UCI HAR Dataset/train/X_train.txt*
	- these data sets contains 561 columns
		- each corresponding to a variable named in the features data set
	- the variable is of type Real Number
	- each row in these datas sets corresponds to a measurements of a subject conducting an activity
		- the subject for the dataset sensorTest is from the group titled *test group*
		- the subject for the dataset sensorTrain is from the group titled *train group*
- **activityTest and activityTrain**
	- activityTest is contained in the file */UCI HAR Dataset/test/y_test.txt*
	- activityTrain is contained in the file */UCI HAR Dataset/train/y_train.txt*
	- each file contains a column of integers between 1 and 6
	- the integer corresponds to an activity in the activity data set
	- this is a variable of type *Categorical*
	- for the purpose of desctiptive names the values 1 through 6 will be replaced with
		- {WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING}


###Tidy Data Set 1###
The first tidy data produced from the raw data combines the measurements from the test and train data sets associated with the variables which correspond to means and standard deviations with the activity performed, and the subject performing the activity. This combination results in 81 variables of type Real Number and 2 variables of type Categorical (Subject and Activity). The data set will have a total of 83 columns. The number of rows will be the sum of the number of rows from the Test and Train data sets. For the purpose of providing descriptive names the subjectTest and subjectTrain values are replaced with values form the set {Subject_1, Subject_2, ..., Subject_30}.

### Tidy Data Set 2 ###
Tidy data set 2 was formed from tidy data set 1 by computing the mean for each variable's set of measurements aggregated by (subject,activity) pair. This will product a data set with all unique combinations of (subject, activity) and 81 corresponding means. This file is written to the file ***tidy_set2.txt***. For the purpose of descriptive names the names if the 81 variables were augmented with **Mean[** "name of variable" **]**. This data set is also returned as a data table.


