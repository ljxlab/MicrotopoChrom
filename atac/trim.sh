#!/bin/bash

filename=$(ls ./fastq/*_R1.fastq.gz)
for f in $filename
do
f1=${f:10}
filehead=${f1%%_R1.fastq.gz}
echo $filehead
cutadapt -j 12 -u -100 -U -100 -o ./fastq_trim/${filehead}_R1_trim.fastq.gz -p ./fastq_trim/${filehead}_R2_trim.fastq.gz ./fastq/${filehead}_R1.fastq.gz ./fastq/${filehead}_R2.fastq.gz
done
