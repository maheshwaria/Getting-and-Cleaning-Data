##load dplyr package
require(reshape2)


## Read ACtivity and Features
activityLabels=read.table("./UCI HAR Dataset/activity_labels.txt")
featureLabels=read.table("./UCI HAR Dataset/features.txt")
featureLabels=featureLabels[,2]

## Make featureLabels more readable and get a list of columns containing Mean or Std
featureLabels=gsub("-mean","Mean",featureLabels)
featureLabels=gsub("-std","Std",featureLabels)
selectedColumns = grep("Mean|Std",featureLabels,value=TRUE)

## Read Training X, Y, Subject
dataTrainX=read.table("./UCI HAR Dataset/train/X_train.txt")
dataTrainY=read.table("./UCI HAR Dataset/train/Y_train.txt")
dataTrainSubject=read.table("./UCI HAR Dataset/train/subject_train.txt")

## Add activity label
dataTrainY[,2]=activityLabels[dataTrainY[,1],2]

## Update feature / activity/ subject column names for Training data
names(dataTrainX)=featureLabels
names(dataTrainY)=c("Activity_ID","Activity_LABEL") 
names(dataTrainSubject)=c("Subject") 

## Select mean and std columns from Training data
dataTrainX=dataTrainX[,selectedColumns]

## Read Training X, Y, Subject
dataTestX=read.table("./UCI HAR Dataset/test/X_test.txt")
dataTestY=read.table("./UCI HAR Dataset/test/Y_test.txt")
dataTestSubject=read.table("./UCI HAR Dataset/test/subject_test.txt")

## Add activity label
dataTestY[,2]=activityLabels[dataTestY[,1],2]

## Update feature / activity/ subject column names for Testing Data
names(dataTestX)=featureLabels
names(dataTestY)=c("Activity_ID","Activity_LABEL") 
names(dataTestSubject)=c("Subject")

## Select mean and std columns from Test data
dataTestX=dataTestX[,selectedColumns]

## Combine X, Y , SUbject for Training and Test
dataTrain=cbind(dataTrainX, dataTrainY, dataTrainSubject)
dataTest=cbind(dataTestX, dataTestY, dataTestSubject)

## Consolidate Training Test data
dataAll=rbind(dataTrain,dataTest)

## melt the data to make a skinny table with 5 columns 
## (SUbject, Activity_ID, Activity_LABEL, variable, value)
## variable is name of feature and value is value of feature

dataMelted=melt(dataAll,id=c("Subject","Activity_ID","Activity_LABEL"),
            measure.vars=selectedColumns)

## Cast the data with mean function so that for each subject and activity there will
## be one row of output. Given 30 subjects and 6 activities there will be 180 rows
dataTidy=dcast(dataMelted,Subject+Activity_LABEL~variable,mean)

## Wtite it out for further processing or whatever you need to do
write.table(dataTidy, file = "./tidy_data.txt",sep="\t")
