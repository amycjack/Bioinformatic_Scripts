#!/bin/bash

# Define the paths to the Picard and bwa binaries
PICARD_PATH=~/bin/picard-tools-1.8.5
BWA_PATH=/path/to/bwa

# Define the input FASTA file and input FASTQ files
REFERENCE=reference.fasta
R1_FASTQ=R1.fastq.gz
R2_FASTQ=R2.fastq.gz

# Step 1: Create sequence dictionary
java -jar $PICARD_PATH/CreateSequenceDictionary.jar REFERENCE=$REFERENCE OUTPUT=${REFERENCE%.fasta}.dict

# Step 2: Align reads and assign read group, Sort sam file, and Mark duplicates
bwa mem -R "@RG\tID:FLOWCELL1.LANE1\tPL:ILLUMINA\tLB:test\tSM:PA01" $REFERENCE $R1_FASTQ $R2_FASTQ | \
java -jar $PICARD_PATH/SortSam.jar SORT_ORDER=coordinate | \
java -jar $PICARD_PATH/MarkDuplicates.jar I=/dev/stdin O=${BAM%.bam}.dedup.bam METRICS_FILE=metrics.txt

# Step 3: Sort bam file (Indexing is done automatically after the previous step)
java -jar $PICARD_PATH/SortSam.jar I=dedup.bam O=${BAM%.bam}.sorted_dedup.bam SORT_ORDER=coordinate

# Step 4: Create graphs
$PICARD_PATH/MeanQualityByCycle.jar \
INPUT=${BAM%.bam}.sorted_dedup.bam \
CHART_OUTPUT=mean_quality_by_cycle.pdf \
OUTPUT=read_quality_by_cycle.txt \
REFERENCE_SEQUENCE=$REFERENCE


$PICARD_PATH/QualityScoreDistribution.jar \
INPUT=${BAM%.bam}.sorted_dedup.bam \
CHART_OUTPUT=mean_quality_overall.pdf \
OUTPUT=read_quality_overall.txt \
REFERENCE_SEQUENCE=$REFERENCE


$PICARD_PATH/CollectWgsMetrics.jar \
INPUT=${BAM%.bam}.sorted_dedup.bam OUTPUT=stats_picard.txt \
REFERENCE_SEQUENCE=$REFERENCE \
MINIMUM_MAPPING_QUALITY=20 \
MINIMUM_BASE_QUALITY=20
