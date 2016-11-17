#!/usr/bin/bash

source ~/.local/bin/LU_SCRIPTS/LU_generate_config.sh

LU_BASE='\\YANLL-WORK\Threshold'
LU_MAPPEDBASE='/d/Data/Threshold'


__ScriptVersion="version"

function usage ()
{
  echo "Usage :  $0 [options] [--]

    Options:
    -h|help       Display this message
    -l|locale
    -c|clientid   default ClientID
    -m|model      model directory name
    -v|version    Display script version"

}

locale="frca"
modeldir=model_MV3
ClientId=ClientID

while getopts ":h:l:c:m:v" opt
do
  case $opt in

  h|help     )  usage; exit 0   ;;

  l|locale ) locale=${OPTARG-"frca"} ;;

  c|clientid ) ClientId=${OPTARG-ClientID} ;;

  m|model ) modeldir=${OPTARG-"model_MV3"} ;;

  v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

  * )  echo -e "\n  Option does not exist : $OPTARG\n"
      usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

GenerateQualifyXML $LU_MAPPEDBASE/$locale/hotfix/qualify.xml \
  $LU_BASE\\$locale\\hotfix \
  $locale \
  $LU_BASE\\$locale\\hotfix\\buglist.qas.tsv \
  $LU_BASE\\$locale\\$modeldir \
  ClientID 

GenerateQualifyBat $LU_MAPPEDBASE/$locale/hotfix/qualify.bat $LU_BASE\\$locale\\hotfix\\qualify.xml

GenerateHotfixXML $LU_MAPPEDBASE/$locale/hotfix/hotfix.xml \
  $LU_BASE\\$locale\\hotfix\\afterhotfix \
  $locale \
  $LU_BASE\\$locale\\hotfix\\buglist.qas.tsv \
  $LU_BASE\\$locale\\$modeldir \
  ClientID 

GenerateHotfixBat $LU_MAPPEDBASE/$locale/hotfix/hotfix.bat $LU_BASE\\$locale\\hotfix\\hotfix.xml
