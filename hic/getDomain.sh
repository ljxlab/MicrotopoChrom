#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_bed_file> <output_bed_file>"
    exit 1
fi

input_file=$1
output_file=$2

> $output_file

temp_file=$(mktemp)

awk '
BEGIN { OFS="\t" }
{

        if (NR == 1 || $1 != chrom) {
        if (NR != 1) {
                for (i = 1; i < count; i++) {
                new_start = starts[i] + 20000
                new_end = starts[i+1] + 20000
                print chrom, new_start, new_end, ids[i], scores[i], strands[i] >> "'$output_file'"
            }
            }
            chrom = $1
            count = 0
        }
    count++
        starts[count] = $2
    ends[count] = $3
        ids[count] = $4
    scores[count] = $5
        strands[count] = $6
}
END {
        for (i = 1; i < count; i++) {
        new_start = starts[i] + 20000
        new_end = starts[i+1] + 20000
        print chrom, new_start, new_end, ids[i], scores[i], strands[i] >> "'$output_file'"
    }
    }
    ' $input_file

    rm $temp_file

