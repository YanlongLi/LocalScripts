#!/usr/bin/bash

if [ $# -lt 7 ]; then
  echo "Usage $0 tofile modeldir variant clientid output testfile domain"
  echo "Usage $0 tofile modeldir variant locale version output testfile domain"
  exit 0
fi

source ~/.local/bin/LU_SCRIPTS/LU_generate_config.sh

# LU_BASE='\\YANLL-WORK'
# LU_MAPPEDBASE='/d/Data'

tofile=$1
modeldir=`LU_UnixPath2NetPath $(realpath $2)`
variant=$3
if [ $# -eq 7 ]; then
  clientid=$4
  output=$5
  testfile=`LU_UnixPath2NetPath $(realpath $6)`
  domain=$7
elif [ $# -eq 8 ]; then
  clientid=Microsoft_Threshold_Shell_1_$4_$5
  output=$6
  testfile=`LU_UnixPath2NetPath $(realpath $7)`
  domain=$8
fi


if [[ $domain =~ .*,.* ]]; then
cat > $tofile<<EOL
$LU_QCSQUERYLABEL_PATH\\QCSQueryLabelWithLES.exe -c $modeldir --variant $variant --clientId $clientid -o $output -i $testfile -dl $domain --verbose --queryViews NormalizedQuery --dumpFormat json
pause
EOL
else
cat > $tofile<<EOL
$LU_QCSQUERYLABEL_PATH\\QCSQueryLabelWithLES.exe -c $modeldir --variant $variant --clientId $clientid -o $output -i $testfile -d $domain --verbose --queryViews NormalizedQuery --dumpFormat json
pause
EOL
fi
unix2dos $tofile > /dev/null 2>&1

exit 0
