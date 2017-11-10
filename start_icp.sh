#!/bin/bash

pushd $( dirname "${BASH_SOURCE[0]}" )
echo "Starting icp..."

echo "Need to configure CLI client first (TODO)"

echo "Configuring docker registry secret..."
kubectl create secret docker-registry admin.registrykey \
  --docker-server mycluster.icp:8500 \
  --docker-username admin \
  --docker-password admin \
  --docker-email admin@admin.com

kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "admin.registrykey"}]}' --namespace default

popd
