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
OUTFILE=0.data/mlammers_ML01_Mai11/$(basename $INFILE .trimmed.fastq.gz).mapped
LOGFILE=4.logs/mapping.reads.log
echo At $(date +%Y-%m-%dT%H:%M:%S%z), starting file $INFILE ... >>$LOGFILE
hisat2 -t -p 16 -q --phred33 --rna-strandness R \
  -x 0.data/ref-genome/OGS3.0_20161222.index \
  -U $INFILE \
  -S $OUTFILE.sam \
  --summary-file 4.logs/mapping.$OUTFILE.log
echo At $(date +%Y-%m-%dT%H:%M:%S%z), finished mapping >>$LOGFILE
```

## A test for paired-end reads
```bash
INFILE1=
INFILE2=${INFILE1/L001/L002}
OUTFILE=
echo At $(date +%Y-%m-%dT%H:%M:%S%z), starting file $INFILE ... >>$LOGFILE
hisat2 -t -p 16 -q --phred33 --rna-strandness R \
  -x 0.data/ref-genome/OGS3.0_20161222.index \
  -1 $INFILE1 \
  -2 $INFILE2 \
  --un-gz (path) \
  --al-gz (path) \
  --un-conc-gz (path) \
  -S $OUTFILE.sam \
  --summary-file 4.logs/mapping.$OUTFILE.log
echo At $(date +%Y-%m-%dT%H:%M:%S%z), finished mapping >>$LOGFILE
```

# Use a for loop to align all samples

## Juni1

## Mai11
