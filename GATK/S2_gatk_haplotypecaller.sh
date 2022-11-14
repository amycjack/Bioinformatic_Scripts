#!/bin/bash
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -J haplotypecaller
#SBATCH -t 60:00:00
#SBATCH -p all
#SBATCH -o /beegfs/scratch/scratchFS/users_area/aja10kg/genomes/Digitaria_iburua/aligment_files/gatk_haplotypecaller.log
#SBATCH --array=1-19
#SBATCH --mem-per-cpu=32G

# GATK variant job array each chromosome
# load modules
module load gatk samtools

# Load reference genome and aligment BAM file
ref=/beegfs/scratch/scratchFS/users_area/aja10kg/genomes/Digitaria_exilis/04092019_Digitaria_Exilis_v1.1_pseudomolecules.fasta
bam=Diburua.sorted.rmdup.bam

# List chromosomes
chrm_list=("Dexi_CM05836_01A" "Dexi_CM05836_02A" "Dexi_CM05836_03A" "Dexi_CM05836_04A" "Dexi_CM05836_05A" "Dexi_CM05836_06A" "Dexi_CM05836_07A" "Dexi_CM05836_08A" "Dexi_CM05836_09A" "Dexi_CM05836_01B" "Dexi_CM05836_02B" "Dexi_CM05836_03B" "Dexi_CM05836_04B" "Dexi_CM05836_05B" "Dexi_CM05836_06B" "Dexi_CM05836_07B" "Dexi_CM05836_08B" "Dexi_CM05836_09B" "Dexi_CM05836_UA")
chrm=${chrm_list[$SLURM_ARRAY_TASK_ID-1]}

# Set parameters for HaplotypeCaller
outmode="EMIT_ALL_CONFIDENT_SITES"
emit_thresh=20	#Threshold for tagging possible variants
call_thresh=30	#Threshold for tagging _good_ variants
hetrate=0.03	#Popgen heterozygosity rate (that is, for any two random chrom in pop, what is rate of mismatch).               Human is ~0.01, so up maize to ~0.03
minBaseScore=20	#Minimum Phred base score to count a base (20 = 0.01 error, 30=0.001 error, etc)

$GATK --java-options "-Xmx32g -XX:ParallelGCThreads=16" HaplotypeCaller \
-R $ref \
-I RG.$bam \
--emitRefConfidence GVCF \
--variant_index_type LINEAR \
--variant_index_parameter 128000 \
-hets $hetrate \
-mbq $minBaseScore \
-stand_emit_conf $emit_thesh \
-stand_call_conf $call_thresh \
-out_mode $outmode \
-O $chrm.raw.indels.snps.g.vcf \
-L $chrm
