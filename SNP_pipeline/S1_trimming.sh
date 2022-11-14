#!/bin/bash 
#SBATCH -p all
#SBATCH -N 1
#SBATCH -n 12
#SBATCH --array=1-8
#SBATCH -J trimming
#SBATCH -t 20:00:00

module load trimmomatic

samplesheet="sample_sheet1.txt"
name=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet |  awk '{print $1}'` 
r1=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet |  awk '{print $2}'` 
r2=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet |  awk '{print $3}'`

mkdir trimmed_reads

trimmomatic PE $r1.fastq.gz $r2.fastq.gz \
./trimmed_reads/"$name"_forward_paired.fq.gz ./trimmed_reads/"$name"_forward_unpaired.fq.gz \
./trimmed_reads/"$name"_reverse_paired.fq.gz ./trimmed_reads/"$name"_reverse_unpaired.fq.gz \
LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:50
