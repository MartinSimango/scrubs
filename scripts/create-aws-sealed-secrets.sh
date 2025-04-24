#!/bin/bash

NAMESPACE=$1

if [ -z "$NAMESPACE" ]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

kubeseal --fetch-cert --controller-name=sealed-secrets --controller-namespace=kube-system > pub-sealed-secrets.pem


kubectl create secret generic aws-creds \
  --from-literal=AWS_ACCESS_KEY_ID=$KUBERNETES_AWS_ACCESS_KEY_ID \
  --from-literal=AWS_SECRET_ACCESS_KEY=$KUBERNETES_AWS_SECRET_ACCESS_KEY \
  --namespace=$NAMESPACE \
  --dry-run=client -o yaml > aws-creds.yaml



kubeseal --format=yaml --cert=pub-sealed-secrets.pem \
< aws-creds.yaml > k8s/system/cronjobs/aws-creds.yaml

rm aws-creds.yaml
rm pub-sealed-secrets.pem

