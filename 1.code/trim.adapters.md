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
java -jar ~/software/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 16 -phred33 \
  input_file.fastqz \
  output_file.fastqz \
  ILLUMINACLIP:0.data/adapters.fasta:2:30:10
```

PE mode for Mai11 data set:
```bash
java -jar ~/software/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 16 -phred33 \
  input_forward.fq.gz input_reverse.fq.gz \
  output_forward_paired.fq.gz output_forward_unpaired.fq.gz \
  output_reverse_paired.fq.gz output_reverse_unpaired.fq.gz \
  ILLUMINACLIP:0.data/adapters.fasta:2:30:10
```

# Run `trimmomatic` on all data with a simple for loop

#TODO
