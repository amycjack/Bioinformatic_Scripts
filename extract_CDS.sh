#!/bin/bash
#SBATCH -p all
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -J Dexilis_extract
#SBATCH -t 01:00:00


module load anaconda
conda activate gffread

ref=/beegfs/scratch/scratchFS/users_area/aja10kg/genomes/Digitaria_exilis/Digitaria_exilis.Fonio_CM05836.dna.toplevel.fa
gff=Dexilis.gtf


gffread -y $file.chrmA.CDS -g $file $gff | \
bioawk -c fastx '{ print $name, $seq }' | \
while read line; \
do \
name=$(echo $line | cut -f 1); \
echo $line | cut -f 2 | \
awk -F "" '{ for (i = 3; i <= NF; i += 3) \
printf "%s%s", $i, (i+3>NF?"\n":FS) }' | \
awk -v name="$name" '{ print ">"name; print $1 }'; \
done \
> <out.fasta>
