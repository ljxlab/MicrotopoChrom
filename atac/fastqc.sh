#!/bin/bash

filename=$1
f=${filename:8}
filehead=${f%%.fastq.gz}
echo $filehead
fastqc ./fastq/$filehead'.fastq.gz' -o ./fastqc/
