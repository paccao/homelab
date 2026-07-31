For future me:

1. Fix so that cluster setup is fully automated:

On first setup I ran `helmfile -f <file> template -q | kubectl apply --server-side -f -`

Problems I encountered that I fixed manually, not in the "GitOps" way:

```sh
[resource mapping not found for name: "cilium-agent" namespace: "kube-system" from "STDIN": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
ensure CRDs are installed first, resource mapping not found for name: "cilium-operator" namespace: "kube-system" from "STDIN": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
ensure CRDs are installed first, resource mapping not found for name: "cert-manager" namespace: "cert-manager" from "STDIN": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
ensure CRDs are installed first, resource mapping not found for name: "flux-operator" namespace: "flux-system" from "STDIN": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
ensure CRDs are installed first, resource mapping not found for name: "flux" namespace: "flux-system" from "STDIN": no matches for kind "FluxInstance" in version "fluxcd.controlplane.io/v1"
ensure CRDs are installed first]
Error from server (NotFound): namespaces "cert-manager" not found
Error from server (NotFound): namespaces "o11y" not found
```

1. Warnings from installation that should be looked at:

```sh
rolebinding.rbac.authorization.k8s.io/cilium-operator-ztunnel serverside-applied
Warning: spec.SessionAffinity is ignored for headless services
service/cilium-agent serverside-applied
```

```sh
Warning: would violate PodSecurity "restricted:latest": seccompProfile (pod or container "grafana-operator" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
```

1. Update talconfig DNS servers to mullvad and quay DNS
1. Configure DNS over HTTPS / TLS forwarding in CoreDNS in order to move away from google and cloudflare DNS.
