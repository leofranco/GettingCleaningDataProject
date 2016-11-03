library(readr)
library(dplyr)

# First go to the working directory for this project
# please note that there is a subfolder here
# called "UCI HAR Dataset" which contains the
# data for the project
setwd("~/Coursera/GettingCleaningDataProject/")

# read the features (variable names)
# ncol(features)=2	nrow(features)=562
features <- read_delim("./UCI HAR Dataset/features.txt", delim = " ", col_names = FALSE)

# the 6 activity labes are: 
# WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS,
# SITTING, STANDING, LAYING
# ncol(activities)=2	nrow(activities)=6
activities <- read_delim("./UCI HAR Dataset/activity_labels.txt", delim = " ", col_names = FALSE)

# read the training set
#  ncol(training_set)=662	nrow(training_set)=7352
training_set <- read_delim("./UCI HAR Dataset/train/X_train.txt", delim = " ", col_names = FALSE) 
training_set <- training_set[3:ncol(training_set)]

# read the training labels
#  ncol(training_labels)=1	nrow(training_labels)=7352
training_labels <- read_delim("./UCI HAR Dataset/train/y_train.txt", delim = " ", col_names = FALSE)

# read the subjects for the training set
training_subjects <- read_delim("./UCI HAR Dataset/train/subject_train.txt", delim = " ", col_names = FALSE)


# read the test set
# ncol(test_set)=667	nrow(test_set)=2947 
test_set <- read_delim("./UCI HAR Dataset/test/X_test.txt", delim = " ", col_names = FALSE) 
test_set <- test_set[3:ncol(test_set)]

# read the test labels
# ncol(test_labels)=1	nrow(test_labels)=2947 
test_labels <- read_delim("./UCI HAR Dataset/test/y_test.txt", delim = " ", col_names = FALSE)

# read the subjects for the test set
test_subjects <- read_delim("./UCI HAR Dataset/test/subject_test.txt", delim = " ", col_names = FALSE)

##########
#
# Now we have all the date in different data frames
# The trick will be to combine it and extract what we need
# First note that each feature (row) has to match the columns
# of the data files (test and training)
#
# The problem here is that the dimensions don't match. Not even
# if we were generous with the numbers
# 
# Ideally we want to see that the number of features is the number
# of variables in the data set so that we can match each name
# of the feature to each column
#
# BUt that is not the case and I don't know enough of the data to
# actually match them accurately. The other issue is that they are
# all numbers so we can't infer anything from them
#
# Just to move on with the exercise I am going to assume that what
# I just said is true and each row of the features matches a 
# column of the data as it says in the README file
#
# From the README.txt
# "- Each feature vector is a row on the text file."
#
#########

# Now we have the features in a data frame
# Let's create a vector and then extract the
# features that are requested (those with mean
# or std in the name)
# length(features.vec) = 561
features.vec <- features$X2
features.pos <- grep("(*mean*)|(*std*)",features.vec)

training_set.subset <- training_set[features.pos]
colnames(training_set.subset) <- features.vec[features.pos]

# Here we have the training set with a subset
# of specified variables (the ones with a mean or std)

# We have to do the same for the test set in addition to the
# training set
test_set.subset <- test_set[features.pos]
colnames(test_set.subset) <- features.vec[features.pos]

# Now we have the columns that we neeed from
# the training and test set
# we have to join it with the siubjects
# and then we have to join the rows

colnames(training_subjects) <- c("subject")
colnames(training_labels) <- c("activity")
training_final <- cbind(training_subjects, training_labels, training_set.subset)

colnames(test_subjects) <- c("subject")
colnames(test_labels) <- c("activity")
test_final <- cbind(test_subjects, test_labels, test_set.subset)

data <- rbind(training_final, test_final)

#########
#
# The project asks for the following:

# You should create one R script called run_analysis.R that does the following.
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average
#   of each variable for each activity and each subject.
#
# Please not I didnt it in a different order since I first extracted
# the measurements and then I joined in one data set
#
# Reading this again I see that I still have to give better names
# to the variables. Let's do below.
#
data_names <- colnames(data)
data_names <- gsub("-mean", "Mean", data_names)
data_names <- gsub("-std", "StdDev", data_names)
data_names <- gsub("^t", "time", data_names)
data_names <- gsub("f", "frequency", data_names)
data_names <- gsub("Acc", "Accelerometer", data_names)
data_names <- gsub("Gyro", "Gyroscope", data_names)
colnames(data) <- data_names

# Lets double check everything that was asked:
#
# 2. We extracted the measurements on the mean and stddev
# 1. We merged the training and test data sets
# 4. We changed the variable names for something more descriptive  
# 

# Here I realize that I haven't done the point 3 yet:
# 3. Uses descriptive activity names to name the activities in the data set 
#
# For this we have to change the second column in the "data" data frame
# (the one called "activity"). Instead of having numbers we one to
# have the descriptions. remembers these descriptions were read
# before in the data frame "activities"
#

# turn the activities to lower case to make it easier to read
activities_vec <- tolower(activities$X2)

# change the numbers by the name of activities
# the trick here is to use the index of the
# activity to find the name
# Another way would be to join the data sets
data[2] <- sapply(data[2],function(x){activities_vec[x]})

# Now we have the first 4 points required for the project
#
# The last point is:
#
# 5. From the data set in step 4, creates a second, independent tidy data set with the average
#   of each variable for each activity and each subject.
#
# We can do that in just one line thank to R ;D
data_final <- data %>% group_by(subject,activity) %>% summarise_each(funs(mean(., na.rm = TRUE)))

write_delim(data_final, "data_final_means.txt", delim = " ", col_names = FALSE)

# in addition to the final data, I am going to write a file with the
# column names for it
write_delim(data.frame(1:length(data_names),data_names), "data_final_colnames.txt", delim = " ", col_names = FALSE)


