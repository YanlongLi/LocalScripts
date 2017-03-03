#!/usr/bin/env bash

if [ $# -lt 2 ]; then
  echo "Usage $0 resut_file output_dir"
  exit 1
fi

file=$1
outdir=$2

if [ ! -d $outdir ]; then
  mkdir $outdir
fi

froms=$(awk -F'\t' '{print $4}' $file | sort | uniq)

for from in ${froms[@]}; do
  tos=$(awk -F'\t' -v from="$from" 'match($4,from){print $5}' $file | sort | uniq)
  for to in ${tos[@]}; do
    outfile=${outdir}/${from}_${to}.tsv
    awk -F'\t' -v from="$from" -v to="$to" 'BEGIN{OFS="\t"} match($4,from) && match($5,to){print $1,$2,$3,$4,$5}' $file > $outfile
    wc -l $outfile | sed -e 's/[ _]/\t/g' -e 's/\.tsv//g' -e 's/\t.*\//\t/'
  done
done
