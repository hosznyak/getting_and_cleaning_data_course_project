# Steps

The `run_analysis.R` contains 6 steps:

* Step 1: reading the test and train data sets and the files for the column labels.
* Step 2: merging the test and train data sets to one data set, using `cbind` and `rbind`.
* Step 3: change the `activity` column data set from integer to a named factor.
* Step 4: keep the mean and standard devaition measures only.
* Step 5: tidy the column names.
* Step 6: generate a new dataset with all the average measures for each subject and each activity (`tidy_data.txt`).

# Data and variables

* Data from the source files: subject_train_set, values_train_set, activity_train_set, subject_test_set, values_train_set, activity_train_set
