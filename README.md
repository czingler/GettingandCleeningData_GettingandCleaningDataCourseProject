## GettingandCleeningData_GettingandCleaningDataCourseProject

# Getting and Cleaning Data - Course Project
This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:

Downloads the dataset if it does not already exist in the working directory.
Loads the activity and feature information.
Loads both the training and test datasets, keeping only those columns which reflect a mean or standard deviation both are derived data.
Loads the activity and subject data for each dataset, and merges those columns with the relative dataset
Merge the two datasets train and test.
Convert the activity and subject columns into factors and normalizes based on these factors.

Creates a tidy dataset that consists of the average (mean) and standard deviation (Std Dev) value of each variable for each subject and activity pair.

###The end result is shown in the file tidy.txt a space delimited CSV like file avaliable for futher statisical analysis
