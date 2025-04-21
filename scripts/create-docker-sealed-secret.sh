#!/bin/bash
NAMESPACE=$1

if [ -z "$NAMESPACE" ]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi
kubeseal --fetch-cert --controller-name=sealed-secrets --controller-namespace=kube-system > pub-sealed-secrets.pem


kubectl create secret docker-registry docker-credentials \
  --docker-username=$DOCKER_USERNAME \
  --docker-password=$DOCKER_PASSWORD \
  --docker-email=$DOCKER_EMAIL \
  --namespace=$NAMESPACE \
  --dry-run=client -o yaml > docker-credentials.yaml



kubeseal --format=yaml --cert=pub-sealed-secrets.pem \
< docker-credentials.yaml > k8s/overlays/$NAMESPACE/sealed-docker-credentials.yaml

rm docker-credentials.yaml
rm pub-sealed-secrets.pem

