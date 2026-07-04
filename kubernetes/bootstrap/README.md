# Bootstrap apps

Helmfile processes your configuration in a specific order, with values from different sources being merged together. The key concept is that later values override earlier values at the map level (deep merge), while arrays use smart merging (sparse auto-detection by default, with CLI overrides using element-by-element merging). [link](https://helmfile.readthedocs.io/en/latest/values-and-merging/#core-architecture-overview)

```sh
# Initialize - checks helm and installs required plugins
helmfile init

# See what would be deployed (dry-run)
helmfile diff

# Deploy to your cluster
helmfile apply

# Remove everything
helmfile destroy
```
