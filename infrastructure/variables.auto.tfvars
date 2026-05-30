# ── Proxmox ────────────────────────────────────────────
pve_endpoint = "https://192.168.1.199:8006/"

# ── Network ────────────────────────────────────────────
gateway_ip  = "192.168.0.1"
cluster_vip = "192.168.3.200"

# ── Nodes ──────────────────────────────────────────────
nodes = [
  {
    node_name = "pve"
    hostname  = "talos-cp1"
    vm_id     = 201
    ip        = "192.168.3.201"
    cores     = 2
    memory    = 2 * 1024
  },
  {
    node_name = "pve02"
    hostname  = "talos-cp2"
    vm_id     = 202
    ip        = "192.168.3.202"
    cores     = 2
    memory    = 2 * 1024
  },
  {
    node_name = "pve03"
    hostname  = "talos-cp3"
    vm_id     = 203
    ip        = "192.168.3.203"
    cores     = 2
    memory    = 2 * 1024
  },
  {
    node_name = "pve04"
    hostname  = "talos-cp4"
    vm_id     = 204
    ip        = "192.168.3.204"
    cores     = 2
    memory    = 2 * 1024
  }
]

# ── Talos ──────────────────────────────────────────────
talos_version          = "1.13.3"
talos_image_factory_id = "dc7b152cb3ea99b821fcb7340ce7168313ce393d663740b791c36f6e95fc8586"
kubernetes_version     = "1.35.2"
cluster_name           = "talos-cluster"