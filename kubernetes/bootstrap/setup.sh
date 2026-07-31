#/bin/bash

kubectl apply --server-side --filename ../apps/cert-manager/ns.yaml
kubectl apply --server-side --filename ../apps/o11y/ns.yaml
