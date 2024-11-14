#!/bin/bash

samples="mA_A mA_R mA"
for sample in $samples;
do
	{
		echo $sample
		picard MarkDuplicates REMOVE_DUPLICATES=true I=./bw2Aln/${sample}_bw2Srt.bam O=./bw2Aln/${sample}_bw2SrtRmdup.bam M=./log/${sample}_bw2SrtRmdup.log 
		samtools view -@ 24 -h -f 2 -q 30 ./bw2Aln/${sample}_bw2SrtRmdup.bam | grep -v "MT" | samtools sort -@ 24 -o ./bw2Aln/${sample}_bw2SrtRmdupMTq30.bam

	}
done
