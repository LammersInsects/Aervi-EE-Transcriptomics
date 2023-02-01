Aphidius ervi EE transcriptomics
================================

- By Mark Lammers ©, marklammers@uni-muenster.de
- Repo started: 01.02.2023 ('%d.%m.%Y')
- Last update:  01.02.2023

# Project Setup

See `1.code/project.setup.md`

# Sample information

- Species: Aphidius ervi 'Katz'
- Experiment: Multi-generational tissue-specific transcriptomic differences due to host adaptation.
- Input material: 156 RNA extracts of varying quality from insect tissue samples.
- Tissues: heads, ovaries, venom glands.
- Method: Lexogen QuantSeq 3′ mRNA-Seq (Illumina), see `https://www.lexogen.com/docs/quantseq/`.
- Data: Illumina RNAseq.

See also `0.data/mlammers_ML01_*/Sample_Names.tab` for specific samples names.

# Handling and assessing raw data

## Retrieve data

See `0.data/instructions_big_data_set.txt`
and `0.data/instructions_small_data_set.txt`.

## Check data integrity

md5sums before retrieval of data are stored in `0.data/mlammers_ML01_*/md5_checksums.tab`.

TODO: compare checksums

## Quality control of raw data

The sequencing center provided `multiqc` output with the two data sets.

See `0.data/mlammers_ML01_*/FastQC/multiqc_report.html`

# Data processing

## Adapter trimming

(if necessary)

## Mapping to reference genome

TODO
