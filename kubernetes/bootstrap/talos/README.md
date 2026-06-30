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

### Download image (for flashing onto memory cards)

```sh
# --- For rpi5 ---
# Get factory.talos.dev/image/<id>/... from above

# Fish shell
set -x SCHEMATIC_ID # <id>
set -x TALOS_INSTALL_VERSION # <version>
set -x TALOSIMG_INSTALL_PATH ~/Downloads/images/

curl -fL "https://factory.talos.dev/image/$SCHEMATIC_ID/$TALOS_INSTALL_VERSION/metal-arm64.raw.xz" -o "$TALOSIMG_INSTALL_PATH/talos-$TALOS_INSTALL_VERSION-metal-arm64.raw.xz"
unxz "$TALOSIMG_INSTALL_PATH/talos-$TALOS_INSTALL_VERSION-metal-arm64.raw.xz"

# Find device to flash talos with, replace of=/dev/sdX below
lsblk

# Overwrite device drive with talos
sudo dd if="$TALOSIMG_INSTALL_PATH/talos-$TALOS_INSTALL_VERSION-metal-arm64.raw" of=/dev/sda bs=4M status=progress conv=fsync
```

### Find your interfaces

Connect the memory card / usb stick with talos to the device you want to install on.

Find your node ip if its assigned by DHCP:

```sh
nmap -sn 192.168.30.0/24
```

Talos will boot up in maintenance mode, verify with `talosctl get machinestatus -n <ip> --insecure`

Find your network interface and modify `talconfig.yaml` for each node separately.

```sh
talosctl -n <ip> get links --insecure
talosctl -n <ip> get addresses --insecure
```

Update `talconfig.yaml` for each node:

```yaml
nodes:
  networkInterfaces:
    - deviceSelector:
        hardwareAddr: # MAC address of the interface, its different for each node
```

Find your device names

```sh
talosctl -n <ip> get disks --insecure
```

Update config:

```yaml
nodes:
  installDisk: /dev/<device> # microSD card
  volumes:
  - provisioning:
      diskSelector:
        match: "disk.model.startsWith('<DISKS.MODEL>')" # NVMe
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
sops -d secrets.sops.yaml > secrets.yaml
talhelper genconfig --secret-file secrets.yaml

# Cleanup
rm secrets.yaml
```

Then apply each config to the respective node:

```sh
talosctl apply-config -n <ip> --insecure --file clusterconfig/homelab-nuc-controlplane-1.yaml
talosctl apply-config -n <ip> --insecure --file clusterconfig/homelab-pi5-controlplane-2.yaml

# --mode reboot
```
