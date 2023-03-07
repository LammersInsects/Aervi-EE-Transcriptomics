Map reads to a reference genome with HISAT2
===========================================

# Build an index to the reference genome

```bash
hisat2-build -p 16 -f 0.data/ref-genome/OGS3.0_20161222.fa 0.data/ref-genome/OGS3.0_20161222.index
```

# Align one set of reads to benchmark the mapping speed

## A test for single-end reads
```bash
INFILE=0.data/mlammers_ML01_Juni1/A006850201_172476_S21_L001_R1_001.trimmed.fastq.gz
OUTFILE=0.data/mlammers_ML01_Juni1/$(basename $INFILE .trimmed.fastq.gz).mapped
LOGFILE=4.logs/mapping.reads.log
echo At $(date +%Y-%m-%dT%H:%M:%S%z), starting file $INFILE ... >>$LOGFILE
hisat2 -t -p 16 -q --phred33 \
  --summary-file 4.logs/$(basename $OUTFILE).summary.txt --met-file 4.logs/$(basename $OUTFILE).metrics.txt \
  -x 0.data/ref-genome/OGS3.0_20161222.index \
  -U $INFILE \
  -S $OUTFILE.sam
#Receiving many warnings that reads are discarded because of their length!
echo At $(date +%Y-%m-%dT%H:%M:%S%z), finished mapping >>$LOGFILE
#Takes about 1 minute!
```

## A test for paired-end reads
```bash
INFILE1=0.data/mlammers_ML01_Mai11/A006850198_172407_S137_L001_R1_001.trimmed.paired.fastq.gz
INFILE2=${INFILE1/L001/L002}
OUTFILE=0.data/mlammers_ML01_Mai11/$(basename $INFILE1 .trimmed.paired.fastq.gz).mapped
LOGFILE=4.logs/mapping.reads.log
echo At $(date +%Y-%m-%dT%H:%M:%S%z), starting file $INFILE1 ... >>$LOGFILE
hisat2 -t -p 16 -q --phred33 \
  --summary-file 4.logs/$(basename $OUTFILE).summary.txt --met-file 4.logs/$(basename $OUTFILE).metrics.txt \
  -x 0.data/ref-genome/OGS3.0_20161222.index \
  -1 $INFILE1 \
  -2 $INFILE2 \
  --un-gz $OUTFILE.unp.unal \
  --al-gz $OUTFILE.unp.al \
  --un-conc-gz $OUTFILE.unc.unal \
  --al-conc-gz $OUTFILE.unc.al \
  -S $OUTFILE.sam
#Receiving again many warnings that reads are discarded because of their length!
echo At $(date +%Y-%m-%dT%H:%M:%S%z), finished mapping >>$LOGFILE
#Takes about 3 minutes

find . -name "*map*"
#All files are there
```

# Use a for loop to align all samples

## Juni1

## Mai11
