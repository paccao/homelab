# How to install prometheus operator

---

The CRDs are too large for running `kubectl apply -k .`

While these files represent the state of the cluster, the easy way to install it is following the guide in the main [README.](../../README.md#prometheus-operator)

Copy the bundle to prometheus, split the resources into different files (for readability), then run:

```bash
kubectl create -k .
```

---

# kube-prometheus

Complete setup with Prometheus, Grafana and Alertmanager

Download the zip of the current branch and extract its contents
https://github.com/prometheus-operator/kube-prometheus/archive/main.zip


```bash
# Create the namespace and CRDs, and then wait for them to be available before creating the remaining resources
kubectl create -f manifests/setup

# Wait until the "servicemonitors" CRD is created. The message "No resources found" means success in this context.
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done

kubectl create -f manifests/
```