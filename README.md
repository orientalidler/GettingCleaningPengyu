GettingCleaningPengyu
=====================

Final Assignment for JHU getting cleaning
Before u run the run_analysis.r file, please make sure your work directory is the folder "\UCI HAR Dataset"
It is? Here we go! 

#Warm up: Extract the feature names from 'features.txt'
fea=read.table('features.txt',header=F, sep='')
names=as.character(fea[,2])


##Assignment 1.Merges the training and the test sets to create one data set##
#Move into'./train'
setwd('./train')
#List files
files1= dir()
#Read X_train.txt
t1=read.table(files1[3],header=F, sep='')
#Rename the columns by the feature names from 'features.txt'
colnames(t1)=names

##Assignment 2.Extracts only the measurements on the mean and standard deviation for each measurement#
nt1= t1[,grep("mean|std",names)]
#Read the other two files
t2=read.table(files1[2],header=F, sep='')
t3=read.table(files1[4],header=F, sep='')
#Combine the three files above into one dataframe ct1
ct1=cbind(t2,t3,nt1)
#Move into'./test'
setwd('../')
setwd('./test')
#Completely the same steps here as the last paragraph
files2= dir()
t21=read.table(files2[3],header=F, sep='')
colnames(t21)=names
nt21= t21[,grep("mean|std",names)]
t22=read.table(files2[2],header=F, sep='')
t23=read.table(files2[4],header=F, sep='')
#Combine the three files above into one dataframe ct2
ct2=cbind(t22,t23,nt21)

#Merge dataframes ct1, ct2 into one dataframe
t=rbind(ct1,ct2)
#Rename two columns
colnames(t)[1]='subject'
colnames(t)[2]='activity'
#Extract the activity column
act=as.factor(t[,2])
##Assignment 3.Uses descriptive activity names to name the activities in the data set##
levels(act) = list(WALKING='1', WALKING_UPSTAIRS='2',WALKING_DOWNSTAIRS='3', SITTING='4', STANDING='5', LAYING='6')
t[,2]=act

##Assignment 4.Appropriately labels the data set with descriptive variable names##
#Replace the orginal names by descriptive names, one by one
names(t)=gsub("fB","FFT-B",names(t))
names(t)=gsub("tB","Time-B",names(t))
names(t)=gsub("tG","Time-G",names(t))
names(t)=gsub("BodyBody","Body",names(t))
names(t)=gsub("std","Standard.Deviation",names(t))
names(t)=gsub("()","", names(t), fixed="TRUE")
names(t)=gsub("Freq","-Freq", names(t))

##Assignment 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject##
#Produce the new dataframe
aggdata <-aggregate(t[3:81], by=list(t[,1],t[,2]),FUN=mean)

#Modify column names
colnames(aggdata)[1]='subject'
colnames(aggdata)[2]='activity'
names(aggdata)=tolower(names(aggdata))
#Go back to the orginal work dir
setwd('../')
#Save the new dataframe as a text table
write.table(aggdata, "./final.txt", sep="\t")
#Done!
