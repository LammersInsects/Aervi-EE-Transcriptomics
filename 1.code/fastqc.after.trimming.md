Run FastQC after adapter trimming
==============================

```bash
# Do new FastQC analysis 

#Mai11 (ignoring unpaired reads)
mkdir 0.data/mlammers_ML01_Mai11/fastqc-trimmed
fastqc --outdir 0.data/mlammers_ML01_Mai11/fastqc-trimmed \
  --threads 16 0.data/mlammers_ML01_Mai11/A00*.trimmed.*_paired.fastq.gz
#Juni1
mkdir 0.data/mlammers_ML01_Juni1/fastqc-trimmed
fastqc --outdir 0.data/mlammers_ML01_Juni1/fastqc-trimmed \
  --threads 16 0.data/mlammers_ML01_Juni1/A00*.trimmed.fastq.gz

# Run multiqc on all files together
ls -lha 0.data/mlammers_ML01_*/fastqc-trimmed/A00*_fastqc.zip | less
mkdir 3.results/multiqc_reports_trimmed
python3 -m multiqc -f --interactive -o 3.results/own_multiqc_reports_trimmed \
  0.data/mlammers_ML01_*/fastqc-trimmed/A00*_fastqc.zip
```

