#combines all files from the folders

dir <- "UCI HAR Dataset/train/"
group <- "train"

df <- read.table( paste0(dir, "subject_", group, ".txt") )
df <- cbind(df, read.table( paste0(dir, "y_", group, ".txt") ))
df <- cbind(df, read.table( paste0(dir, "X_", group, ".txt") ))

trainingData <- df


dir <- "UCI HAR Dataset/test/"
group <- "test"

df <- read.table( paste0(dir, "subject_", group, ".txt") )
df <- cbind(df, read.table( paste0(dir, "y_", group, ".txt") ))
df <- cbind(df, read.table( paste0(dir, "X_", group, ".txt") ))


testData <- df

#combined training and test sets
allData <- rbind(trainingData, testData)


# name the variables taking names from the feature document
namesData <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=F)
namesData <- namesData[,2]
names(allData) <- c("subject", "activityCode", namesData)

# these have "mean" or "std" in their name:
meanOrStd <- grepl("mean|std", names(allData))

# include first two columns
meanOrStd[1:2] <- TRUE

# select all rows but only columns with mean or std in their names:
selectedData <- allData[, meanOrStd]

# replace activitycode with activity label from the text document

#actNames <- read.table("UCI HAR Dataset/activity_labels.txt")
#selectedData$activityCode <- actNames[selectedData$activityCode,2]

#document the change with new variable name
#colnames(selectedData)[2] <- "activity"

# make a new data frame for means
meanDF <- data.frame()

d <- selectedData

for (s in sort(unique(d$subject)))
{
  print (s)
  for (a in sort(unique(d$activity)))
  {
    # means <- colMeans( d[ d$subject==s & d$activity==a, 3:81 ])
    # whoAndWhat <- c(s, a)
    # newRow <- rbind(whoAndWhat, means)
    # newRow <- cbind(s, means)
    # newRow <- means

    sel <- d[ d$subject==s & d$activity==a, ]
    means <- colMeans(sel)

    meanDF <- rbind(meanDF, means)
    
  }
}

# check that there are combinations:
meanDF[,1:2]

ncol(meanDF)     
# 81

nrow(meanDF)
# 180

names(meanDF) <- names(d)

# save as a file:
write.table(meanDF, "means.txt")

