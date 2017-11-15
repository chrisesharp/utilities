#!/bin/bash
# Use bx-creds.sh from home directory as a first option for source
if [ -e "~/bx-creds.sh" ];
then
  echo "Sourcing credentials from ~/bx-creds.sh"
  source ~/bx-creds.sh
else if [ -e "bx-creds.sh" ];
  then
    echo "Sourcing credentials from bx-creds.sh"
    source bx-creds.sh
  fi
fi

if [ -z $BX_USERNAME ];
then
  echo ">> BX_USERNAME env variable must be set in order to continue."
  exit 1
fi

if [ -z $BX_PASSWORD ];
then
  echo ">> BX_PASSWORD env variable must be set in order to continue."
  exit 1
fi

if [ -z $BX_ACCOUNT ];
then
  echo ">> BX_ACCOUNT env variable must be set in order to continue."
  exit 1
fi

if [ -z $BX_CLUSTER ];
then
  echo ">> BX_CLUSTER env variable must be set in order to continue."
  exit 1
fi

if [ -z $API_ENDPOINT ]
then
  echo "Using default IBM Cloud API_ENDPOINT"
  API_ENDPOINT=https://api.eu-gb.bluemix.net
fi


bx login -a $API_ENDPOINT -u $BX_USERNAME -p $BX_PASSWORD -c $BX_ACCOUNT
bx cr login
bx cs init
eval `bx cs cluster-config $BX_CLUSTER --export`

#Setup Helm
helm init --upgrade
