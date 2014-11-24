

#set working directory to the directory that contains the Samsung data
#setwd("~/coursera/getting and cleaning data/project/UCI HAR Dataset")

#######################################################################
# read data from files
#######################################################################
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

train_set <- read.table("./train/X_train.txt")
train_labels <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

test_set <- read.table("./test/X_test.txt")
test_labels <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

########################################################################
# Step 1: merge the training and the test sets to create one data set
########################################################################

all_subject = rbind(subject_train, subject_test)
colnames(all_subject) <- c("subject")
all_labels <- rbind(train_labels, test_labels)
colnames(all_labels) <- c("activity_label")
all_features_values <- rbind(train_set, test_set)
step1_data_set <- cbind(all_subject, all_labels, all_features_values)

#########################################################################*
# Step 2: extract only the measurements on the mean and standard deviation 
#       for each measurement
##########################################################################
selection <- c(grep("mean",features[,2]), 
               grep("std",features[,2]),grep("Mean",features[,2]))
selected_features <- features[selection,]
selected_features_values <- all_features_values[,selection]

step2_data_set <- cbind(all_subject, all_labels, selected_features_values)

############################################################################
# Step 3: uses descriptive activity names to name the activities in the data 
#       set
#############################################################################

label_to_activity <- function(x){activity_labels[x, 2]}
all_activity <- data.frame(sapply(all_labels, label_to_activity))
colnames(all_activity) <- c("activity")
step3_data_set <- cbind(all_subject, all_activity, selected_features_values)

##############################################################################
# Step 4: appropriately label the data set with descriptive variable names
##############################################################################
colnames(selected_features_values) <- make.names(as.character(selected_features$V2))
step4_data_set <- step3_data_set
colnames(step4_data_set) <- c("subject","activity",
    colnames(selected_features_values))

################################################################################
# Step 5: From the data set in step 4, creates a second, independent tidy data 
#       set with the average of each variable for each activity and each subject
#################################################################################
num_subject <- nrow(unique(all_subject))
num_activity <- length(activity_labels$V2)
num_features <- nrow(selected_features)

subject <- rep(1:num_subject, each = num_activity )
activity <- rep(activity_labels$V2, num_subject)


step5_features_values <- matrix(rep(0, num_subject*num_activity*num_features), 
    nrow = num_subject*num_activity, ncol = num_features)
colnames(step5_features_values) <- 
    paste("Average.",colnames(selected_features_values) ,sep="")



for (i in 1:num_subject){
    for (j in 1:num_activity){
        num_row <- (i-1)*num_activity + j
        for (k in 1:num_features){
            step5_features_values[num_row, k] = 
                mean(step4_data_set[step4_data_set$subject==i & 
                    step4_data_set$activity == activity_labels$V2[j],k+2])
        }
    }
}


step5_data_set<- cbind(subject, activity, data.frame(step5_features_values))
colnames(step5_data_set) = c("subject","activity", colnames(step5_features_values))

write.table(step5_data_set, file="tidy_data.txt",row.name=FALSE)

# to view the tidy data set produced by the end of step 5, use 
# tidy_data <- read.table("tidy_data.txt") 
# View(tidy_data)
