# Written by Mark Lammers (c) 2023, marklammers6@gmail.com

cat('Currently in',getwd(),'\n')

# Load sample names tables
df<-rbind(read.table('0.data/mlammers_ML01_Juni1/Sample_Names.tab',
                     sep='\t', header=T, row.names=NULL, stringsAsFactors=F),
          read.table('0.data/mlammers_ML01_Mai11/Sample_Names.tab',
                     sep='\t', header=T, row.names=NULL, stringsAsFactors=F))
colnames(df)<-c('FileID','Sample.Name')
cat('Found',nrow(df),'samples\n')

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

## Extract FileIDs
files$FileID<-substring(files$File.name,39,44)

## Combine files and samples
res<-merge(files, df, by='FileID', all.x=T)
table(res$Tissue)
table(res$Sample)

# Export results
write.table(df, '0.data/Sample.info.tab', sep='\t', row.names=F, quote=F)
write.table(res, '0.data/Files.info.tab', sep='\t', row.names=F, quote=F)
