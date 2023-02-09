Trim the adapters from raw RNAseq data
======================================

# Overview of expected adapters

- These are provided by CCG in [`0.data/instructions_big_data_set.txt`](0.data/instructions_big_data_set.txt) and [`0.data/instructions_small_data_set.txt`](0.data/instructions_small_data_set.txt).

Read1:
- AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
- AGATCGGAAGAGCACACGTCTGAAC
- TGGAATTCTCGGGTGCCAAGG
- AGATCGGAAGAGCACACGTCT
- CTGTCTCTTATACACATCT
- AGATGTGTATAAGAGACAG

Read2:
- AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
- AGATCGGAAGAGCGTCGTGTAGGGA
- TGGAATTCTCGGGTGCCAAGG
- AGATCGGAAGAGCACACGTCT
- CTGTCTCTTATACACATCT
- AGATGTGTATAAGAGACAG

They have been saved in [`0.data/adapters.fasta`](0.data/adapters.fasta).

# Test adapter trimming on a single data set with `trimmomatic`

See the [github source page of trimmomatic](https://github.com/usadellab/Trimmomatic/).

SE mode for Juni1 data set:
```bash
INFILE1=0.data/mlammers_ML01_Juni1/A006850201_172476_S21_L001_R1_001.fastq.gz
OUTFILE=0.data/mlammers_ML01_Juni1/$(basename $INFILE1 .fastq.gz).trimmed.fastq.gz
java -jar ~/software/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 16 -phred33 \
  $INFILE1 \
  $OUTFILE \
  ILLUMINACLIP:0.data/adapters.fasta:2:30:10
# Worked! Took about 1 minute
```

PE mode for Mai11 data set:
```bash
INFILE1=0.data/mlammers_ML01_Mai11/A006850198_172407_S137_L001_R1_001.fastq.gz
INFILE2=${INFILE1/L001/L002}
OUTFILE=0.data/mlammers_ML01_Mai11/$(basename $INFILE1 .fastq.gz).trimmed
java -jar ~/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 16 -phred33 \
  $INFILE1 $INFILE2 \
  $OUTFILE.forward_paired.fastq.gz $OUTFILE.forward_unpaired.fastq.gz \
  $OUTFILE.reverse_paired.fastq.gz $OUTFILE.reverse_unpaired.fastq.gz \
  ILLUMINACLIP:0.data/adapters.fasta:2:30:10
# Worked! Took about 1 minute
```

# Run `trimmomatic` on all data with a simple for loop

SE mode for Juni1 data set:
```bash
COUNT=0
TOTAL=$(cat 0.data/Files.info.tab | grep Juni | wc -l)
for INFILE1 in $(cat 0.data/Files.info.tab | grep Juni | cut -f1);
do
  let COUNT+=1
  echo Running file $COUNT of $TOTAL ...
  OUTFILE=0.data/mlammers_ML01_Juni1/$(basename $INFILE1 .fastq.gz).trimmed.fastq.gz
  java -jar ~/software/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 16 -phred33 \
    $INFILE1 \
    $OUTFILE \
    ILLUMINACLIP:0.data/adapters.fasta:2:30:10
done
```
