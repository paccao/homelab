# Bootstrap guide

### Generate image id:

```sh
# Nuc
curl -X POST --data-binary @schematic-nuc.yaml https://factory.talos.dev/schematics

# Pi5
curl -X POST --data-binary @schematic-rpi5.yaml https://factory.talos.dev/schematics
```

Replace the IDs in `talconfig.yaml` for each respective node.

```yaml
talosImageURL: factory.talos.dev/installer/<id>
```

### Generate talos secrets

You can add ` --talos-version <version>` for a specific version:

```sh
talosctl gen secrets

# Or from existing cluster config
talosctl gen secrets --from-controlplane-config controlplane.yaml

# Encrypt secret
sops -e secrets.yaml > secrets.sops.yaml
```

### Generate config files

```sh
sops -d talsecret.sops.yaml > talsecret.yaml
talhelper genconfig --secret-file secrets.yaml

# Cleanup
rm talsecret.yaml
```

Find your nodes ip if its assigned by DHCP:

```sh
nmap -sn 192.168.30.0/24
```

Then apply each config to the respective node:

```sh
talosctl apply-config -n <ip> --insecure --file clusterconfig/homelab-nuc-controlplane-1.yaml
talosctl apply-config -n <ip> --insecure --file clusterconfig/homelab-pi5-controlplane-2.yaml

# --mode reboot
```
