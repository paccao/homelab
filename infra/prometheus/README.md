# How to set up kube-prometheus

Complete setup with Prometheus, Grafana and Alertmanager

Download the zip of the current branch and extract its contents
https://github.com/prometheus-operator/kube-prometheus/archive/main.zip


```bash
# Create the namespace and CRDs, and then wait for them to be available before creating the remaining resources
kubectl create -f setup &&

# Wait until the "servicemonitors" CRD is created. The message "No resources found" means success in this context.
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done &&

kubectl create -f .
```
