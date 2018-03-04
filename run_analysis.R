## step 0 - set working dir and load the dplyr library
##----------------------------------------------------

setwd("c:/Coursera/R_course_Johns_Hopkins/_workdir/03_Getting_And_Cleaning_Data/week04_CP/")
getwd()

library(dplyr)


## step 1 - read test and train data and labels 
##---------------------------------------------

# read train data sets
subject_train_set <- read.table("train/subject_train.txt")
values_train_set <- read.table("train/X_train.txt")
activity_train_set <- read.table("train/y_train.txt")

# read test data sets
subject_test_set <- read.table("test/subject_test.txt")
values_test_set <- read.table("test/X_test.txt")
activity_test_set <- read.table("test/y_test.txt")

# read feature labels
features <- read.table("features.txt", as.is = TRUE)

# read activity labels
activities <- read.table("activity_labels.txt", as.is = TRUE)
colnames(activities) <- c("activityID", "activityLabel")


## step 2 - merge the train and test sets to one data set
##-------------------------------------------------------

# merge train and test set together

merge_train <- cbind(subject_train_set, values_train_set, activity_train_set)
merge_test <- cbind(subject_test_set, values_test_set, activity_test_set)
merge_data <- rbind(merge_train, merge_test)

# make some free memory

rm(activity_test_set, activity_train_set, subject_test_set, subject_train_set, values_test_set, values_train_set, merge_test, merge_train)

# set the column names

colnames(merge_data) <- c("subject", features[, 2], "activity")


## step 3 - change activity data set from integer to name factor
##--------------------------------------------------------------

merge_data$activity <- factor(merge_data$activity, levels = activities[,1], labels = activities[,2])


## step 4 - keep the mean and std measures only
##---------------------------------------------

# select the mean and std measures and keep the subject and the activity column
columnKeep <- grepl("subject|activity|mean|std", colnames(merge_data))

# removing columns from the merged data
merge_data <- merge_data[, columnKeep]


## step 5 - tidy the column names
##-------------------------------

merge_data_cols <- colnames(merge_data)
merge_data_cols

# keep only the alphanumeric characters
merge_data_cols <- gsub("\\)", "", merge_data_cols)
merge_data_cols <- gsub("\\(", "", merge_data_cols)
merge_data_cols <- gsub("-", "", merge_data_cols)

# remove the duplicate body name
merge_data_cols <- gsub("BodyBody", "Body", merge_data_cols)

# change the abbreviations to names using the features_info.txt
merge_data_cols <- gsub("Acc", "Accelerometer", merge_data_cols)
merge_data_cols <- gsub("Gyro", "Gyroscope", merge_data_cols)
merge_data_cols <- gsub("^t", "time", merge_data_cols)
merge_data_cols <- gsub("^f", "frequency", merge_data_cols)

# correct the small and capital letters
merge_data_cols <- gsub("mean", "Mean", merge_data_cols)
merge_data_cols <- gsub("std", "STD", merge_data_cols)

# set the new label
colnames(merge_data) <- merge_data_cols


## step 6 - export the data by creating the average of each variable for each activity and each subject
##-----------------------------------------------------------------------------------------------------

# grouping data by mean
merge_data_mean <- merge_data %>% group_by(activity, subject) %>% summarise_all(funs(mean))

# export data
write.table(merge_data_mean, "tidy_data.txt", row.names = FALSE, quote = FALSE)
