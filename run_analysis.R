
### 1. Merges the training and the test sets to create one data set

# Make sure to set your working directory to the folder "UCI HAR Datase" !!!


#combine the train files:
    
X_train <- read.table(file = "train/X_train.txt")
y_train <- read.table(file = "train/y_train.txt")
subject_train <- read.table(file = "train/subject_train.txt")

train <- cbind(subject_train, y_train, X_train)
rm(subject_train, y_train, X_train)

#combine the test files:

X_test <- read.table(file = "test/X_test.txt")
y_test <- read.table(file = "test/y_test.txt")
subject_test <- read.table(file = "test/subject_test.txt")

test <- cbind(subject_test, y_test, X_test)
rm(subject_test, y_test, X_test)

#combine train and test:

complete <- rbind(train, test)
rm(train, test)

#load the list of features:

features <- read.table(file = "features.txt")

#set descriptive column names:

cols <- c("Person", "Activity", as.character(features[ ,2]))
colnames(complete) <- cols
rm(features)


#######################################################################

### 2. Extracts only the measurements on the mean and the standard deviation for each measurement

#boolean vectors for all mean values and std values:
means <- grepl("mean", cols)
stds <- grepl("std", cols)
subset_bool <- means + stds

#We also need the first 2 columns (Person + Activity):

subset_bool[1:2] <- 1

#convert back to a vector of booleans:

subset_bool <- subset_bool > 0

#subset the "complete" dataset:

mean_std <- complete[ , subset_bool]
rm(complete, cols, means, stds, subset_bool)


#######################################################################

### 3. Uses descriptive activity names to name the activities in the data set

#load the list of activities and their numbers:

activity_labels <- read.table(file = "activity_labels.txt")

#replace the numbers in column 2 of mean_std ("Activity_labels") by the activity names:

mean_std$Activity <- activity_labels[ ,2][match(mean_std$Activity, activity_labels [,1])]
rm(activity_labels)


#######################################################################

### 4. Appropriately labels the data set with descriptive variable names:

#already done in step 1


#######################################################################

### 5. From the data in step 4, creates a second, independent tidy data set with the average
###    of each variable for each activity and each subject

#group by columns 1 and 2 (Person and Activity) 
#and calculate the mean for all other columns (3 to 81)

aggr <- aggregate( mean_std[,3:81], mean_std[,1:2], FUN = mean )
rm(mean_std) 

#write the result into a new *.txt file:
write.table(aggr, file = "aggregatedData.txt", row.names = FALSE)

