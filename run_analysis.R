#Invoking tidyverse library
suppressPackageStartupMessages(library(tidyverse,warn.conflicts = FALSE))
#Collecting Data
#Create data subdirectory in project if it does not exist
if(!file.exists("./data")){dir.create("./data")}
#Download dat if it is not downloaded
if(!file.exists(("./data/UCI HAR Dataset.zip"))){
  fileurl="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileurl,"./data/UCI HAR Dataset.zip")
  rm(fileurl)
}
#Unzip file if not done yest
if(!file.exists(("./UCI HAR Dataset"))){
unzip("./data/UCI HAR Dataset.zip")
}

#Processing Data
#Read Testing and training data
train<-read.table("./UCI HAR Dataset/train/X_train.txt",colClasses = "numeric")
test<-read.table("./UCI HAR Dataset/test/X_test.txt",colClasses = "numeric")

#Step 1 : Merges the training and the test sets to create one data set.
#Combine the data
joint<-rbind(train,test)
#Delete the uncombined data
rm(test,train)
#Read the features data
features<-read.table("./UCI HAR Dataset/features.txt")
#Assign features data as column name for the combined data
colnames(joint)<-features[,2]
#Remove the features data
rm(features)

#Step 2 : Extracts only the measurements on the mean and standard deviation for each measurement. 
#Select only data corresponding to mean and standard deviation
joint<-joint%>%select(contains(c("mean()","std()")))

#Step 3 : Uses descriptive activity names to name the activities in the data set
#Read the activity label mapping
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
#Read the test and training activity data
train_activity<-read.table("./UCI HAR Dataset/train/y_train.txt")
test_activity<-read.table("./UCI HAR Dataset/test/y_test.txt")
#Combine the testing and training activity data
joint_activity<-rbind(train_activity,test_activity)
#Delete the uncombined data
rm(test_activity,train_activity)
#rename the activity ID with activity description by using the mapping in activity_labels data
joint_activity<-joint_activity%>%rowwise()%>%
  mutate(V1=activity_labels[which(activity_labels[,1]==V1),2])
#Remove the activity_labels data post it use
rm(activity_labels)
#Name the column of activity data as activity
colnames(joint_activity)<-"activity"

#Read the test and training subject data
train_subject<-read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subject<-read.table("./UCI HAR Dataset/test/subject_test.txt")
#Combine the testing and training subject data
joint_subject<-rbind(train_subject,test_subject)
#Remove the uncombined data
rm(test_subject,train_subject)
#Name the column of subject data as subjectid
colnames(joint_subject)<-"subjectid"
#Bind the subjectid and activity data with the main data
joint<-cbind(joint_subject,joint_activity,joint)
#Delete the uncombined subjectid and activity post it use
rm(joint_subject,joint_activity)

#Step 4 : Appropriately labels the data set with descriptive variable names. 
#Rename the column names by replace t with Time_, f with Frequency_,- with _ and removing () and repeated terms
#Make all column names lower case
joint<-joint%>%rename_with(~gsub("^f","Frequency_",
                                 gsub("^t","Time_",
                                      gsub("-","_",
                                           gsub("BodyBody","Body",
                                                gsub("[()]","",.))))))%>%
  rename_with(~tolower(.))

#Step 5 : From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#Perform activity by using group_by, summary and across
suppressMessages(summary<-joint%>%group_by(subjectid,activity)%>%
  summarise(across(where(is.numeric),mean,.names="avg_{.col}")))

#Write the main data to csv if not done already
if(!file.exists("./data/tidydata.csv")){
  write.csv(joint,"./data/tidydata.csv",row.names = FALSE)
}
#Write the summary data to csv if not done already
if(!file.exists("./data/summary.csv")){
  write.csv(summary,"./data/summary.csv",row.names = FALSE)
}

