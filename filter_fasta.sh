#!/bin/bash
#This script moves all files to a directory if it contains more than 14 fasta headers

#Define directory for files to be moved
DIR="./filtered"

#Loop through all files in the current directory
for file in *.clean;
do
    #Count number of ">" characters
    num_gt=$(grep -o ">" "$file" | wc -l)

    #If more than 14, move file to DIR
    if [ $num_gt -gt 14 ]
    then
        mv "$file" "$DIR"
    fi
done
