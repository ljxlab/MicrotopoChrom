#!/bin/bash

samples="mA_A mA_R mA_C"
for sample in `cat $samples`;
do
{
echo $sample 
macs2 callpeak -f BAMPE -g mm --keep-dup all -t ./bw2Aln/${sample}_bw2SrtRmdupMTq30_posAdj_openChr.bam -n ${sample}_openChr --outdir ./macs2_openChr/
cat ./macs2_openChr/${sample}_openChr_peaks.xls > ./macs2_openChr/${sample}_openChr_peaks.txt
}
done
