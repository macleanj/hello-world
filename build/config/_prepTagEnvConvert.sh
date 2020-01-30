#!/usr/bin/env bash
# Script to convert configuration files to environment variable syntax

now=$(date +%Y-%m-%d\ %H:%M:%S)
programName=$(basename $0)
programDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
baseName=$(echo ${programName} | sed -e 's/.sh//g')
envDir="env.files"
tagFile=${envDir}/tag_env.conf
debug=0

source $programDir/generic.conf
CICD_TAGS_NAME=$1

buildTagStartingWith=$CICD_TAGS_BUILD_TAG
deployTagStartingWith=$CICD_TAGS_DEPLOY_TAG

declare -A mapTag2Branch
for mapping in $CICD_TAGS_TAG_MAPPING; do
  key=$(echo $mapping | awk -F "=" '{print $1}')
  value=$(echo $mapping | awk -F "=" '{print $2}')
  mapTag2Branch[$key]=$value
done


# declare -A mapTag2Environment
# # CICD_TAGS_DEPLOY_ENV_LIST="dev=sandbox test=f-prod stag=int prod=prod"
# for mapping in $CICD_TAGS_DEPLOY_ENV_LIST; do
#   key=$(echo $mapping | awk -F "=" '{print $1}')
#   value=$(echo $mapping | awk -F "=" '{print $2}')
#   mapTag2Environment[$key]=$value
# done

# Verify typeKey tag character
if [[ "$CICD_TAGS_NAME" == "" ]] && [[ "$CICD_TAGS_NAME" == "None" ]]; then
  # Not a tag
  buildEnabled=0
else
  # This is a tag
  buildEnabled=1
  currentTag=$CICD_TAGS_NAME
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
  [ $debug -eq 1 ] && echo -e "1: Enabled: $buildEnabled\n"

  # branchKey character
  tmpKey=" $branchKey "
  [[ ! " ${!mapTag2Branch[@]} " =~ \s*$tmpKey\s* ]] && buildEnabled=0
  [ $debug -eq 1 ] && echo -e "2: Enabled: $buildEnabled"

  # Trailing characters
  if [[ $buildEnabled == 1 ]]; then
    if [[ "$typeKey" == "${buildTagStartingWith}" ]]; then
      # Build tag received
      CICD_TAGS_BUILD_VERSION=${trackingNumber}

      # Build tag format
      [[ ! $currentTag =~ ^[a-z]+-[0-9.]+$ ]] && buildEnabled=0
      [ $debug -eq 1 ] && echo -e "3: Enabled: $buildEnabled"
    elif [[ "$typeKey" == "${deployTagStartingWith}" ]]; then
      # Deploy tag received
      CICD_TAGS_DEPLOY_ENVIRONMENT=${envKey}
      CICD_TAGS_DEPLOY_RELEASE=${trackingNumber}

      # Deploy tag format
      [[ ! $currentTag =~ ^[a-z]+-[a-z]+-[0-9.]+$ ]] && buildEnabled=0
      [ $debug -eq 1 ] && echo -e "3: Enabled: $buildEnabled"
      # envKey string
      tmpKey=" $envKey "
      [[ ! " ${CICD_TAGS_DEPLOY_ENV_LIST} " =~ $tmpKey ]] && buildEnabled=0
      [ $debug -eq 1 ] && echo -e "4: Enabled: $buildEnabled"
    fi
    # No else needed. Code is protected earlier
  fi

  # [[ ! $currentTag =~ ^[a-z]${buildTagStartingWith} && ! $currentTag =~ ^${deployTagStartingWith} ]] && buildEnabled=0
  [ $debug -eq 1 ] && echo -e "Enabled: $buildEnabled\n"
fi
[ $debug -eq 1 ] && echo "------------------------------------------------------------------------------------------"
[ $debug -eq 1 ] && echo "CICD_TAGS_BUILD_ENVIRONMENT: NA"
[ $debug -eq 1 ] && echo "CICD_TAGS_BUILD_VERSION: $CICD_TAGS_BUILD_VERSION"
[ $debug -eq 1 ] && echo "------------------------------------------------------------------------------------------"
[ $debug -eq 1 ] && echo "CICD_TAGS_DEPLOY_ENVIRONMENT: $CICD_TAGS_DEPLOY_ENVIRONMENT"
[ $debug -eq 1 ] && echo "CICD_TAGS_DEPLOY_RELEASE: $CICD_TAGS_DEPLOY_RELEASE"
[ $debug -eq 1 ] && echo "------------------------------------------------------------------------------------------"
[ $debug -eq 1 ] && echo "Build enabled: $buildEnabled"

echo "CICD_BUILD_ENABLED=\"$buildEnabled\"" > ${tagFile}
if [[ $buildEnabled == 1 ]]; then
  if [[ "$typeKey" == "${buildTagStartingWith}" ]]; then
    # Build tag received
cat >> ${tagFile} <<EOL
CICD_TAGS_TYPE="Build"
CICD_TAGS_DEPLOY_ENVIRONMENT="None"
CICD_TAGS_ID="$CICD_TAGS_BUILD_VERSION"
EOL
  elif [[ "$typeKey" == "${deployTagStartingWith}" ]]; then
    # Deploy tag received
cat >> ${tagFile} <<EOL
CICD_TAGS_TYPE="Deployment"
CICD_TAGS_DEPLOY_ENVIRONMENT="$CICD_TAGS_DEPLOY_ENVIRONMENT"
CICD_TAGS_ID="$CICD_TAGS_DEPLOY_RELEASE"
EOL
  else
cat >> ${tagFile} <<EOL
CICD_TAGS_TYPE="Other"
CICD_TAGS_DEPLOY_ENVIRONMENT="None"
CICD_TAGS_ID="None"
EOL
  fi

fi