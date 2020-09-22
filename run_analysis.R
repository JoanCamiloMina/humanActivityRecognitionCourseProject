#Joan Camilo Mina Trujillo, Course Project, Getting and Cleaning Data
#Johns Hopkins University, Data Science Specialization



#Point 1 Load and merge train and test datasets
x_training_set_url <- 
  "./data/UCI HAR Dataset/train/X_train.txt"
y_training_set_url <- 
  "./data/UCI HAR Dataset/train/y_train.txt"
train_subject_url <-"./data/UCI HAR Dataset/train/subject_train.txt"
x_test_set_url <-
  "./data/UCI HAR Dataset/test/X_test.txt"
y_test_set_url <-
  "./data/UCI HAR Dataset/test/y_test.txt"
test_subject_url <- "./data/UCI HAR Dataset/test/subject_test.txt"
variables_names_url <- "./data/UCI HAR Dataset/features.txt"
activities_names_url <- "./data/UCI HAR Dataset/activity_labels.txt"

#X training data
X_train_data <- read.fwf(x_training_set_url,widths=(rep.int(16,561)))
str(x_train_data)
#Y training data
y_train_data <- read.fwf(y_training_set_url,widths=c(1))
str(y_train_data)
#X Test Data
X_test_data <- read.fwf(x_test_set_url,widths=(rep.int(16,561)))
str(X_test_data)
#Y Test Data
y_test_data <- read.fwf(y_test_set_url,widths=c(1))
str(y_test_data)

#Merge Datasets
full_X_data <- rbind(X_train_data,X_test_data)
str(full_X_data)
full_y_data <- rbind(y_train_data,y_test_data)
str(full_y_data)

#Point 2: Extract Mean And Standard Deviation Measurements
#Load the Variables´s Names into a DF
variables_names <- read.csv(variables_names_url, sep=" ", header=FALSE)
names(variables_names) <- c("index","varname")
variables_names$varname <- tolower(variables_names$varname)
str(variables_names)
#Search for variables's indexes with mean() or std() expressions 
mean_std_variables <- grep("mean()|std()", variables_names$varname)
str(mean_std_variables)
#Use indexes to extract only those variables related to mean() and std()
X_mean_std_data <- full_X_data[ , mean_std_variables] 
str(X_mean_std_data)

#Point 4: Appropriately labels the data set with descriptive variable names.
#Set descriptive variables names using the variables names data
names(X_mean_std_data) <- variables_names[variables_names$index %in% mean_std_variables, "varname"]
names(X_mean_std_data)

#Point 3: Use/Set Descriptive Activity Names
#Sets y data Var name to activity instead of just V1
names(full_y_data) <- c("activity")
#Loads Activities´s labels into a dataframe
activities_labels <- read.csv(activities_names_url,sep=" ",header=FALSE)
names(activities_labels) <- c("level","label")
#Sets Activity Variable as a factor and assigns a label for each activity
full_y_data$activity <- factor(full_y_data$activity,levels=activities_labels$level,
                               labels=activities_labels$label)
summary(full_y_data)

#Point 5: From the data set in step 4, creates a second, independent tidy 
#data set with the average of each variable for each activity and each subject.

#Adds a column where to include the Subject id to the X_mean_std_data dataframe.
library(dplyr)
train_subject <- read.csv(train_subject_url,header=FALSE)
test_subject <- read.csv(test_subject_url,header=FALSE)
full_subject <- rbind(train_subject,test_subject)
X_mean_std_data <- cbind(X_mean_std_data, full_subject)
names(X_mean_std_data)[names(X_mean_std_data)=="V1"]<-"subject" 
summary(X_mean_std_data$subject)
#Binds activity data to X_mean_std_data
X_mean_std_data <- cbind(X_mean_std_data, full_y_data)
names(X_mean_std_data)[names(X_mean_std_data)=="full_y_data"]<-"activity"
summary(X_mean_std_data$activity)
#Groups data by activity and subject
by_activity_subject <- group_by_at(X_mean_std_data, vars("activity","subject"))
str(by_activity_subject)
#Calculates The Avg of each feature using the groups created in prev line
mean_by_activity_subject <- 
  summarise_at(by_activity_subject,variables_names$varname[mean_std_variables], 
               mean, na.rm=TRUE)

head(mean_by_activity_subject)
