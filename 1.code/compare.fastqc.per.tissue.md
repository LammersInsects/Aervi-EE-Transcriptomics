Compare FastQC per tissue type
==============================

```bash
# Do new FastQC analysis so that I also have the .zip output

#Mai11
mkdir 0.data/mlammers_ML01_Mai11/own-fastqc
fastqc --outdir 0.data/mlammers_ML01_Mai11/own-fastqc \
  --threads 16 0.data/mlammers_ML01_Mai11/A00*.fastq.gz
#Juni1
mkdir 0.data/mlammers_ML01_Juni1/own-fastqc
fastqc --outdir 0.data/mlammers_ML01_Juni1/own-fastqc \
  --threads 16 0.data/mlammers_ML01_Juni1/A00*.fastq.gz

# Run multiqc on all files together
pip install --user multiqc
ls -lha 0.data/mlammers_ML01_*/own-fastqc/A00*_fastqc.zip | less
mkdir 3.results/own_multiqc_reports
python3 -m multiqc --interactive -o 3.results/own_multiqc_reports \
  0.data/mlammers_ML01_*/own-fastqc/A00*_fastqc.zip

# Run multiqc per tissue type
cat 0.data/Files-Samples.info.tab | grep head >0.data/Files.info.heads.tab
cat 0.data/Files-Samples.info.tab | grep ovaries >0.data/Files.info.ovaries.tab
cat 0.data/Files-Samples.info.tab | grep venom >0.data/Files.info.venom.tab
wc -l 0.data/Files.info.*
#  108 0.data/Files.info.heads.tab
#  118 0.data/Files.info.ovaries.tab
#  332 0.data/Files.info.tab
#  105 0.data/Files.info.venom.tab
#  663 total

for TISSUE in heads ovaries venom;
do
  echo "Collecting input files for" $TISSUE;
  TIMES=$(wc -l 0.data/Files.info.$TISSUE.tab | cut -f1 -d' ');
  echo "Found" $TIMES "files";
  ls $(paste <(cat 0.data/Files.info.$TISSUE.tab | cut -f1) \
    <(yes "own-fastqc/" | head -n $TIMES) \
    <(cat 0.data/Files.info.$TISSUE.tab | cut -f4) \
    <(yes "_" | head -n $TIMES) \
    <(cat 0.data/Files.info.$TISSUE.tab | cut -f2) \
    <(yes "*_fastqc.zip" | head -n $TIMES) \
    --delimiters '') | sort | uniq >tmp;
  python3 -m multiqc --interactive -o 3.results/own_multiqc_reports_$TISSUE $(cat tmp);
done;
```

