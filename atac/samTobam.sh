#!/bin/bash

filename=$(ls ./bw2Aln/*.sam)
for f in $filename
do
	f1=${f:11}
	filehead=${f1%%.sam}
	echo $filehead
	samtools view -@ 24 -bS -o ./bw2Aln/${filehead}.bam ./bw2Aln/${filehead}.sam 
done

samples="mA_A mA_R mA_C"

for sample in `cat $samples`;
do
	{
		samtools merge -@ 24 ./bw2Aln/${sample}_bw2.bam ./bw2Aln/${sample}1_bw2.bam ./bw2Aln/${sample}2_bw2.bam
		samtools sort -@ 24 ./bw2Aln/${sample}_bw2.bam -o ./bw2Aln/${sample}_bw2Srt.bam
	}
done
