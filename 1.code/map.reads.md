Map reads to a reference genome with HISAT2
===========================================

# Build an index to the reference genome

```bash
hisat2-build -p 16 -f <reference_in> <ht2_base>
```

# Align one set of reads to benchmark the mapping speed

```bash
INFILE=
LOGFILE="4.logs/mapping.reads.log
echo Starting file $INFILE at $(date) ... >>$LOGFILE
echo "... Done at $(date)">>$LOGFILE
```

# Use a for loop to align all samples

## Juni1

## Mai11
