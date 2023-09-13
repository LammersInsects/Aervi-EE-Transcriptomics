# Written by Mark Lammers; Institute for Evolution and Biodiversity, University of Münster; marklammers6@gmail.com
# (c) 2023. Released under the terms of the GNU General Public License v3.

#load function
source('1.code/counts.aggregate.R')

#import file list
files<-list.files(getwd(), pattern='sam.counts$', recursive = T)

#run function on each file
for(filename in files){
  res<-counts.aggregate(filename = filename, ID.nchar = 9)
  outfile<-unlist(strsplit(filename, '/', fixed=T))[3]
  outfile<-paste0('0.data/htseq-counts/',outfile, '.by.gene')
  write.table(res, outfile, sep = '\t', row.names = F, col.names = F, quote = F)
}
