# Written by Mark Lammers (c) 2023, marklammers6@gmail.com

cat('Currently in',getwd(),'\n')

# Load sample names tables and append path
df1<-read.table('0.data/mlammers_ML01_Juni1/Sample_Names.tab',
                sep='\t', header=T, row.names=NULL, stringsAsFactors=F)
df1$Path<-'0.data/mlammers_ML01_Juni1/'
df2<-read.table('0.data/mlammers_ML01_Mai11/Sample_Names.tab',
           sep='\t', header=T, row.names=NULL, stringsAsFactors=F)
df2$Path<-'0.data/mlammers_ML01_Mai11/'
df<-rbind(df1,df2)
colnames(df)<-c('FileID','Sample.Name','Path')
cat('Found',nrow(df),'samples\n')

test<-as.data.frame(table(df$FileID))
cat(nrow(test),'samples have multiple files :')
multiple<-df[df$FileID %in% test$Var1[test$Freq>1],]
print(multiple[order(multiple$FileID),])

# Split the Sample.Name column
df$Sample<-sapply(strsplit(df$Sample.Name, split='-'),`[`,1)
df$Tissue<-sapply(strsplit(df$Sample.Name, split='-'),`[`,2)
table(df$Tissue)
table(df$Sample)

# Append file info to the list of file paths names of the corresponding fastq file

## Load file names
files<-data.frame(File.name=c(paste('0.data/mlammers_ML01_Juni1/',
                                    list.files('0.data/mlammers_ML01_Juni1/', pattern='A00'), sep=''),
                              paste('0.data/mlammers_ML01_Mai11/',
                                    list.files('0.data/mlammers_ML01_Mai11/', pattern='A00'), sep='')))
cat('Found',nrow(files),'files\n')

## Extract FileIDs and other information
files<-cbind(files,t(sapply(strsplit(files, split = '_'),`[`,3:7)))
colnames(files)<-c('File.name','A00','FileID','S','L','R')
files$A00<-gsub('Mai11/','', files$A00, fixed = T)
files$A00<-gsub('Juni1/','', files$A00, fixed = T)
files$Path<-substring(files$File.name,1,27)

## Combine files and samples
res<-merge(files, df, by=c('Path','FileID'), all.x=T)
table(res$Tissue)
table(res$Sample)

# Export results
write.table(df, '0.data/Sample.info.tab', sep='\t', row.names=F, quote=F)
write.table(files, '0.data/Files.info.tab', sep='\t', row.names=F, quote=F)
write.table(res, '0.data/Files-Samples.info.tab', sep='\t', row.names=F, quote=F)
