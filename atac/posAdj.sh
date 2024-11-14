#!/bin/bash

samples="mA_A mA_R mA"
for sample in `cat $samples`;
do
	{
		echo $sample
		alignmentSieve --numberOfProcessors 24 --ATACshift --bam ./bw2Aln/${sample}_bw2SrtRmdupMTq30.bam -o ./bw2Aln/${sample}_bw2SrtRmdupMTq30.tmp.bam
		samtools sort -@ 24 -O bam -o ./bw2Aln/${sample}_bw2SrtRmdupMTq30_posAdj.bam ./bw2Aln/${sample}_bw2SrtRmdupMTq30.tmp.bam
		samtools index -@ 8 ./bw2Aln/${sample}_bw2SrtRmdupMTq30_posAdj.bam
		rm ./bw2Aln/${sample}_bw2SrtRmdupMTq30.tmp.bam
	}
done
