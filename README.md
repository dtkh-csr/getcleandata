# getcleandata
Peer-graded assignment for Getting and Cleaning Data Course

The script "run_analysis.R" performs the following to get and clean the data to produce 2 tidy/clean datasets:
1. download the zip file from data source, unzip it to a folder, and then delete the downloaded zip file
2. preparations:
a. read activity labels from "activity_labels.txt" to rename the activity index numbers with their corresponding description text in the indicated activities for each record set of measurements
b. read the names of measurements containing "mean()" and "std()" to filter out measurements in each record set of measurements
3. read each record set of measurements by corresponding subject and activities into 3 individual tables: measurement, subject, activity
4. combine the 3 tables in step #3 into 1 clean dataset
5. create a second, independent tidy dataset containing average of each variable for each activity and each subject
6. write both datasets into 2 csv files along with 2 txt files
