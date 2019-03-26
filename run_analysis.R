#Uncomment if readr package not installed
#install.packages("readr");
library(readr);
#Need UCI HAR Dataset folder of HAR data 
X_train<-read_table2("UCI HAR Dataset/train/X_train.txt",col_names = FALSE)
subject_train<-read_table2("UCI HAR Dataset/train/subject_train.txt",col_names<-'subject')
y_train<-read_table2("UCI HAR Dataset/train/y_train.txt",col_names<-'activity')
X_test<-read_table2("UCI HAR Dataset/test/X_test.txt",col_names=FALSE)
subject_test<-read_table2("UCI HAR Dataset/test/subject_test.txt",col_names<-'subject')
y_test<-read_table2("UCI HAR Dataset/test/y_test.txt",col_names<-'activity')
#read in column labels
col_labels<-read_table2("UCI HAR Dataset/features.txt",col_names=FALSE)
namelist <-c(col_labels[,2])
#merge train measurement, subject, and activity data into one dataset
merge_train<-cbind(X_train,subject_train,y_train)
names(merge_train)<-c(namelist[[1]],"subject","activity")
merge_test<-cbind(X_test,subject_test,y_test)
names(merge_test)<-c(namelist[[1]],"subject","activity")
#merge train and test
merge_all<-rbind(merge_train,merge_test)
filtered<-merge_all[,c(grep('mean\\(\\)|std\\(\\)',names(merge_all)),562,563)]
filtered$activity <-as.character(filtered$activity)
filtered$activity[filtered$activity == "1"] <- "WALKING"
filtered$activity[filtered$activity == "2"] <- "WALKING_UPSTAIRS"
filtered$activity[filtered$activity == "3"] <- "WALKING_DOWNSTAIRS"
filtered$activity[filtered$activity == "4"] <- "SITTING"
filtered$activity[filtered$activity == "5"] <- "STANDING"
filtered$activity[filtered$activity == "6"] <- "LAYING"
allmeans<-apply(filtered[,-c(67,68)],2,function(x) tapply(x,list(filtered$subject,filtered$activity),mean))
allmeans<-cbind(subject=rep(1:30,times=6),allmeans)
allmeans<-cbind(activity=rep(c("LAYING","SITTING","STANDING","WALKING","WALKING_DOWNSTAIRS","WALKING_UPSTAIRS"),each=30),allmeans)