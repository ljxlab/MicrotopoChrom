#!/bin/bash
dataPath='/mnt/volume3/ljx/alnRan/alnRan_hic/1_h5'
outPath='/mnt/volume3/ljx/alnRan/alnRan_hic/2_ABcompartment'
sampleName='mA mA_A mA_R'

for sample in $sampleName;
do
	{
		hicPCA -m ${dataPath}/${sample}_100kb_norSmallest_KRcorrected.h5 --whichEigenvectors 1 2 -o ${outPath}/${sample}_100kb_norSmallest_KRcorrected_pca1.bw ${outPath}/${sample}_100kb_norSmallest_KRcorrected_pca2.bw --format bigwig
		hicTransform -m ${dataPath}/${sample}_100kb_norSmallest_KRcorrected.h5 -o ${outPath}/${sample}_100kb_norSmallest_KRcorrected_pearson.h5 --method pearson

	}
done
