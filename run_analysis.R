library(dplyr)

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

datX <- rbind(X_train, X_test)
datY <- rbind(Y_train, Y_test)
dat_subj <- rbind(subject_train, subject_test)

selected_var <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
datX <- datX [,selected_var[,1]]

colnames(datY) <- "activity"
datY$activitylabel <- factor(datY$activity, labels = as.character(activity_labels[,2]))
activitylabel <- datY[,-1]

colnames(datX) <- features[selected_var[,1],2]

colnames(dat_subj) <- "subject"
total <- cbind(datX, activitylabel, dat_subj)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
