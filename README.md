##Overview##
The R Programming script titled "run_analysis.R" included in this Github repository performs a short analysis of data collected from a smartphone sensor-to-activity measurement experiment conducted using Samsung Galaxy S class smartphones.

The analysis involved

-	loading raw data from several files
-	producing a tidy set from a subset of the raw data
-	aggregating the tidy data set by 2 of the variables
-	calculating the means of the measurements associated with the aggregated variables
-	outputting the result in a second tidy data set


##Methodology##
The analysis is accomplished in 6 stages.

- load the raw data
- identify the subset of data to be used
- merge and extract the targeted data
- adjust variable names and values of categorical variables to descriptive terms
- aggregate and summarize the tidy data set and produce the final summarized tidy data set
- output the final summarize tidy data set to a *.txt file


##R Script##

The R script, titled "**run_analysis.R**" that constructs the tidy data sets and produces the summary requires the packages data.table and dplyr. The script contains a single function called **run_analysis()**.

The function run_analysis() has 4 functional blocks: Getting the Data, Loading the data, Merging the data, Tidying the data. Below is a summary of the code used for run_analysis.R.


## Getting the Data##
The code set below downloads the zip file containing the datasets and extracts the ocntents of the zip file to a diorectory name UCI HAR Dataset.

	dataURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	download.file(dataURL,destfile = "./raw_data.zip")
	unzip(zipfile = "./raw_data.zip",exdir = ".")

##Loading the Data##
There are 4 classes of data to load: Variables and Categorical names, Subject Observations, Activity Observations, and Sensor Observations.


###Variable Names and Categories Values ###
The code set below loads the names of the sensor variables, loads the categorical values for the activities, and sets up a vector of descriptive names for the subject categorical values

	directory <- getwd()
	directory <- paste(directory,"/","UCI HAR Dataset",sep="")
	fileFeatures <- paste(directory,"/features.txt",sep="")
	fileActivity <- paste(directory,"/activity_labels.txt",sep="")
	featureName <- read.table(fileFeatures,stringsAsFactor = FALSE)
	activityName <- read.table(fileActivity,stringsAsFactor = FALSE)
	activityName <- as.data.table(activityName)
	setnames(featureName,names(featureName),c("KeyF","Feature"))
	setnames(activityName,names(activityName),c("KeyA","Activity"))
	subjectName <- c(rep("Subject_",30))
	for (i in 1:30) {
		subjectName[i] <- gsub(" ","",paste(subjectName[i],toString(i),""))
	}
	subjectName <- as.data.table(subjectName) 


###Activity Observations ###
The code set below loads the observations associated with the activity being performed while sensor measurements are observed.

	fileYTest <- paste(directory,"/test/y_test.txt",sep="")
	fileYTrain <- paste(directory,"/train/y_train.txt",sep="")
	activityTest <- read.table(fileYTest)
	activityTrain <- read.table(fileYTrain)


###Subject Observations ###
The code set below loads the observations associated with the subject performing an activity while sensor measurements are observed.

	fileSubjectTest <- paste(directory,"/test/subject_test.txt",sep="")
	fileSubjectTrain <- paste(directory,"/train/subject_train.txt",sep="")
	subjectTest <- read.table(fileSubjectTest)
	subjectTrain <- read.table(fileSubjectTrain)


###Sensor Observations ###
The code set below loads the sensor observations associated with the subject and activity.

	fileXTest <- paste(directory,"/test/X_test.txt",sep="")
	fileXTrain <- paste(directory,"/train/X_train.txt",sep="")
	sensorTest <- read.table(fileXTest)
	sensorTrain <- read.table(fileXTrain)


## Producing the First Tidy Data Set##


###Merge Activity Observations ###
The code set below merges the activity observation data for the test and train groups, and sets descriptive names for the categorical values instead of using 1, .. , 6.

	activityD <- as.data.table(rbind(activityTrain,activityTest))
	actNumber <- activityD[,V1]
	aDT <- as.data.table(activityName[actNumber])
	activityD <- cbind(aDT,activityD)
	activityD[,V1:=NULL]
	activityD[,KeyA:=NULL]
	setnames(activityD ,names(activityD),c("Activity"))
	rm(aDT)


###Merge Subject Observations ###
The code set below merges the subject observation data for the test and train groups, and sets descriptive names for the categorical values instead of using 1, ...., 30.

	subjectD <- as.data.table(rbind(subjectTrain,subjectTest))
	subNumber <- subjectD[,V1]
	aDT <- as.data.table(subjectName[subNumber])
	subjectD <- cbind(aDT,subjectD)
	subjectD[,V1:=NULL]
	setnames(subjectD,names(subjectD),c("Subject"))
	rm(aDT)
  

###Extract and Merge Sensor Observations ###
The code set below extracts the measurements for the targeted sensor variables for the test and train groups then, merges the two groups and sets clean, readable descriptive names for the variables.

	featureV <- featureName[,"Feature"]
	x <- unique(c(grep("mean",featureV),grep("std",featureV)))
	sensorD <- rbind(sensorTrain[,x],sensorTest[,x])
	setnames(sensorD,names(sensorD),featureV[x])
	setnames(sensorD,names(sensorD),gsub("\\(|\\)","",names(sensorD)))
	setnames(sensorD,names(sensorD),gsub("-","_",names(sensorD)))	


###First Tidy Data Set###
The code set below merges the 3 observation data sets (Subject, Activity, and Sensor) to form a single tidy data set.

	theD <- cbind(activityD,subjectD,sensorD)	
	theD <- as.data.table(theD)


## Producing the Second Tidy Data Set##

###Prepare Descriptive Names for the 2nd Tidy Data Set###
The code set below prepares descriptive names for the variables used in the second tidy data set.

	names2 <- paste("Mean[",names(sensorD),"")
	names2 <- gsub(" ","",paste(names2,"]",""))
	names2 <- c("Activity","Subject",names2)


### Tidy Data Set###

The code set below aggregates the first tidy data set by (Subject, Activity) pair, computes the mean for each pair, sets descriptive names for the variables, places the summary tidy data set in a data table named meanD, and outputs the result to a text file named summary_tidy_data.txt

	meanD <- ddply(theD,c("Activity","Subject"),numcolwise(mean))
	rm(theD)
	setnames(meanD,names(meanD),names2)
	write.table(meanD,file = "summary_tiday_data.txt")
	as.data.table(meanD)
