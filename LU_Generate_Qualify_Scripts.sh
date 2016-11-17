#!/usr/bin/bash

if [ $# -lt 5 ]; then
  echo "Usage $0 tofile locale modeldir clientid testfile"
  exit 0
fi

source ~/.local/bin/LU_SCRIPTS/LU_generate_config.sh

# LU_BASE='\\YANLL-WORK'
# LU_MAPPEDBASE='/d/Data'

tofile=`realpath $1`
locale=$2
modeldir=`LU_UnixPath2NetPath $(realpath $3)`
clientid=$4
testfile=`LU_UnixPath2NetPath $(realpath $5)`

outdir=`LU_UnixPath2NetPath $(dirname $tofile)`

echo "tofile: $tofile"
echo "locale: $locale"
echo "outdir: $outdir"
echo "testfile: $testfile"
echo "modeldir: $modeldir"
echo "clientid: $clientid"

GenerateQualifyXML $tofile.xml $outdir $locale $testfile $modeldir $clientid
GenerateQualifyBat $tofile.bat `LU_UnixPath2NetPath $tofile.xml`

exit 0
