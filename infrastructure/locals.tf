locals {
  # ── Proxmox ──────────────────────────────────────────
  lvm_datastore = {
    pve   = "local-lvm"
    pve02 = "local-lvm"
    pve03 = "local-lvm"
    pve04 = "local-lvm"
  }

  # ── Nodes ────────────────────────────────────────────
  node_ips                = [for node in var.nodes : node.ip]
  primary_control_node_ip = local.node_ips[0]

  # ── Talos ────────────────────────────────────────────
  install_image    = "factory.talos.dev/installer/${var.talos_image_factory_id}:v${var.talos_version}"
  cluster_endpoint = "https://${var.cluster_vip}:6443"
}