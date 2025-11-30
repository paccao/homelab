# Node exporter requires escalated privileges

- Status: Mitigated
- Date: 2025-11-30

## Context and Problem Statement

Node exporter DaemonSet cannot be installed in a TalOS cluster because TalOS enforces 'baseline' [Pod Security Standards](https://docs.siderolabs.com/kubernetes-guides/security/pod-security). Usually Node exporter is installed with the 'privileged' policy which have unrestricted permissions.

Installing node exporter with unrestricted permissions could be a security issue where a bad actor can get root access. However, giving it restricted permissions would lead to less metrics from the node it is installed on which can be crucial for reliability.

Is it worth adding these additional risks compared to the metrics gained with privileged access, and can the risks be mitigated somehow?

## Decision Drivers <!-- optional -->

- I want network I/O stats from the control plane nodes, which requires [privileged access](https://github.com/prometheus-community/helm-charts/issues/4837#issuecomment-2845595774)
- I want CPU/memory usage from system daemons (kubelet, containerd), which also requires privileged access.
- I want to limit the attack surface on my cluster, enforcing a restrictive security policy.

## Considered Options

1. Give the monitoring namespace privileged access by adjusting the namespace label / TalOS PSA config.
1. Give the monitoring namespace restricted access by adjusting the namespace label / TalOS PSA config.(currently its set to the baseline policy)
1. Install and configure Kyverno or Gatekeeper to only give the Node exporters Daemonset in the monitoring namespace privileged access and not the entire namespace like in option 1.
1. Give the monitoring namespace privileged access with ns label like in option 1. Limit the attack surface in other ways.

## Decision Outcome

Chose option: 4. Will give the monitoring namespace privileged access but restrict access to it to limit the potential attack surface and set up warnings/ alarms for unexpected access to that namespace.

I accept the risk of unauthorized privileged access to the monitoring namespace because the risk is low (misconfiguration of nw-policy or a 0-day in the cluster)

### Positive consequences

- I will get access to node network I/O and CPU/memory statistics by system processes which will be useful for observability, more data = more visibility into the health of the cluster.
- This will help me learn about network policies, pod security admission and the pod securityContext.
- Keeps the configuration of the cluster more simple because I stay away from Kyverno / Gatekeeper for now. Using those requires learning their "syntax" if I want to write my own custom policies. It also keeps the resource usage down of my nodes which are relatively small.

### Negative consequences
- Misconfiguration of the network policies could lead to unauthorized privileged access. That could lead to data-loss. The risk is low because the real attack vector is misconfiguration which I feel will be low. Another attack vector would be a 0-day in the cluster but that is always a risk. My backups will mitigate this issue.

### Things to follow up on based on this decision outcome

- Set up Network policys to limit access to the monitoring namespace.
- Look over all the RBAC rules I have defined in the prometheus directory.
- Set up audit/ warnings for attempted unexpected access to the monitoring namespace.
- Set up audit/ warnings for common attack vectors related to privileged access to a node. For example: a process tries to mount a path like /proc.
