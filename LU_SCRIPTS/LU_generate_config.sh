#!/usr/bin/bash

# export LU_MODEL_QUALIFIER_PATH="\\\\suzhost-23\\users\\jiangazh\\LUTools\\CarinaModelQualifier"
export LU_MODEL_QUALIFIER_PATH='\\jianlij-work\Tools\ModelQualifier'
export LU_TOOL_PATH="\\\\suzhost-23\\users\\jiangazh\\LUTools\\CarinaModelQualifier"

export LU_MLGTOOL_PATH="$LU_TOOL_PATH\\Tools\\MlgTools"
export LU_QCSQUERYLABEL_PATH="$LU_TOOL_PATH\\Tools\\QCSQueryLabel"
export LU_SMEVAL_PATH="$LU_TOOL_PATH\\Tools\\smeval"

# export LU_BASE='\\SUZHOST-23\Threshold'
# export LU_MAPPEDBASE='/Threshold'
export LU_BASE='\\YANLL-WORK'
export LU_MAPPEDBASE='/d/Data'

LU_UnixPath2NetPath() {
  local path=$(realpath -m $1)
  echo "$path" | sed -e "s/$(echo $LU_MAPPEDBASE | sed -e 's_\/_\\\/_g')/$(echo $LU_BASE | sed -e 's/\\/\\\\/g')/" -e 's/\//\\/g'
}

LU_NetPath2UnixPath(){
  local path=$1
  echo "$path" | sed -e "s/$(echo $LU_BASE | sed -e 's/\\/\\\\/g')/$(echo $LU_MAPPEDBASE | sed -e 's_\/_\\\/_g')/" -e 's/\\/\//g'
}


GenerateQualifyXML() {
  #function_body
  local tofile=$1
  local outdir=$2
  local locale=$3
  local testfile=$4
  local modeldir=$5
  local clientid=$6
  local variant=${7-"Temp"}
  #
cat > $tofile <<EOL
<?xml version="1.0" encoding="utf-8"?>
<QualifierConfig>
  <Product>Threshold</Product>
  <LocalDirectory>$outdir</LocalDirectory>
  <Locale>${locale:0:2}-${locale:(-2)}</Locale>
  <Data>
    <File path="$testfile" type="test" />
  </Data>
  <Model>
    <DecoderType>Cortana</DecoderType>
    <ModelDir>$modeldir</ModelDir>
    <ClientId>$clientid</ClientId>
    <Variant>$variant</Variant>
  </Model>
  <Tool>
    <ExperimentType>OfflineTool</ExperimentType>
    <FindFileAEther>ef313c2d-e448-4e16-b2eb-7700e3f53959</FindFileAEther>
    <QCSQueryLabelAEther>f298e0f8-d2d0-4d0c-88ec-69bf26ec792e</QCSQueryLabelAEther>
    <QCSEvaluatorAEther>7b2b651a-55ab-471a-89e2-57b77096f844</QCSEvaluatorAEther>
    <QCSQueryLabel>$LU_QCSQUERYLABEL_PATH</QCSQueryLabel>
    <QCSEvaluator>$LU_SMEVAL_PATH</QCSEvaluator>
  </Tool>
</QualifierConfig>
EOL
}

GenerateQualifyBat() {
  tofile=$1
  config=$2
  #
cat > $tofile <<EOL
$LU_MODEL_QUALIFIER_PATH\\LUModelQualifier.exe -c $config
PAUSE
EOL
  #
  unix2dos $tofile
}

GenerateHotfixXML() {
  local tofile=$1
  local outdir=$2
  local locale=$3
  local testfile=$4
  local modeldir=$5
  local clientid=$6
  #
cat > $tofile <<EOL
<?xml version="1.0" encoding="utf-8"?>
<ModelHotfixConfig>
  <Product>Threshold</Product>
  <Locale>${locale:0:2}-${locale:(-2)}</Locale>
  <Variant>Temp</Variant>
  <ClientId>$clientid</ClientId>
  <ModelDir>$modeldir</ModelDir>
  <AnalysisOutDir>\\\\YANLL-WORK\\Shared\\tmp\\hotfix\\</AnalysisOutDir>
  <OutputDir>$outdir\\out</OutputDir>
  <TestPath>$testfile</TestPath>
  <MLGToolDir>$LU_MLGTOOL_PATH</MLGToolDir>
</ModelHotfixConfig>
EOL
}

GenerateHotfixBat() {
  tofile=$1
  config=$2
  #
cat > $tofile <<EOL
$LU_MODEL_QUALIFIER_PATH\\bin\\LUModelHotfix.exe -c $config
PAUSE
EOL
  #
  unix2dos $tofile
}

# base='\\YANLL-WORK\Threshold'
# locale="frca"
# modeldir=model_MV3
# ClientId=ClientID
# 
# GenerateQualifyXML /d/Shared/tmp/qualify.xml \
#   $base\\$locale\\hotfix \
#   $locale \
#   $base\\$locale\\hotfix\\buglist.tsv \
#   $base\\$locale\\$modeldir \
#   ClientID 
# 
# GenerateQualifyBat /d/Shared/tmp/qualify.bat \\\\YANLL-WORK\\Shared\\tmp\\qualify.xml
# 
# GenerateHotfixXML /d/Shared/tmp/hotfix.xml \
#   $base\\$locale\\hotfix\\afterhotfix \
#   $locale \
#   $base\\$locale\\hotfix\\buglist.tsv \
#   $base\\$locale\\$modeldir \
#   ClientID 
# 
# GenerateHotfixBat /d/Shared/tmp/hotfix.bat \\\\YANLL-WORK\\Shared\\tmp\\hotfix.xml
