
### Introduction

This porject works with data collected from the accelerometers from the Samsung Galaxy S smartphone and produces 
tidy data that can be used for later analysis.

The submission includes README.md, run_analysis.R and CodeBook.md. 

README.md describes how the script run_analysis.R works and CodeBook.md describes all the variables and summaries 
calculated, along with units, and other relevant information.

### Overview 

run_analysis.R runs in the directory that contains the Samson data and produces a tidy data set in the following steps:

0. Read data from files. 
1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for 
   each activity and each subject.

### Step 0: Read data from files
<!-- -->


        features <- read.table("features.txt")
        # > str(features)
        # 'data.frame':        561 obs. of  2 variables:
        #  $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
        #  $ V2: Factor w/ 477 levels "angle(tBodyAccJerkMean),gravityMean)",..: 243 # 244 245 250 251 252 237 238 239 240 ...
        activity_labels <- read.table("activity_labels.txt")
        # > str(activity_labels)
        # 'data.frame':        6 obs. of  2 variables:
        # $ V1: int  1 2 3 4 5 6
        # $ V2: Factor w/ 6 levels "LAYING","SITTING",..: 4 6 5 2 3 1

        train_set <- read.table("./train/X_train.txt")
        train_labels <- read.table("./train/y_train.txt")
        subject_train <- read.table("./train/subject_train.txt")

        test_set <- read.table("./test/X_test.txt")
        test_labels <- read.table("./test/y_test.txt")
        subject_test <- read.table("./test/subject_test.txt")


* features is a 561x2 data frame, containing the names of 561 variables as factors in its column V2 and the
  index of the variables in integer from 1 to 561 in its column V1.
* activity_labels is a 6x2 data frame, containing the names of 6 activities as factors in its column V2 and 
  the corresponding label for each activitiy in integer from 1 to 6 in column V1.
* train_set is 7352x561 data frame, containg 7352 observations of the 561 variables as defined in features in
  the training set. Its column names for the 561 variables in each column are V1, V2, V3,..., V561 respectively.
* train_labels is a 7352x1 data frame, representing the labels in integer from 1 to 6 of each observation in 
  train_set. Its column name is V1.
* subject_train is a 7352x1 data frame, representing the subject in integer from 1 to 30 on whom each 
  observation in train_set was made. Its column name is V1.
* test_set is 2947x561 data frame, containg 2947 observations of the 561 variables as defined in features in
  the test set. Its column names for the 561 variables in each column are V1, V2, V3,..., V561 respectively.
* test_labels is a 2947x1 data frame, representing the labels in integer from 1 to 6 of each observation in 
  test_set. Its column name is V1.
* subject_test is a 2947x1 data frame, representing the subject in integer from 1 to 30 on whom each 
  observation in test_set was made. Its column name is V1.
   
### Step 1: Merge the training and the test sets to create one data set

   


        all_subject = rbind(subject_train, subject_test)
        colnames(all_subject) <- c("subject")
        all_labels <- rbind(train_labels, test_labels)
        colnames(all_labels) <- c("activity_label")
        all_features_values <- rbind(train_set, test_set)
        step1_data_set <- cbind(all_subject, all_labels, all_features_values)

 

* all_subject contains all subjects in training and test set. It's a 10299x1 data frame of integer with 
  column name subject.
* all_labels contains labels of all observations in training and test set. It's a 10299x1 data frame of 
  integer with column name activity_label.
* all_features_values is a data frame containing all 10299 observations of the 561 variables in training and 
  test set. Its column names for the 561 variables in each column are V1, V2, V3,..., V561 respectively.
* step1_data_set is the result of merging all training and test sets. Its a 10299x563 data frame, first column
  being all_subject with column name subject, second column being all_labels with column name activity_lable, and 
  the rest 561 columns being all_features_values with column names V1, V2, V3,..., V561 respectively.
  
  
### Step 2: extract only the measurements on the mean and standard deviation for each measurement


        selection <- c(grep("mean",features[,2]), 
               grep("std",features[,2]),grep("Mean",features[,2]))
        selected_features <- features[selection,]
        selected_features_values <- all_features_values[,selection]

        step2_data_set <- cbind(all_subject, all_labels, selected_features_values)

 
* selection is a integer vector with length 86 of the indices of all features whose names contains mean, std or Mean.
* selected_features is a subset of features. It's a 86x2 data frame, containing the names of the 86 features
  on the mean and standard deviation for each measurement as factors in its column V2 and the indicies of the 
  variables in integer in its column V1.
* selected_features_values cotains the selected 86 columns from all_features_values. It is a 10299x86 data frame . 
  The column name for each variable remain the same as in all_features_values.
* step2_data_set is the result of extracting  only the measurements on the mean and standard deviation for each 
  measurement from step1_data_set. It is a 10299x88 data frame, obtained by column binding all_subject, all_labels 
  and selected_features_values.
  
### Step 3: uses descriptive activity names to name the activities in the data set

        
        label_to_activity <- function(x){activity_labels[x, 2]}
        all_activity <- data.frame(sapply(all_labels, label_to_activity))
        colnames(all_activity) <- c("activity")
        step3_data_set <- cbind(all_subject, all_activity, selected_features_values) 
        

* label_to_activity defines a function that maps activity label to activity 
* all_activity is the result of mapping all_labels to activity. It is given column name activity.
* step3_data_set is the result of replacing the all_labels column by all_activity rolumn in step2_data_set, thus
  achieving descriptive activity names for the activities in the data set.
  

### Step 4: appropriately label the data set with descriptive variable names

        colnames(selected_features_values) <- make.names(as.character(selected_features$V2))
        step4_data_set <- step3_data_set
        colnames(step4_data_set) <- c("subject","activity",
        colnames(selected_features_values))
        
* starting from step3_data_set, we know the its first column reperesnts subject, second column represents activity,
  and the rest columns represent variables such as tBodyAcc-mean()-Y, tBodyAcc-mean()-X,...,etc. To make syntactically    
  valid column names for the variable columns, we use make.names to get rid of symbols like (). Thus, after 
  appropriately labeling the data set with descriptive variable names, we get step4_data_set
  
  
### Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

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
        write.table(step5_data_set, file="tidy_data.txt",row.name=FALSE)
  
*  Let's call this second, independent tidy data set with the average of each variable for each activity and each subject step5_data_set.
   Since there's an oberservation for each subject doing eaching activity, there will be number_of_subject x number_of_activity observations.
   In this case, number_of_subject = 30 and number_of_activity = 6, so step5_data_set will have 30 x 6 = 180 rows.
   
*  The first column of step5_data_set will be subject, with each number from 1 to 30 repeating 6 times followed by the next.

*  The second column of setp5_data_set will be activity, repeating the sequence WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING,
   STANDING, LAYING repeating 30 times.
   
*  for each variable in step4_data_set, there will be a corresponding new variable in step5_data_set to represent its averages of a certain
   subject doing a certain activity. Therefore, step5_data_set will have the same number of variables (86) as step4_data_set; let's name each
   new variable column Average.corresponding_setp4_data_set_variable_volumn_name
   
*  we first create a 180 x 86 matrix step5_features_values filled with 0s as a place holder for values of the new variables; we then
   calculate the actual means of the step4_data_set variables for each subject doing each activity and save them in the right place in the 
   matrix.
    
* column binding subject, activity, and step5_features_values, we obtain step5_data_set whcih satisfies the criteria fo a tidy data set.

  
* finally, we write step5_data_set to a text file

