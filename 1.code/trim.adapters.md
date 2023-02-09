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

- Running `trimmomatic` with this set has little effect on the adapter content in the Juni1 data set.
- Found that sequence GCACACGTCTGAACTCCAGTCAC is overrepresented in the data. This is the reverse complement of the Illumina TruSeq Universal Adapter sequence.
  - Added this to the adapter list.
  - This also did not have any effect.
- Try it with the adapters listed in TruSeq3-PE-2.fa


# Test adapter trimming on a single data set with `trimmomatic`

See the [github source page of trimmomatic](https://github.com/usadellab/Trimmomatic/).

SE mode for Juni1 data set:
```bash
INFILE1=0.data/mlammers_ML01_Juni1/A006850201_172517_S27_L001_R1_001.fastq.gz
OUTFILE=0.data/mlammers_ML01_Juni1/$(basename $INFILE1 .fastq.gz).trimmed.fastq.gz
java -jar ~/software/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 16 -phred33 \
  $INFILE1 \
  $OUTFILE \
  ILLUMINACLIP:/home/mlammer1/software/Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa:2:30:10
# Worked! Took about 1 minute

# Run FastQC to check efficacy straight away
fastqc --outdir 0.data/mlammers_ML01_Juni1/fastqc-trimmed \
  --threads 16 0.data/mlammers_ML01_Juni1/A006850201_172517_S27_L001_R1_001.trimmed.fastq.gz
python3 -m multiqc -f --interactive -o 3.results/own_multiqc_reports_trimmed \
  0.data/mlammers_ML01_*/fastqc-trimmed/A00*_fastqc.zip
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
done | tee -a 4.logs/trim.adapters.Juni1.txt 2>&1
```
