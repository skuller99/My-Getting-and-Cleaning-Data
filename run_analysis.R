# Steps 1-4
# Load labels and features
labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

#training data 
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
names(x_train) <- features$V2  # Step 4 - Appropriately labels the data set with descriptive variable names
x_train <- cbind(subject = subject_train$V1,activity = y_train$V1,set = "train",x_train) # Binds subject, activity, set, and value data

#test data
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
names(x_test) <- features$V2 # Step 4 - Appropriately labels the data set with descriptive variable names
x_test <- cbind(subject = subject_test$V1,activity = y_test$V1,set = "test",x_test) # Binds subject, activity, set, and value data

# Training + test data
data <- rbind(x_train,x_test) # Step 1 - Merges the training and the test sets to create one data set
data <- data[ , !duplicated(colnames(data))] # Fixed duplicate problem
library(dplyr)
data <- tbl_df(data)
tidy_data <- select(data,subject, activity, set,contains("mean()"),contains("std()")) %>% # Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement
    merge(labels,by.x="activity",by.y = "V1") # Step 3 - Uses descriptive activity names to name the activities in the data set
tidy_data$activity <- tidy_data$V2 # Step 3
tidy_data$V2 <- NULL # Step 3

step_5 <- tidy_data %>% 
    group_by(subject,activity) %>%
    summarise_each(funs(mean))  # Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
step_5$set <- NULL  

rm("data","features","labels","y_test","y_train","x_test","x_train","subject_test","subject_train")
# Leaves only needed data in environment

write.table(step_5,"step_5_data.txt",row.name = FALSE) # Output to file
