# Written by Mark Lammers; Institute for Evolution and Biodiversity, University of Münster; marklammers6@gmail.com
# (c) 2023. Released under the terms of the GNU General Public License v3.

counts.aggregate<-function(filename, ID.nchar){
  #load HTseq output
  counts.per.exon<-read.table(filename)
  
  #store meta tags in separate variable
  meta<-tail(counts.per.exon, 5)
  counts.per.exon<-counts.per.exon[1:(nrow(counts.per.exon)-5),]
  
  #exclude exons with zero reads
  #counts.per.exon<-counts.per.exon[counts.per.exon[,2]>0,]
  
  #for this file, most genes only have expressiond data for one exon, but some for up to 14 exons:
  table(as.data.frame(table(substring(counts.per.exon[,1],0,ID.nchar)))[,2])
  
  #store gene IDs in new column
  counts.per.exon[,3]<-substring(counts.per.exon[,1],1,ID.nchar)
  
  #sum expression data per gene
  counts.per.gene<-aggregate(counts.per.exon[,2],by=list(gene=counts.per.exon[,3]),sum)
  
  return(counts.per.gene)
}
