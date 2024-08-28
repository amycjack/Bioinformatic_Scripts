# quick hack to rename fasta with fileheader

for f in *.fas; do 
awk '/>/{sub(">","&"FILENAME"_");sub(/\.fas/,x)}1' $f
done
