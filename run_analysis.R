#import libraries
library(plyr)

#set to the location of the test data files
setwd("C:/Users/Nick/Documents/Data Science - Online Course/RStudio Work/course3/UCI HAR Dataset")


##import data to memory

#import training data
trainingLabels <- read.table("train/y_train.txt")
trainingSet <- read.table("train/X_train.txt")
trainingSubject <- read.table("train/subject_train.txt")

#import test data
testLabels <- read.table("test/y_test.txt")
testSet <- read.table("test/X_test.txt")
testSubject <- read.table("test/subject_test.txt")

#import subject

#get column headers
columnsName <- read.table("features.txt")
transposedColumnsName <- t(columnsName[2])
colNames <- c("activity","subject", transposedColumnsName)


#create merged data frames and add the column names in
df_merged <- rbind(cbind(testLabels, testSubject, testSet),cbind(trainingLabels, trainingSubject, trainingSet))
colnames(df_merged) <- colNames

#get only the identifying columns, standard deviations (std) and the means into the final data frame
df_final <- df_merged[,grep("activity|subject|std|mean", names(df_merged), value=TRUE)]

#swap in the natural language activities names
activities <- read.table("activity_labels.txt")
levels <- activities[,1]
labels <- activities[,2]
df_final$activity <- factor(df_final$activity, levels=levels,labels=labels)

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
df_tidy_output <- ddply(df_final, .(activity, subject), numcolwise(mean))

#note this leaves the data in wide form.  I will make a codebook for this, but that is a terrible and boring activity
write.table(df_tidy_output, "tidyout.txt", row.name=FALSE)
