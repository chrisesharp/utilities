#!/bin/bash

pushd $( dirname "${BASH_SOURCE[0]}" )

curl -L https://git.io/getIstio | sh -

cd istio*

kubectl apply -f install/kubernetes/istio.yaml

sleep 3

kubectl apply -f install/kubernetes/istio-initializer.yaml

echo "You can remove the istio folder if you already have istioctl configured."
popd