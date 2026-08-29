# 🏠 GitOps homelab

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Talos](https://img.shields.io/badge/Talos%20Linux-purple.svg?style=for-the-badge&logoColor=white)
![GitOps](https://img.shields.io/badge/GitOps-orange.svg?style=for-the-badge)
![FluxCD](https://img.shields.io/badge/FluxCD-green.svg?style=for-the-badge)

A bare-metal Kubernetes cluster running on TalOS Linux with GitOps to configure it declaratively.

In my [Arcitectural decision record](./docs/arch-decisions/README.md) you can find my reasonings for decisions I take in the cluster.

## Infrastructure Overview

| Role | Model | CPU | RAM | SSD |
| ------------- | ------------- | -------------- | -------------- |-------|
| Controlplane | ASUS NUC 14 | N150 (4-cores) | 16GB (DDR5-5600) | Lexar SSD NM620 256GB for [Talos](./kubernetes/bootstrap/talos/talconfig.yaml) |
| Controlplane | Raspberry pi 5 | Cortex-A76 (4-cores) | 16GB (LPDDR4X-4267 SDRAM) | 64GB microSD for read-only root and boot, Lexar SSD NM620 256GB for [Talos](./kubernetes/bootstrap/talos/talconfig.yaml) |
| Workloads | Raspberry pi 5 | Cortex-A76 (4-cores) | 16GB (LPDDR4X-4267 SDRAM) | 64GB microSD for read-only root and boot, Lexar SSD NM620 256GB for [Talos](./kubernetes/bootstrap/talos/talconfig.yaml) |

### Software Stack
- **Base OS**: Talos Linux
- **Runtime**: Containerd
- **CSI**: Longhorn
- **GitOps Engine**: Flux CD

### Network Stack
- **CNI**: Cilium
- **Loadbalancer**: Cilium L2 with ARP/Cilium+OPNSense BGP/MetalLB/kube-vip/k8s-gateway CoreDNS plugin (TBD)
- **Ingress**: Envoy-gateway (TBD)
- **DNS**: CoreDNS
- **Certificates**: Cert-manager, Let's encrypt

### Observability (o11y): 
- **Metrics engine**: Prometheus
- **NVMe metrics**: smartctl-exporter
- **Dashboards**: Grafana
- **Logs**: Grafana Loki
- **Alerts**: Alertmanager

### Security
- **Network policies**: Cilium
- **Static image scanning**: Trivy
- **Intrusion detection system**: Crowdsec
- **Web application firewall**: (TBD) Crowdsec? Cilium?

Additionally, go through the [Kubernetes security checklist](https://kubernetes.io/docs/concepts/security/security-checklist/)

---

## Dependencies

This repository uses Mise to set up tooling locally. Follow this [guide](https://mise.jdx.dev/getting-started.html) to set it up.

Then install dependencies using the lockfile.

```sh
mise install --locked
```

## Getting started

1. Provision the nodes by following this [guide](kubernetes/bootstrap/talos/README.md)
1. Bootstrap flux and the cluster by following this [guide](kubernetes/bootstrap/README.md)

---

## IP plan

subnet 192.168.30.0/24

```
192.168.30.10                    - nuc-controlplane-1
192.168.30.12                    - pi5-controlplane-2
192.168.30.14                    - pi5-controlplane-3
192.168.30.16                    - pi5-worker-1
192.168.30.18                    - pi5-worker-2
192.168.30.20                    - pi4b-worker-3
192.168.30.100                   - TalOS VIP
192.168.30.110 -> 192.168.30.200 - CiliumLoadBalancerIPPool
192.168.30.240 -> 192.168.30.250 - DHCP
```

---

## Other notes

[notes.md](./docs/notes.md)
