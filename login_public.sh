#!/bin/bash

source bx-creds.sh

bx login -a $API_ENDPOINT -u $BX_USERNAME -p $BX_PASSWORD -c $BX_ACCOUNT
bx cr login
bx cs init
eval `bx cs cluster-config $BX_CLUSTER --export`

#Setup Helm
helm init --client-only
