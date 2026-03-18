# Installation instructions

Install with CRDs:

```bash
helm template \
  cilium \
  cilium/cilium \
  --version 1.18.4 \
  --namespace kube-system \
  -f values.yaml \
  --include-crds > secrets/cilium.yaml
```

If CRDs are already installed, skip the --include-crds flag above.

```bash
helm template \
  cilium \
  cilium/cilium \
  --version 1.18.4 \
  --namespace kube-system \
  -f values.yaml > secrets/cilium.yaml
```

# IMPORTANT

Remove the `kind: Secret` objects inside of cilium.yaml.

Seal them into `cilium-ca-sealed.yaml` and `hubble-server-certs-sealed.yaml`

```bash
cat secrets/cilium-ca.yaml | kubeseal --controller-namespace sealed-secrets --format yaml -w cilium-ca-sealed.yaml

cat secrets/hubble-server-certs.yaml | kubeseal --controller-namespace sealed-secrets --format yaml -w hubble-server-certs-sealed.yaml
```

Put cilium.yaml outside of the secrets/ directory when it is free of secrets.

Then, apply: `k apply -k cilium/`
