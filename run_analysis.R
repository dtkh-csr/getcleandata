temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
thefolder <- unz(temp, "UCI_HAR_Dataset")
thedata <- read.csv('./UCI HAR Dataset/')
unlink(temp)

file_list = list.files(pattern="*.txt", recursive = TRUE) 
# Read the files in, assuming comma separator
files_df <- lapply(file_list, function(x) {read.table(file = x, header = F, sep =" ")})
# Combine them
combined_df <- do.call("rbind", lapply(txt_files_df, as.data.frame)) 