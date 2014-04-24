##unzip file and rename the UCI HAR Dataset without spaces: UCIHARDataset
	Xtest <- read.table("UCIHARDataset/test/X_test.txt")
	ytest <- read.table("UCIHARDataset/test/y_test.txt")
	testSubj <- read.table("UCIHARDataset/test/subject_test.txt")
	Xtrain <- read.table("UCIHARDataset/train/X_train.txt")
	ytrain <- read.table("UCIHARDataset/train/y_train.txt")
	trainSubj <- read.table("UCIHARDataset/train/subject_train.txt")

##read the variable names and the activity labels 
	varName <- read.table("UCIHARDataset/features.txt")
	varName <- as.character(varName[,2])
	actv <- read.table("UCIHARDataset/activity_labels.txt") 
	actv <- as.character(actv[,2])

##transform the numeric atcv into the adequate descriptive actv names
	ytestActv <- factor(ytest[,1], labels = actv)
	ytrainActv <- factor(ytrain[,1], labels = actv) 

##"naming" the cols for the two datasets
	colnames(Xtest) <- varName
	colnames(Xtrain) <- varName

##selecting variables involving mean and Stdev
##but deleting from these those that are labelled as mean
##but ARE NOT mean values itself.
	match1 <- "Mean|mean|std"
	match2 <- "meanFreq|gravityMean|tBodyAccMean"
	varNew <- varName[grep(match1, varName)]
	varNew <- varNew[-grep(match2, varNew)]
##subsetting
	testMeanStd <- Xtest[,which(names(Xtest) %in% varNew)]
	trainMeanStd <- Xtrain[,which(names(Xtrain) %in% varNew)] 

##adding 2 cols with the subj and the activity
	testSet <- cbind(testMeanStd,testSubj, ytestActv)
	trainSet <- cbind(trainMeanStd,trainSubj, ytrainActv)

##naming last two cols
	colnames(testSet)[67] <- "subject" ;colnames(testSet)[68] <- "activity"
	colnames(trainSet)[67] <- "subject";colnames(trainSet)[68]<- "activity"

##row binding the data
	samsungData <- rbind(trainSet,testSet)
##order the data by subject
	samsungData <- samsungData[order(samsungData$subject),]

##change the following line for:
##write.csv(samsungData, file = "samsungData.csv", row.names = FALSE)
##for a (larger) csv file
	save(samsungData, file = "samsungData.rda")




