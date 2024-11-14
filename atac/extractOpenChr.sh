#!/bin/bash

samples="mA_A mA_R mA_C"
for sample in `cat $samples`;
do
{
echo $sample 
samtools view -h ./bw2Aln/${sample}_bw2SrtRmdupMTq30_posAdj.bam |  awk 'substr($0,1,1)=="@" || ($9< 100 && $9> -100)' | samtools view -b > ./bw2Aln/${sample}_bw2SrtRmdupMTq30_posAdj_openChr.bam
samtools index -@ 8 ./bw2Aln/${sample}_bw2SrtRmdupMTq30_posAdj_openChr.bam
bamCoverage -p 48 -b ./bw2Aln/${sample}_bw2SrtRmdupMTq30_posAdj_openChr.bam --normalizeUsing RPKM -bs 10 -o ./bw2Aln/${sample}_bw2SrtRmdupMTq30_posAdj_openChr.bw
}
done