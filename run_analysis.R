fea=read.table('features.txt',header=F, sep='')
names=as.character(fea[,2])

setwd('./train')
files1= dir()
t1=read.table(files1[3],header=F, sep='')
colnames(t1)=names
nt1= t1[,grep("mean|std",names)]
t2=read.table(files1[2],header=F, sep='')
t3=read.table(files1[4],header=F, sep='')
ct1=cbind(t2,t3,nt1)

setwd('../')
setwd('./test')
files2= dir()
t21=read.table(files2[3],header=F, sep='')
colnames(t21)=names
nt21= t21[,grep("mean|std",names)]
t22=read.table(files2[2],header=F, sep='')
t23=read.table(files2[4],header=F, sep='')
ct2=cbind(t22,t23,nt21)

t=rbind(ct1,ct2)
colnames(t)[1]='subject'
colnames(t)[2]='activity'
act=as.factor(t[,2])
levels(act) = list(WALKING='1', WALKING_UPSTAIRS='2',WALKING_DOWNSTAIRS='3', SITTING='4', STANDING='5', LAYING='6')
t[,2]=act

names(t)=gsub("fB","FFT-B",names(t))
names(t)=gsub("tB","Time-B",names(t))
names(t)=gsub("tG","Time-G",names(t))
names(t)=gsub("BodyBody","Body",names(t))
names(t)=gsub("std","Standard.Deviation",names(t))
names(t)=gsub("()","", names(t), fixed="TRUE")
names(t)=gsub("Freq","-Freq", names(t))

aggdata <-aggregate(t[3:81], by=list(t[,1],t[,2]),FUN=mean)
colnames(aggdata)[1]='subject'
colnames(aggdata)[2]='activity'
names(aggdata)=tolower(names(aggdata))
write.table(aggdata, "./final.txt", sep="\t")