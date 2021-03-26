library(dplyr)

zipfilename = "UCI HAR Dataset.zip"
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", zipfilename)
unzip(zipfilename)
file.remove(zipfilename)

#read activity labels
activity_ref <- as.data.frame(read.table(file="UCI HAR Dataset/activity_labels.txt", col.names=c("ID", "Activity")), check.names=FALSE)

#read mean() and std() measurements
measurement_ref <- as.data.frame(read.table(file="UCI HAR Dataset/features.txt", col.names=c("ID","Measurement")), check.names=FALSE)
filtered_measurement_ref <- measurement_ref %>% filter(grepl("mean\\(\\)*", Measurement)|grepl("std\\(\\)*", Measurement))
cc <- rep('NULL', nrow(measurement_ref))      
cc[filtered_measurement_ref[,1]] <- 'numeric'     # to mark mean() and std() measurements for filtering measurement values later 

#read subject_train.txt and subject_test.txt into column "Subject" of a table
subject_list = list.files(pattern="^subject_t*", recursive = TRUE) 
# Read the files into column "Subject"
subjects_df <- lapply(subject_list, function(x) {read.table (file = x, col.names = "Subject")})
# Combine them
combinedsubjects_df <- do.call("rbind", lapply(subjects_df, function(x) {as.data.frame(x, check.names=FALSE)})) 

#read y_train.txt and y_test.txt into column "Activity" of a table
activity_list = list.files(pattern="^y_t*", recursive = TRUE) 
# Read the files into column "Activity"
activities_df <- lapply(activity_list, function(x) {read.table (file = x, col.names = "Act")})
# Combine them
combinedactivities_df <- do.call("rbind", lapply(activities_df, function(x) {as.data.frame(x, check.names=FALSE)})) 
#replace activity numbers with their corresponding activity names/description
combnamedactivities_df <- combinedactivities_df %>% merge(activity_ref, by.x="Act", by.y="ID") %>% select(2)

#read X_train.txt and X_test.txt into measurement mean/standard-deviation columns of a table
measurement_list = list.files(pattern="^X_t*", recursive = TRUE) 
# Read the files of selected entries (mean and standard deviation measurements only) indicated by cc into a table
measurements_df <- lapply(measurement_list, function(x) {read.table(file = x, sep ="", colClasses=cc)})
# Combine them
combinedmeasurements_df <- do.call("rbind", lapply(measurements_df, function(x) {as.data.frame(x, check.names=FALSE)})) 
colnames(combinedmeasurements_df) = filtered_measurement_ref$Measurement

#combine all 3 tables into 1 dataset
combined_dataset <- do.call("cbind", list(combinedsubjects_df, combnamedactivities_df, combinedmeasurements_df))
#sort the dataset according to ascending subject IDs
combined_dataset <- arrange(combined_dataset, Subject)

#create another dataset of variable/measurement averages for each activity and each subject
averaged_dataset <- combined_dataset %>% group_by(Activity, Subject) %>% summarise_all(.funs = c(mean="mean"))

#write the datasets into csv files and txt files
write.csv(combined_dataset, "clean_dataset.csv", row.names = FALSE)
write.csv(averaged_dataset, "averaged_dataset.csv", row.names = FALSE)
write.table(combined_dataset, "clean_dataset.txt", row.names = FALSE)
write.table(averaged_dataset, "averaged_dataset.txt", row.names = FALSE)