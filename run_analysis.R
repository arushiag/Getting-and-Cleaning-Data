library(dplyr)

# unzipping the folder and saving it in outDir
zipF<- "/Users/arushiagarwal/Documents/Coursera/John Hopkins course/Getting and Cleaning Data/week4.zip"
outDir<-"/Users/arushiagarwal/Documents/Coursera/John Hopkins course/Getting and Cleaning Data/unzip"
unzip(zipF,exdir=outDir)

# read train data
X_train <- read.table( "/Users/arushiagarwal/Documents/Coursera/John Hopkins course/Getting and Cleaning Data/unzip/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table( "/Users/arushiagarwal/Documents/Coursera/John Hopkins course/Getting and Cleaning Data/unzip/UCI HAR Dataset/train/Y_train.txt")
sub_train <- read.table( "/Users/arushiagarwal/Documents/Coursera/John Hopkins course/Getting and Cleaning Data/unzip/UCI HAR Dataset/train/subject_train.txt")

# read test data
X_test <- read.table("/Users/arushiagarwal/Documents/Coursera/John Hopkins course/Getting and Cleaning Data/unzip/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("/Users/arushiagarwal/Documents/Coursera/John Hopkins course/Getting and Cleaning Data/unzip/UCI HAR Dataset/test/Y_test.txt")
sub_test <- read.table("/Users/arushiagarwal/Documents/Coursera/John Hopkins course/Getting and Cleaning Data/unzip/UCI HAR Dataset/test/subject_test.txt")

# read data description
varnanes <- read.table("/Users/arushiagarwal/Documents/Coursera/John Hopkins course/Getting and Cleaning Data/unzip/UCI HAR Dataset/features.txt")

# read activity labels
activity_labels <- read.table("/Users/arushiagarwal/Documents/Coursera/John Hopkins course/Getting and Cleaning Data/unzip/UCI HAR Dataset/activity_labels.txt")

# 1. Merges the training and the test sets to create one data set.
X_total <- rbind(X_train,X_test)
Y_total <- rbind(Y_train,Y_test)
sub_total <- rbind(sub_train,sub_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
selected_var <- varnanes[grep("mean\\(\\)|std\\(\\)",varnanes[,2]),]
X_total <- X_total[,selected_var[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(Y_total) <- "activities"
Y_total$activitylabel <- factor(Y_total$activities, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]

# 4. Appropriately labels the data set with descriptive variable names.
colnames(X_total) <- varnanes[selected_var[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.
colnames(sub_total) <- "subjects"
total <- cbind(X_total, activitylabel, sub_total)
group <- total %>% group_by(activitylabel, subjects) %>% summarise_all(mean)
write.table(group, file = "/Users/arushiagarwal/Documents/Coursera/John Hopkins course/Getting and Cleaning Data/unzip/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
