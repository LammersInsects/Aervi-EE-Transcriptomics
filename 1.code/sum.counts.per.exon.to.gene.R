# Written by Mark Lammers; Animal Ecology, Vrije Universiteit Amsterdam; marklammers6@gmail.com
# (c) 2018-2022. Released under the terms of the GNU General Public License v3.

sum.counts.per.exon.to.gene<-function(filename){
  #load file
  counts.per.exon<-read.table(filename)
  
  #store meta tags in separate variable
  meta<-tail(counts.per.exon, 5)
  counts.per.exon<-counts.per.exon[1:(nrow(counts.per.exon)-5),]
  
  #exclude exons with zero reads
  counts.per.exon<-counts.per.exon[counts.per.exon[,2]>0,]
  
  #for this file, most genes only have expressiond data for one exon, but some for up to 14 exons:
  table(as.data.frame(table(substring(counts.per.exon[,1],0,9)))[,2])
  
  #store gene IDs in new column
  counts.per.exon[,3]<-substring(counts.per.exon[,1],1,9)
  
  #sum expression data per gene
  counts.per.gene<-aggregate(counts.per.exon[,2],by=list(gene=counts.per.exon[,3]),sum)
  
  return(counts.per.gene)
}

filename='D:/DATA/Projects_scientific/Experiments/2019-2021_Postdoc_Muenster/Aphidius_ervi_transcriptomes/A006850198_172721_S292_L001_R1_001.mapped.sam.counts'
res<-sum.counts.per.exon.to.gene(filename = filename)
outfile<-paste0(filename, '.by.gene')
write.table(res, outfile, sep = '\t', row.names = F, col.names = F, quote = F)
