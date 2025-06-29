# k8s setup

## Kubernetes cluster

### talos on proxmox
<!-- v1.10 -->
https://www.talos.dev/v1.10/talos-guides/install/virtualized-platforms/proxmox/

<!-- Schematic ID content -->
talos image includes:
    - siderolabs/iscsi-tools
    - siderolabs/qemu-guest-agent

<!-- Proxmox - Download from URL - talos-VERSION-metal-amd64.iso -->
https://factory.talos.dev/image/dc7b152cb3ea99b821fcb7340ce7168313ce393d663740b791c36f6e95fc8586/v1.10.4/metal-amd64.iso

#### image with QEMU guest agent for guest VM shutdown
- also used for upgrading talos!!!

VERSION=1.10.4
SCHEMATIC_ID=dc7b152cb3ea99b821fcb7340ce7168313ce393d663740b791c36f6e95fc8586
export CONTROL_PLANE_IP=192.168.1.250
export WORKER01_IP=192.168.1.251
export WORKER02_IP=192.168.1.252

mkdir -p _out/

#### vm creation
- controller - 4 cpu 4g mem
- worker - 2 cpu 2g mem

#### talos machine config
install_image_url="factory.talos.dev/installer/$SCHEMATIC_ID:v$VERSION"
talosctl gen config talos-proxmox-cluster https://$CONTROL_PLANE_IP:6443 --output-dir _out --install-image $install_image_url

talosctl get disks --insecure --nodes $CONTROL_PLANE_IP

- proxmox: VM -> options, ensure 'QEMU Guest Agent' is ENABLED

##### contol plane
talosctl apply-config --insecure --nodes $CONTROL_PLANE_IP --file _out/controlplane.yaml

##### Worker
talosctl apply-config --insecure --nodes $WORKER01_IP --file _out/worker.yaml

talosctl apply-config --insecure --nodes $WORKER02_IP --file _out/worker.yaml

#### Using cluster

##### Talosconfig
export TALOSCONFIG="_out/talosconfig"
talosctl config endpoint $CONTROL_PLANE_IP
talosctl config node $CONTROL_PLANE_IP

##### Bootstrap Etcd
talosctl bootstrap

##### Retrieve kubeconfig (test)
talosctl kubeconfig .
mv kubeconfig _out
export KUBECONFIG="_out/kubeconfig"

#### use commands
cd ~/personal/dev/homelab

talosctl containers
kubectl get pods -A


### Scaling out
https://www.talos.dev/v1.9/talos-guides/howto/scaling-up/

export CONTROL_PLANE02_IP=192.168.1.240
talosctl apply-config --insecure --nodes $CONTROL_PLANE02_IP --file _out/controlplane.yaml



### upgrade talos nodes

#### proxmox talos k8s image with QEMU + ISCSI (synology)
talos image includes:
    - siderolabs/iscsi-tools
    - siderolabs/qemu-guest-agent

VERSION=1.10.4
SCHEMATIC_ID=dc7b152cb3ea99b821fcb7340ce7168313ce393d663740b791c36f6e95fc8586
IMAGE=factory.talos.dev/installer/$SCHEMATIC_ID:v$VERSION

#### shared upgrade commands
export CONTROL_PLANE_IP=192.168.1.250
export WORKER01_IP=192.168.1.251
export WORKER02_IP=192.168.1.252

talosctl upgrade --nodes $CONTROL_PLANE_IP --image $IMAGE
talosctl upgrade --nodes $WORKER01_IP --image $IMAGE
talosctl upgrade --nodes $WORKER02_IP --image $IMAGE