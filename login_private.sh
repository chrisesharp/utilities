#!/bin/bash

##
# This script will setup the CLI to use IBM Cloud Private without a time limit.
##
if [ -e "~/icp-creds.sh" ];
then
  echo "Sourcing credentials from ~/icp-creds.sh"
  source ~/icp-creds.sh
else if [ -e "icp-creds.sh" ];
  then
    echo "Sourcing credentials from icp-creds.sh"
    source icp-creds.sh
  fi
fi

if [ -z $icp_secure_port ]
then
  echo "Using default icp_secure_port"
  icp_secure_port=8443
fi
if [ -z $icp_port ]
then
  echo "Using default icp_port"
  icp_port=8001
fi
if [ -z $username ]
then
  echo "Using default username and password"
  username=admin
  password=admin
fi
if [ -z $icp_ip ]
then
  echo "Using default icp_ip"
  icp_ip=192.168.27.100
fi
if [ -z $CLUSTER_CA_DOMAIN ]
then
  echo "Using default CLUSTER_CA_DOMAIN"
  CLUSTER_CA_DOMAIN=mycluster.icp
fi

token=$(curl -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" -d "grant_type=password&client_id=rp&username=$username&password=$password&scope=openid" https://$icp_ip:$icp_secure_port/idprovider/v1/auth/identitytoken --insecure | jq -r '.id_token')

if [ ! $token ]
then
  echo "Failed to retreive token from ICP idprovider. Exiting CLI setup"
  exit
fi

# Configure kubectl with the token
kubectl config set-cluster ${CLUSTER_CA_DOMAIN} --server=https://$icp_ip:$icp_port --insecure-skip-tls-verify=true
kubectl config set-context ${CLUSTER_CA_DOMAIN}-context --cluster=${CLUSTER_CA_DOMAIN}
kubectl config set-credentials ${CLUSTER_CA_DOMAIN}-user --token=$token
kubectl config set-context ${CLUSTER_CA_DOMAIN}-context --user=${CLUSTER_CA_DOMAIN}-user --namespace=default
kubectl config use-context ${CLUSTER_CA_DOMAIN}-context

# Get the service account token
token=$(kubectl get secret --namespace=default -o json | jq -r '.items[] | select(.type == "kubernetes.io/service-account-token") | .data.token')
token=$(echo $token | base64 -d )
# Configure kubectl with the new, permanent token
kubectl config set-credentials ${CLUSTER_CA_DOMAIN}-user --token=$token

#Setup Helm
helm init --client-only
