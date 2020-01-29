#!/bin/bash
# Script to convert configuration files to environment variable syntax

now=$(date +%Y-%m-%d\ %H:%M:%S)
programName=$(basename $0)
programDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
baseName=$(echo ${programName} | sed -e 's/.sh//g')
debug=0
gitBranchNameDev=$(grep GIT_BRANCH_NAME_DEVELOP generic.conf | sed -e 's/.*=//g' | sed -e 's/[#].*//g' | sed -e 's/"//g' | awk '{$1=$1};1')

cd $programDir
rm -rf env.files
mkdir -p env.files
for file in $(ls *.conf); do
  [ $debug -eq 1 ] && echo "Processing $file"

  # Get basename of the file
  baseNameFile=$(echo ${file} | sed -e 's/.conf//g')
  
  # Prepare file(s) for environment variable format
  [[ $baseNameFile =~ _$ ]] && baseNameFile="${baseNameFile}${gitBranchNameDev}"
  echo -n > env.files/${baseNameFile}.env

  # Prepare file(s) for groovy format
  echo -n > env.files/${baseNameFile}.groovy

  # Convert
  OLDIFS=$IFS
  IFS=$'\n'
  for env in $(cat $file | egrep -v "^#|^[[:space:]]"); do
    [ $debug -eq 1 ] && echo $env
    key=$(echo $env | sed -e 's/=.*//g' | awk '{$1=$1};1')
    value=$(echo $env | sed -e 's/.*=//g' | sed -e 's/[#].*//g' | awk '{$1=$1};1')
    [[ ! $value =~ ^\" ]] && value="\"$value\""

    # Environment variable format
    echo "$key=$value" >> env.files/${baseNameFile}.env

    # Environment groovy format
    echo "env.$key=$value" >> env.files/${baseNameFile}.groovy

  done
  IFS=$OLDIFS
done
