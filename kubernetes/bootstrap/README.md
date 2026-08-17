# Bootstrap apps

Helmfile processes your configuration in a specific order, with values from different sources being merged together. The key concept is that later values override earlier values at the map level (deep merge), while arrays use smart merging (sparse auto-detection by default, with CLI overrides using element-by-element merging). [link](https://helmfile.readthedocs.io/en/latest/values-and-merging/#core-architecture-overview)

```sh
# setup
helmfile init

# dry-run
helmfile diff

# Deploy
helmfile -f crds.yaml template -q | yq ea -e 'select(.kind == "CustomResourceDefinition")' | kubectl apply --server-side --field-manager bootstrap --force-conflicts -f -
helmfile -f apps.yaml sync
```
