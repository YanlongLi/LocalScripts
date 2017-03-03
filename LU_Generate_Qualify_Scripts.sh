#!/usr/bin/env bash

if [ $# -lt 5 ]; then
  echo "Usage $0 tofile locale modeldir clientid variant testfile outdir"
  exit 0
fi

source ~/.local/bin/LU_SCRIPTS/LU_generate_config.sh

# LU_BASE='\\YANLL-WORK'
# LU_MAPPEDBASE='/d/Data'

tofile=`realpath $1`
locale=$2
modeldir=`LU_UnixPath2NetPath $(realpath $3)`
clientid=$4
variant=$5
testfile=`LU_UnixPath2NetPath $(realpath $6)`

outdir=`LU_UnixPath2NetPath $(dirname $tofile)/out`
if [ $# -eq 7 ]; then
  outdir=`LU_UnixPath2NetPath $6`
fi

echo "tofile: $tofile"
echo "locale: $locale"
echo "outdir: $outdir"
echo "testfile: $testfile"
echo "modeldir: $modeldir"
echo "clientid: $clientid"
echo "variant: $variant"

GenerateQualifyXML $tofile.xml $outdir $locale $testfile $modeldir $clientid $variant
GenerateQualifyBat $tofile.bat `LU_UnixPath2NetPath $tofile.xml`

exit 0
