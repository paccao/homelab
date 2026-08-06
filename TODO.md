# fix/dns-configuration

This branch is based on fix/flux-configuration. Commit and merge it into fix/flux-configuration before merging to main.

## DNS issues

See https://codeberg.org/paccao/homelab/issues/2 and https://codeberg.org/paccao/homelab/issues/5

Troubleshoot CoreDNS, why pods cant reach external nameservers without forcing them to use for example 8.8.8.8

When it works, merge to fix/flux-configuration and re-do flux deployment:

`helmfile template | kubectl apply ...`

`kubectl rollout restart deployment/flux-operator -n flux-system`
