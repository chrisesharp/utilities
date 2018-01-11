#!/bin/bash

pushd $( dirname "${BASH_SOURCE[0]}" )
echo "Starting minikube..."
minikube start \
    --extra-config=apiserver.Admission.PluginNames="Initializers,NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,GenericAdmissionWebhook,ResourceQuota" \
    --kubernetes-version=v1.7.5 \
    --insecure-registry "192.168.99.100:32767" \
    --cpus 2 \
    --memory 8192

sleep 3

echo "Starting an insecure docker registry within minikube..."
kubectl create -f kubernetes/minikube-registry.yaml 
helm init 

echo "You will need to add 192.168.99.100:32767 as an insecure registry to your docker daemon"
popd
