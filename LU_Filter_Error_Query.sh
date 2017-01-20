#!/usr/bin/bash

if [ $# -lt 3 ]; then
  echo "$0 file from to"
  exit 1
fi

file=$1
from=$2
to=$3

awk -F'\t' -v from="$from" -v to="$to" 'BEGIN{OFS="\t"} match($4,from) && match($5,to){print $3}' $file
