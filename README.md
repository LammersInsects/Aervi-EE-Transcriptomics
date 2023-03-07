*Aphidius ervi* EE transcriptomics
================================

- By Mark Lammers ©, marklammers@uni-muenster.de
- Repo started: 01.02.2023 ('%d.%m.%Y')
- Last update:  07.03.2023

# A flexibly fluctuating but targeted todo-list

- [ ] Data handling
  - [x] ~~Verify data integrity~~
  - [x] ~~Inspect MultiQC output~~
  - [x] ~~Make new FastQC and MultiQC reports~~
  - [x] ~~Import sample information and match with file names~~
  - [x] ~~Make separate MultiQC reports per tissue type~~
  - [x] ~~Generate new MultiQC results per tissue type~~
  - [ ] Add overview of samples with information on generation and treatment
- [ ] Data processing
  - [x] ~~Choose software for adapter trimming~~
  - [x] ~~Run adapter trimming on all samples~~
  - [x] ~~Re-run FastQC and MultiQC to compare adapter trimming efficacy~~
  - [x] ~~Choose software for mapping reads to the reference genome~~
  - [x] ~~Install HISAT2~~
  - [x] ~~Copy latest version of the reference genome into 0.data~~
  - [x] ~~Build index to the reference genome~~
  - [x] ~~Benchmark mapping to reference genome on `jgant3`~~
  - [x] ~~Map all reads to the reference genome~~
  - [ ] Summarize mapping rates, overall and per tissue type
- [ ] DGE analysis
  - [ ] Choose pipeline
  - [ ] Calculate FPKM


# Project Setup

See [`1.code/project.setup.md`](1.code/project.setup.md)

# Sample information

- Species: *Aphidius ervi* strain 'Katz'
- Experiment: Multi-generational tissue-specific transcriptomic differences due to host adaptation.
- Input material: 156 RNA extracts of varying quality from insect tissue samples.
- Tissues: heads, ovaries, venom glands.
- Method: Lexogen QuantSeq 3′ mRNA-Seq (Illumina), see [the Lexogen Quantseq website](https://www.lexogen.com/docs/quantseq/).
- Data: 96GB of Illumina RNAseq data in FASTQ format, 312+19 libraries.

See also `0.data/mlammers_ML01_*/Sample_Names.tab` for specific samples names.

This information is also collated in [`0.data/Sample.info.tab`](0.data/Sample.info.tab) and [`0.data/Files.info.tab`](0.data/Files.info.tab) after running [`1.code/collect.sample.info.Rscript`](1.code/collect.sample.info.Rscript).
The file [`0.data/Files-Samples.info.tab`](0.data/Files-Samples.info.tab) is a merge of the separate files.

# Handling and assessing raw data

## Retrieve data

For the instructions on the first, big, Mai11 dataset, see `0.data/instructions_big_data_set.txt`.

For the instruction on the second, small, Juni1 dataset, see `0.data/instructions_small_data_set.txt`.

The small data set (Juni1) contains data on 19 samples which were resequenced because ***CHECK***.
Interestingly, there are no _L002_ files for these runs.

## Check data integrity

md5sums generated by the Cologne sequencing center (CCG), before retrieval of data, are stored in `0.data/mlammers_ML01_*/md5_checksums.tab`.

Combine them into one file:
```bash
cat 0.data/mlammers_ML01_Juni1/md5_checksums.tab >0.data/md5sums_original.txt
cat 0.data/mlammers_ML01_Mai11/md5_checksums.tab >>0.data/md5sums_original.txt
```

Generate local md5sums:
```bash
md5sum 0.data/mlammers_ML01_*/A00* >>0.data/md5sums_local.txt
sed -i 's/0.data\/mlammers_ML01_Juni1\///g' 0.data/md5sums_local.txt
sed -i 's/0.data\/mlammers_ML01_Mai11\///g' 0.data/md5sums_local.txt
sed -i 's/  / /g' 0.data/md5sums_local.txt
```
Compare files with checksums:
```bash
md5sum 0.data/md5sums_*.txt
# 495a242412612329a2f7d42b54c792cf  0.data/md5sums_local.txt
# 495a242412612329a2f7d42b54c792cf  0.data/md5sums_original.txt
# So the checksums stored in both files, as well as the file names, must be identical between these files
```

## Store a backup of the data on the IEB server
```bash
mkdir /global/scratch2/mlammer1/aervi-ee-rnaseq
rsync -ah --bwlimit=1500 --info=progress2 ./0.data/* /global/scratch2/mlammer1/aervi-ee-rnaseq/
# Expected runtime at 1.5 MB/s is about 17.5 hours
```

## Quality control of raw data

- Base calling quality scores are recorded in phred33 format, i.e. capital letters represent top quality.
- The sequencing center provided `multiqc` output with the two data sets.
  - See `0.data/mlammers_ML01_*/FastQC/multiqc_report.html`.

Copy the files to `3.results`, add to repo, and inspect:
```bash
cp -v 0.data/mlammers_ML01_Mai11/FastQC/multiqc_report.html 3.results/multiqc_report_Mai11.html
cp -v 0.data/mlammers_ML01_Juni1/FastQC/multiqc_report.html 3.results/multiqc_report_Juni1.html
git add -f 3.results/multiqc_report_Mai11.html 3.results/multiqc_report_Juni1.html
```

See [`1.code/compare.fastqc.per.tissue.md`](1.code/compare.fastqc.per.tissue.md) for producing `MultiQC` output per tissue type.

See `3.results/own_multiqc_reports_*` for `MultiQC` output per tissue type.

Overview of sequence data quality:

Variable | Mai11 | Juni1 | Heads | Ovaries | Venom glands
---------|-------|-------|-------|---------|-------------
Nr samples | 312 | 19 | 108 | 118 | 105
% duplicates | 34.8-92.5 | 36.6-77.5 | 38.6-67.1 | 34.8-86.1 | 72.4-92.5%
%GC | 32-48 | 32-42 | 32-40 | 32-44 | 35-48%
Read length | 101 | 101 | 101 | 101 | 101
Reads per sample | 2.8-10.7M | 4.2-9.1M | 3.5-9.3M | 2.8-10.7M | 4.4-8.5M
Mean seq quality | Excellent | Excellent | Excellent | Excellent | 172694 dips to 27.7
Adapter content start | Negligible | Negligible | Negligible | Negligible | Negligible
Adapter content end | Up to 36% | Up to 29% | 10.3-25.4% | 9.2-36.4% | 5.8-29.7%

- Quite a spread in certain variables!
- Based on duplication levels, the venom glands may on average be the poorest data sets.
- Adapter trimming may correct for disparity, but some differences per tissue type are expected to remain.

# Data processing

## Adapter trimming

> Bolger AM, Lohse M & Usadel B (2014) Trimmomatic: A flexible trimmer for Illumina sequence data. Bioinformatics 30:2114–2120.

- Since adapters are present towards the end of up to 36% of the reads, we must run adapter trimming.
  - See [`1.code/trim.adapters.md`](1.code/trim.adapters.md).

## Re-run `FastQC` & `MultiQC` on trimmed fastq reads

See [`1.code/fastqc.after.trimming.md`](1.code/fastqc.after.trimming.md).

Overview of sequence data quality improvement:

Variable | All before trimming | All after trimming
---------|---------------------|-------------------
Nr samples | 331 | 331
% duplicates | 34.8-92.5 % | 32.6-92.2 %
GC content | 32-48 % | 30-43 %
Average read length | 101 bp | 79-99 bp
Reads per sample | 2.8-10.7M | 2.8-10.6M
Mean seq quality | Excellent | Excellent
Adapter content start | Negligible | Negligible
Adapter content end | 5.8-36.4 % | 1.1-11.9 %

Overall data quality is much improved, seems like the majority of adapters got trimmed. I'm satisfied with this result.

## Mapping to reference genome with `HISAT2 v2.2.1`

> Kim, D., Paggi, J.M., Park, C. et al. Graph-based genome alignment and genotyping with HISAT2 and HISAT-genotype. Nat Biotechnol 37, 907–915 (2019). https://doi.org/10.1038/s41587-019-0201-4

- The `HISAT2` manual is available [on this website](http://daehwankimlab.github.io/hisat2/manual).
- Process for installing it on a workstation is described in [`1.code/project.setup.md`](1.code/project.setup.md).

Copy the reference genome into the data folder:
```bash
mkdir 0.data/ref-genome
cp -rv ~/Documents/aervi-genome/v3.0/* 0.data/ref-genome/
rm -v 0.data/ref-genome/ref-genome-bowtie2-index.* #delete old bowtie indices
```

See [`1.data/map.reads.md`](1.data/map.reads.md) for the full process of building the index and mapping all reads.
