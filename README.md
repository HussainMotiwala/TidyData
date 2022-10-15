# TidyData
Script to create tidy data table of raw data

Step 0: Collecting Data

Step 0.1 : Reading Data

Step 1 : Merges the training and the test sets to create one data set.
Read the features data and Assign features data as column name for the combined data



Step 2 : Extracts only the measurements on the mean and standard deviation for each measurement. 
Select only data corresponding to mean and standard deviation using select and contain command

Step 3 : Uses descriptive activity names to name the activities in the data set
1) Read the activity label mapping
2) Read the test and training activity data
3) Combine the testing and training activity data
4) rename the activity ID with activity description by using the mapping in 

1) Read the test and training subject data
2) Combine the testing and training subject data
3) Bind the subjectid and activity data with the main data

Step 4 : Appropriately labels the data set with descriptive variable names. 
1) Rename the column names by replace t with Time_, f with Frequency_,- with _ and removing () and repeated terms
2) Make all column names lower case

Step 5 : From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Perform activity by using group_by, summary and across

Step 6 : Write the data of main table and summary table in csv


