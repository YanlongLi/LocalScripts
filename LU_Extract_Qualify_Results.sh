#!/usr/bin/bash

if [ $# -lt 2 ]; then
  echo "Usage $0 resultdir toFile"
  exit 0
fi

if [ ! -d $1 ]; then
  echo "Directory $1 not exist"
  exit 1
fi

source ~/.local/bin/LU_SCRIPTS/LU_generate_config.sh

function ExtractQualifyResults() {
  local resultdir=$1

  files=($resultdir/evaluation_summary/*.domain.summary)
  file="${files[0]}"

  echo "domain score"
  if [ -f "$file" ]; then
    sed -n -e '/^Classification error.*/,/^Accuracy:.*/ p' "$file" | sed -e "s/Classification.*:/domain/" | sed -e 's/[:,]\s*/\t/g'
    echo ""
    sed -n -e '/^Confusion matrix/,/^Highly confused class/ p' "$file" |  sed -n -e '2,$ p' | head --lines=-2
  fi


  cur=`pwd`

  cd $resultdir/evaluation_summary/

  echo "intent score"
  for f in `ls *.intents.summary`; do
    score=`tail -1 $f`
    echo "$f $score" | sed 's/.*\.\([^\.]\+\)\.intents.summary/\1/' | sed 's/Accuracy://g'
  done

  echo

  echo "slot score"
  for f in `ls *.slot.summary`; do
    score=`sed -n '/^\s\+ slot/ s/^.*precision=\(.*\)recall=\(.*\)F1=\(.*\)(.*Query=\(.*\) out of total\([^,]*\).*$/\1 \2 \3 \4 \5/p' $f`
    echo "$f $score" | sed 's/.*\.\([^\.]\+\)\.slot.summary/\1/'
  done

  cd "$cur"
}

LU_Qualify_Score2Excel.pl <(ExtractQualifyResults $1 | sed -e 's/,\?\s\+/\t/g') $2
# ExtractQualifyResults $1 | sed -e 's/,\?\s\+/\t/g'
