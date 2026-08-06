# Other notes

## Search for a helm release

[https://kubesearch.dev/](https://kubesearch.dev/)

## Talos config changes which might need a reboot

[Link to docs](https://docs.siderolabs.com/talos/v1.14/configure-your-talos-cluster/system-configuration/editing-machine-configuration#changes-which-might-need-a-reboot)

## Security

Scan cluster for with [kubescape](https://github.com/kubescape/kubescape) to detect vulnerabilities and misconfiguration.

## Backups and Disaster recovery plan

Take regular backups and test restoring backups in a local k8s cluster

**Todo:** Set up TalOS in VMs and provision the cluster and test that a selection of the data works as expected (restoring all data will take a loong time)

**Todo:** Set up backups and DR plan

https://longhorn.io/docs/1.10.0/snapshots-and-backups/backup-and-restore/create-a-backup/#incremental-backup

## Talhelper

[docs](https://budimanjojo.github.io/talhelper/latest/getting-started/)

> Do not update or change your talsecret.sops.yaml file once you have a working cluster unless you want to recreate a new cluster or know what you're doing as you will break the cluster and lose access to it.

> Running talhelper genconfig will request a brand new talosconfig that is valid for 365 days since the time you run the command. This means the content of the file will be different everytime. This is the equivalent to [Generating new client configuration](https://docs.siderolabs.com/talos/v1.13/security/cert-management#generating-new-client-configuration) that you can use to re-request a new client configuration.

## Sops

Use sops to encrypt secrets to store in git.

```sh
sops -e talsecret.yaml > talsecret.sops.yaml

# Keep unencrypted file in talsecret so it is ignored by git.
sops -d talsecret.sops.yaml > talsecret.yaml
```

[Setup sops](https://budimanjojo.github.io/talhelper/latest/guides/#configuring-sops-for-talhelper)

[How to use sops in manifests and patches](https://budimanjojo.github.io/talhelper/latest/guides/#using-sops-encrypted-files-in-manifests-and-patches)

## Services to consider

- Local LLM like Qwen / Glm 4.5 air / Claude Sonnet 4.5 Thinking. Requirements: 1 or more GPUs with 24GB+ VRAM (A100, H100, 3090, etc.)

[More info on selfhosted LLMs](https://www.reddit.com/r/LocalLLM/comments/1otaaj8/if_people_understood_how_good_local_llms_are/)


## Monitoring CPU temps

https://blog.medinvention.dev/k8s-cpu-temperature-fan-monitoring-for-rpi/

[Credit](https://github.com/mmohamed/k8s-raspberry/blob/66c9a74d7155f1766ea4dfe143b45a119bb28678/s2i/k8s-monitoring/api.yaml#L177

```yaml
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: monitoring-agent
  namespace: monitoring
  labels:
    k8s-app: monitoring-agent
spec:
  selector:
    matchLabels:
      name: monitoring-agent
  template:
    metadata:
      labels:
        name: monitoring-agent
        commit: '{{commit}}'
    spec:
      tolerations:
      # this toleration is to have the daemonset runnable on master nodes
      # remove it if your masters can't run pods
      - key: node-role.kubernetes.io/master
        effect: NoSchedule
      containers:
      - name: monitoring-agent
        image: busybox
        env:
          - name: NODE
            valueFrom:
              fieldRef:
                fieldPath: spec.nodeName
          - name: SERVER
            value: http://monitoring-service.monitoring.svc.${CLUSTER_DOMAIN}/k8s/collect/{{token}}/temperature
        command: [ "sh", "-c"]
        args:
        - while true; do
            TEMP=$(cat /sys/class/thermal/thermal_zone0/temp);
            URL="$SERVER?node=$NODE&value=$TEMP";
            wget -qO- $URL;
            sleep 5;
          done;
        imagePullPolicy: IfNotPresent

```

## Longhorn

[Best practices with longhorn](https://longhorn.io/docs/1.10.0/best-practices/)

- "Longhorn relies heavily on kernel functionality and performs better on some kernel versions."

**Be careful with kernel upgrades** - make sure backups work.

[Useful article](https://phin3has.blog/posts/talos-longhorn/)

[Longhorn StorageClass parameters](https://longhorn.io/docs/1.12.0/references/storage-class-parameters/)

[Setting a backup target for longhorn](https://longhorn.io/docs/1.12.0/snapshots-and-backups/backup-and-restore/set-backup-target/#default-backup-target)

Todo: Plan is to set up a backup target locally on the cluster with MinIO S3 aswell as an off-shore backup in the futureTM.
