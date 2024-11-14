#!/bin/bash
dataPath='/mnt/volume1/ljx/alnRan/hic/1_cool_norSmall_KR'
outPath='/mnt/volume1/ljx/alnRan/hic/3_TADs_hicexplorer'
sampleName='mA mA_A mA_R'

# Find TADs
for sample in $sampleName
do
{

hicFindTADs -m $dataPath/${sample}_40kb_norSmallest_KRcorrected.cool --outPrefix $outPath/${sample}_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr --thresholdComparisons 0.01 --delta 0.01 --correctForMultipleTesting fdr -p 24

}
done

# Keep boundaries with insulation score < 0.3
awk 'BEGIN {OFS="\t"} $5 < -0.3' mA_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_boundaries.bed > mA_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_boundaries_minus0.3.bed
awk 'BEGIN {OFS="\t"} $5 < -0.3' mA_A_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_boundaries.bed > mA_A_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_boundaries_minus0.3.bed
awk 'BEGIN {OFS="\t"} $5 < -0.3' mA_R_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_boundaries.bed > mA_R_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_boundaries_minus0.3.bed

./getDomain.sh mA_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_boundaries_minus0.3.bed mA_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.bed
./getDomain.sh mA_A_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_boundaries_minus0.3.bed mA_A_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.bed
./getDomain.sh mA_R_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_boundaries_minus0.3.bed mA_R_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.bed

# Aggregate plot of TAD signal
fanc aggregate /mnt/volume1/ljx/alnRan/hic/1_cool_norSmall_KR/mA_40kb_norSmallest_KRcorrected.cool \
./mA_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.bed \
./mA_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.agg \
-p ./mA_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.agg.pdf \
-m ./mA_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.agg.txt \
--tads \
--tad-strength ./mA_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3_strength.bed

fanc aggregate /mnt/volume1/ljx/alnRan/hic/1_cool_norSmall_KR/mA_A_40kb_norSmallest_KRcorrected.cool \
./mA_A_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.bed \
./mA_A_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.agg \
-p ./mA_A_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.agg.pdf \
-m ./mA_A_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.agg.txt \
--tads \
--tad-strength ./mA_A_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3_strength.bed

fanc aggregate /mnt/volume1/ljx/alnRan/hic/1_cool_norSmall_KR/mA_R_40kb_norSmallest_KRcorrected.cool \
./mA_R_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.bed \
./mA_R_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.agg \
-p ./mA_R_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.agg.pdf \
-m ./mA_R_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.agg.txt \
--tads \
--tad-strength ./mA_R_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3_strength.bed


# Calculate Intra-TAD connectivity
hicInterIntraTAD --matrix /mnt/volume1/ljx/alnRan/hic/1_cool_norSmall_KR/mA_40kb_norSmallest_KRcorrected.cool --tadDomains mA_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.bed --outFileName mA_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3_interintra.tzt --outFileNameRatioPlot mA_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3_interintra.pdf --threads 24 
hicInterIntraTAD --matrix /mnt/volume1/ljx/alnRan/hic/1_cool_norSmall_KR/mA_A_40kb_norSmallest_KRcorrected.cool --tadDomains mA_A_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.bed --outFileName mA_A_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3_interintra.tzt --outFileNameRatioPlot mA_A_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3_interintra.pdf --threads 24 
hicInterIntraTAD --matrix /mnt/volume1/ljx/alnRan/hic/1_cool_norSmall_KR/mA_R_40kb_norSmallest_KRcorrected.cool --tadDomains mA_R_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3.bed --outFileName mA_R_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3_interintra.tzt --outFileNameRatioPlot mA_R_40kb_norSmallest_KRcorrected_thres0.01_delta0.01_fdr_domains_minus0.3_interintra.pdf --threads 24 

