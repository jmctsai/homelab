# ── Proxmox ────────────────────────────────────────────
pve_endpoint = "https://10.123.20.11:8006/"

# ── Network ────────────────────────────────────────────
gateway_ip  = "10.123.20.1"
cluster_vip = "10.123.20.200"

# Remember to update networking related settings
# - gitops/bootstrap/cilium_config.yaml
# - just/cilium.just


# ── Nodes ──────────────────────────────────────────────
nodes = [
  {
    node_name = "pve"
    hostname  = "talos-cp1"
    vm_id     = 201
    ip        = "10.123.20.201"
    cores     = 2
    memory    = 2 * 1024
  },
  {
    node_name = "pve02"
    hostname  = "talos-cp2"
    vm_id     = 202
    ip        = "10.123.20.202"
    cores     = 2
    memory    = 2 * 1024
 },
 {
    node_name = "pve03"
    hostname  = "talos-cp3"
    vm_id     = 203
    ip        = "10.123.20.203"
    cores     = 2
    memory    = 2 * 1024
 }
]

# ── Talos ──────────────────────────────────────────────
talos_version          = "1.13.3"
talos_image_factory_id = "dc7b152cb3ea99b821fcb7340ce7168313ce393d663740b791c36f6e95fc8586"
kubernetes_version     = "1.35.2"
cluster_name           = "talos-cluster"
