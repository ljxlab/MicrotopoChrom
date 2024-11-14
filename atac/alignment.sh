#!/bin/bash

filename=$(ls ./fastq_trim/*_R1_trim.fastq.gz)
for f in $filename
do
	f1=${f:15}
	filehead=${f1%%_R1_trim.fastq.gz}
	echo $filehead
	bowtie2 -p 36 -X 2000 --very-sensitive -x /mnt/volume3/ljx/alnRan/alnRan_atacseq/0_ref/bowtie2_index_mm10/mm10 -1 ./fastq_trim/${filehead}_R1_trim.fastq.gz -2 ./fastq_trim/${filehead}_R2_trim.fastq.gz  -S ./bw2Aln/${filehead}_bw2.sam
done
