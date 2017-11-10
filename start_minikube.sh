#!/bin/bash

pushd $( dirname "${BASH_SOURCE[0]}" )
echo "Starting minikube..."
minikube start --insecure-registry "192.168.99.100:32767"
sleep 3

echo "Starting an insecure docker registry within minikube..."
kubectl create -f kubernetes/minikube-registry.yaml 

echo "You will need to add 192.168.99.100:32767 as an insecure registry to your docker daemon"
popd
