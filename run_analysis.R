#------------------------------------------------------------------------
# This functions produces a tidy dataset from several raw datasets. From
# the resulting tidy dataset a second tidy dataset is produced which
# sumamrizes the average of each varaible in the above mentioned tidy
# dataset grouped by two categorical variables in the dataset.
# The data set will be downloaded to the working directory and the files
# extracted to a directory named UCI HAR Dataset which will be created.
#-------------------------------------------------------------------------
run_analysis <- function() {

	require(data.table)
	require(plyr)

	#-----------------------------------------------------------------
	# Set directory for data sets and load the required raw datasets.
	# Prepare the names to be used for variables and the values of type
	# categorical: featureName, activityName, subjectName
	#-----------------------------------------------------------------
	dataURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	download.file(dataURL,destfile = "./raw_data.zip")
	unzip(zipfile = "./raw_data.zip",exdir = ".")
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


	#-----------------------------------------------------------------
	# Load activity data associated with each measurement:
	# activityTest and activityTrain
	#-----------------------------------------------------------------
	fileYTest <- paste(directory,"/test/y_test.txt",sep="")
	fileYTrain <- paste(directory,"/train/y_train.txt",sep="")
	activityTest <- read.table(fileYTest)
	activityTrain <- read.table(fileYTrain)

	#-----------------------------------------------------------------
	# Load subject data associated with each measurement:
	# subjectTest and subjectTrain
	#-----------------------------------------------------------------
	fileSubjectTest <- paste(directory,"/test/subject_test.txt",sep="")
	fileSubjectTrain <- paste(directory,"/train/subject_train.txt",sep="")
	subjectTest <- read.table(fileSubjectTest)
	subjectTrain <- read.table(fileSubjectTrain)

	#-----------------------------------------------------------------
	# Load sensor data associated with each measurement:
	# sensorTest and sensorTrain
	#-----------------------------------------------------------------
	fileXTest <- paste(directory,"/test/X_test.txt",sep="")
	fileXTrain <- paste(directory,"/train/X_train.txt",sep="")
	sensorTest <- read.table(fileXTest)
	sensorTrain <- read.table(fileXTrain)


	#-------------------------------------------------------------------
	# Merge the activity data sets (activityTrain and activityTest) then
	# assign descriptive names using activity name to the activities instead
	# of using 1,2,3,4,5,6
	#-------------------------------------------------------------------
	activityD <- as.data.table(rbind(activityTrain,activityTest))
	actNumber <- activityD[,V1]
	aDT <- as.data.table(activityName[actNumber])
	activityD <- cbind(aDT,activityD)
	activityD[,V1:=NULL]
	activityD[,KeyA:=NULL]
	setnames(activityD ,names(activityD),c("Activity"))
	rm(aDT)

	#-------------------------------------------------------------------
	# Merge subject data sets (subjectTrain and subjectTest) then assign
	# desriptive names to subjects using subjectName instead of using
	# numbers 1, ...., 30
	#-------------------------------------------------------------------
	subjectD <- as.data.table(rbind(subjectTrain,subjectTest))
	subNumber <- subjectD[,V1]
	aDT <- as.data.table(subjectName[subNumber])
	subjectD <- cbind(aDT,subjectD)
	subjectD[,V1:=NULL]
	setnames(subjectD,names(subjectD),c("Subject"))
	rm(aDT)

	#---------------------------------------------------------------------
	# Merge the sensor data sets (sensorTrain and sensorTest) extracting 
	# the data corresponding to mean and stddev measurements. Then assign
	# descriptive names to the variables using featureName instead of the
	# default V1, V2, ... etc
	#---------------------------------------------------------------------
	featureV <- featureName[,"Feature"]
	x <- unique(c(grep("mean",featureV),grep("std",featureV)))
	sensorD <- rbind(sensorTrain[,x],sensorTest[,x])
	setnames(sensorD,names(sensorD),featureV[x])
	setnames(sensorD,names(sensorD),gsub("\\(|\\)","",names(sensorD)))
	setnames(sensorD,names(sensorD),gsub("-","_",names(sensorD)))	


	#-------------------------------------------------------------------
	# Merge subject, activity, and measurements into a single tidy data set
	#-------------------------------------------------------------------
	theD <- cbind(activityD,subjectD,sensorD)
	theD <- as.data.table(theD)

	#--------------------------------------------------------------
	# Prepare names to be used for labeling the second tidy dataset
	#--------------------------------------------------------------
	names2 <- paste("Mean[",names(sensorD),"")
	names2 <- gsub(" ","",paste(names2,"]",""))
	names2 <- c("Activity","Subject",names2)

	
	#-----------------------------------------------------------
	# Form second tidy dataet for the mean of each variable
	# for each Subject - Activity pair
	#-----------------------------------------------------------
	meanD <- ddply(theD,c("Activity","Subject"),numcolwise(mean))
	rm(theD)
	setnames(meanD,names(meanD),names2)
	write.table(meanD,file = "summary_tidy_data.txt")
	as.data.table(meanD)
		
}




