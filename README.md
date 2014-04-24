Readme file for run_analysis.R
========================================================

Once you have downloaded getdata-projectfiles-UCI HAR Dataset.zip and unzip it in you work directory you will notice that there is a new directory called "UCI HAR Dataset". Given that spaces are sometimes problematic, simply remane this directory to "UCIHARDataset" before running the code. 

The program is fairly simple and the code includes explanatory sentences. 

The first lines simply read the files of interest, containing the values of the variables, the subject for which these values where measured and a numeric value associated with the activity for the training and the . 

```{r}
  Xtest <- read.table("UCIHARDataset/test/X_test.txt")
	ytest <- read.table("UCIHARDataset/test/y_test.txt")
	testSubj <- read.table("UCIHARDataset/test/subject_test.txt")
	Xtrain <- read.table("UCIHARDataset/train/X_train.txt")
	ytrain <- read.table("UCIHARDataset/train/y_train.txt")
	trainSubj <- read.table("UCIHARDataset/train/subject_train.txt")
```

The next few lines read the names of the variables and the labels of the activities: WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING and LAYING

```{r}
  varName <- read.table("UCIHARDataset/features.txt")
	varName <- as.character(varName[,2])
	actv <- read.table("UCIHARDataset/activity_labels.txt") 
	actv <- as.character(actv[,2])
```

The next four lines transform the numeric activity information stored in ytest and y train into adequate descriptive activity names and assign names to the column in 
the test and the train datasets.

```{r}
  ytestActv <- factor(ytest[,1], labels = actv)
	ytrainActv <- factor(ytrain[,1], labels = actv) 
	colnames(Xtest) <- varName
	colnames(Xtrain) <- varName
```

Next we select just those variables involving mean and stdev measurements. We then add the two columns correspoding to the subject and the activity and we name these two colums accordingly. Note that meanFreq, gravityMeanm and tBodyAccMean denote variables that are not mean values "per se" but overall weigthed magnitudes that are then used on the angle() measurement. Therefore, we exclude them from the final, tidy data.

```{r}
  match1 <- "Mean|mean|std"
	match2 <- "meanFreq|gravityMean|tBodyAccMean"
	varNew <- varName[grep(match1, varName)]
	varNew <- varNew[-grep(match2, varNew)]

	testMeanStd <- Xtest[,which(names(Xtest) %in% varNew)]
	trainMeanStd <- Xtrain[,which(names(Xtrain) %in% varNew)] 
	testSet <- cbind(testMeanStd,testSubj, ytestActv)
	trainSet <- cbind(trainMeanStd,trainSubj, ytrainActv)
	colnames(testSet)[87] <- "subject" ;colnames(testSet)[88] <- "activity"
	colnames(trainSet)[87] <- "subject";colnames(trainSet)[88]<- "activity"
```
Finally, we "row" bind the data, order by subject (from 1 to 30) and save it to a rds file. In the program there is an alternative line (commented) to save it into a csv file. However, the csv file is "heavier". In addition, characters such as "-", "__", or "()", which are present in the variable names, are usually "uncomfortable" when saving as csv. Just a warning. 

```{r}
  samsungData <- rbind(trainSet,testSet)
	samsungData <- samsungData[order(samsungData$subject),]
	save(samsungData, file = "samsungData.rda")
```  

Typing:
```{r}
  source("run_analysis.R")
```  
will produce a rda file with the tidy Data required. 
