#!/bin/bash

NAMESPACE=$1

if [ -z "$NAMESPACE" ]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

kubeseal --fetch-cert --controller-name=sealed-secrets --controller-namespace=kube-system > pub-sealed-secrets.pem


kubectl create secret generic grafana \
  --from-literal=admin-user=admin\
  --from-literal=admin-password=$GRAFANA_ADMIN_PASSWORD \
  --namespace=$NAMESPACE \
  --dry-run=client -o yaml > grafana-creds.yaml



kubeseal --format=yaml --cert=pub-sealed-secrets.pem \
< grafana-creds.yaml > k8s/system/monitoring/grafana-creds.yaml

rm grafana-creds.yaml
rm pub-sealed-secrets.pem

