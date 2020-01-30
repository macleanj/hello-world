#!/usr/bin/env bash
# Script to convert configuration files to environment variable syntax

now=$(date +%Y-%m-%d\ %H:%M:%S)
programName=$(basename $0)
programDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
baseName=$(echo ${programName} | sed -e 's/.sh//g')
envDir="env.files"
tagFile=${envDir}/tag_env.conf
debug=1

source $programDir/generic.conf

buildTagStartingWith=$CICD_TAGS_BUILD_TAG
deployTagStartingWith=$CICD_TAGS_DEPLOY_TAG

declare -A mapTag2Branch
for mapping in $CICD_TAGS_BRANCH_MAPPING; do
  key=$(echo $mapping | awk -F "=" '{print $1}')
  value=$(echo $mapping | awk -F "=" '{print $2}')
  mapTag2Branch[$key]=$value
done


declare -A mapTag2Environment
# CICD_TAGS_DEPLOY_ENV_MAPPING="dev=sandbox test=f-prod stag=int prod=prod"
for mapping in $CICD_TAGS_DEPLOY_ENV_MAPPING; do
  key=$(echo $mapping | awk -F "=" '{print $1}')
  value=$(echo $mapping | awk -F "=" '{print $2}')
  mapTag2Environment[$key]=$value
done

# Verify typeKey tag character
buildEnabled=1
for currentTag in $(git tag --contains); do
  # Character extraction by expected format
  # - Build: $buildTagStartingWith<branchCharacter>-<version>. Example: vm-1.01
  # - Deploy: $deployTagStartingWith<branchCharacter>-<deployEnvironment>-<version>. Example: ds-1.01
  typeKey="${currentTag:0:1}"
  branchKey="${currentTag:1:1}"
  if [[ "$typeKey" == "${buildTagStartingWith}" ]]; then
    envKey="NA"
    trackingNumber=$(echo $currentTag | awk -F "-" '{print $2}')
  elif [[ "$typeKey" == "${deployTagStartingWith}" ]]; then
    envKey=$(echo $currentTag | awk -F "-" '{print $2}')
    trackingNumber=$(echo $currentTag | awk -F "-" '{print $3}')
  fi
  [ $debug -eq 1 ] && echo "Receiving tag: $currentTag"
  [ $debug -eq 1 ] && echo "typeKey: $typeKey"
  [ $debug -eq 1 ] && echo "branchKey: $branchKey"
  [ $debug -eq 1 ] && echo "envKey: $envKey"
  [ $debug -eq 1 ] && echo "trackingNumber: $trackingNumber"

  # typeKey character
  [[ "$typeKey" != "${buildTagStartingWith}" && "$typeKey" != "${deployTagStartingWith}" ]] && buildEnabled=0

  # branchKey character
  tmpKey=" $branchKey "
  [[ ! " ${!mapTag2Branch[@]} " =~ \s*$tmpKey\s* ]] && buildEnabled=0

  # Trailing characters
  if [[ $buildEnabled == 1 ]]; then
    if [[ "$typeKey" == "${buildTagStartingWith}" ]]; then
      # Build tag received
      CICD_TAG_BUILD_BRANCH=${mapTag2Branch[$branchKey]}
      CICD_TAG_BUILD_VERSION=${trackingNumber}

      # Build tag format
      [[ ! $currentTag =~ [a-z]+-[0-9.]+ ]] && buildEnabled=0
    elif [[ "$typeKey" == "${deployTagStartingWith}" ]]; then
      # Deploy tag received
      CICD_TAG_DEPLOY_BRANCH=${mapTag2Branch[$branchKey]}
      CICD_TAG_DEPLOY_ENVIRONMENT=${mapTag2Environment[${envKey}]}
      CICD_TAG_DEPLOY_RELEASE=${trackingNumber}

      # Deploy tag format
      [[ ! $currentTag =~ [a-z]+-[a-z]+-[0-9.]+ ]] && buildEnabled=0
      # envKey string
      tmpKey=" $envKey "
      [[ ! " ${!mapTag2Environment[@]} " =~ $tmpKey ]] && buildEnabled=0
    fi
    # No else needed. Code is protected earlier
  fi

  # [[ ! $currentTag =~ ^[a-z]${buildTagStartingWith} && ! $currentTag =~ ^${deployTagStartingWith} ]] && buildEnabled=0
  [ $debug -eq 1 ] && echo -e "Enabled: $buildEnabled\n"
done
[ $debug -eq 1 ] && echo "------------------------------------------------------------------------------------------"
[ $debug -eq 1 ] && echo "CICD_TAG_BUILD_BRANCH: $CICD_TAG_BUILD_BRANCH"
[ $debug -eq 1 ] && echo "CICD_TAG_BUILD_VERSION: $CICD_TAG_BUILD_VERSION"
[ $debug -eq 1 ] && echo "------------------------------------------------------------------------------------------"
[ $debug -eq 1 ] && echo "CICD_TAG_DEPLOY_BRANCH: $CICD_TAG_DEPLOY_BRANCH"
[ $debug -eq 1 ] && echo "CICD_TAG_DEPLOY_ENVIRONMENT: $CICD_TAG_DEPLOY_ENVIRONMENT"
[ $debug -eq 1 ] && echo "CICD_TAG_DEPLOY_RELEASE: $CICD_TAG_DEPLOY_RELEASE"
[ $debug -eq 1 ] && echo "------------------------------------------------------------------------------------------"
[ $debug -eq 1 ] && echo "Build enabled: $buildEnabled"

echo "CICD_BUILD_ENABLED=\"$buildEnabled\"" > ${tagFile}
if [[ $buildEnabled == 1 ]]; then
  if [[ "$typeKey" == "${buildTagStartingWith}" ]]; then
    # Build tag received
cat >> ${tagFile} <<EOL
CICD_TAG_TYPE="Build"
CICD_TAG_BRANCH="$CICD_TAG_BUILD_BRANCH"
CICD_TAG_ID="$CICD_TAG_BUILD_VERSION"
EOL
  elif [[ "$typeKey" == "${deployTagStartingWith}" ]]; then
    # Build tag received
cat >> ${tagFile} <<EOL
CICD_TAG_TYPE="Deployment"
CICD_TAG_BRANCH="$CICD_TAG_DEPLOY_BRANCH"
CICD_TAG_DEPLOY_ENVIRONMENT="$CICD_TAG_DEPLOY_ENVIRONMENT"
CICD_TAG_ID="$CICD_TAG_DEPLOY_RELEASE"
EOL
  fi

fi