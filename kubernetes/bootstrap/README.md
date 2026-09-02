# Bootstrap apps

Helmfile processes your configuration in a specific order, with values from different sources being merged together. The key concept is that later values override earlier values at the map level (deep merge), while arrays use smart merging (sparse auto-detection by default, with CLI overrides using element-by-element merging). [link](https://helmfile.readthedocs.io/en/latest/values-and-merging/#core-architecture-overview)

```bash
# setup
helmfile init

# dry-run
helmfile diff

# --- Bootstrap ---
# Namespaces
find kubernetes/apps -mindepth 1 -maxdepth 1 -type d -printf "%f\n"; do
  kubectl create namespace "$ns" --dry-run=client -o yaml | kubectl apply --server-side -f -;
done
# Apply sops-age keyfile as a secret in the cluster
cat $SOPS_AGE_KEY_FILE > age.agekey
cat age.agekey | kubectl --namespace flux-system create secret generic sops-age --from-file=age.agekey=/dev/stdin
# CRDs
helmfile -f crds.yaml template -q | yq ea -e 'select(.kind == "CustomResourceDefinition")' | kubectl apply --server-side --field-manager bootstrap --force-conflicts -f -
# Apps
helmfile -f apps.yaml sync --debug
# --- Clean up ---
rm age.agekey
```
