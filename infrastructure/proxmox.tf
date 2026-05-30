# ── Image ──────────────────────────────────────────────
resource "proxmox_download_file" "talos_image" {
  for_each                = toset([for node in var.nodes : node.node_name])
  node_name               = each.value
  content_type            = "iso"
  datastore_id            = "local"
  url                     = "https://factory.talos.dev/image/${var.talos_image_factory_id}/v${var.talos_version}/nocloud-amd64.raw.xz"
  decompression_algorithm = "zst"
  file_name               = "talos-v${var.talos_version}-nocloud-amd64.img"
  overwrite               = false
}

# ── VMs ────────────────────────────────────────────────
resource "proxmox_virtual_environment_vm" "talos" {
  for_each        = { for node in var.nodes : node.hostname => node }
  name            = each.key
  node_name       = each.value.node_name
  vm_id           = each.value.vm_id
  tags            = ["terraform", "talos"]
  on_boot         = true
  stop_on_destroy = true

  agent {
    enabled = true
  }

  disk {
    datastore_id = local.lvm_datastore[each.value.node_name]
    file_id      = proxmox_download_file.talos_image[each.value.node_name].id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  initialization {
    datastore_id = local.lvm_datastore[each.value.node_name]
    ip_config {
      ipv4 {
        address = "${each.value.ip}/21"
        gateway = var.gateway_ip
      }
    }
  }

  cpu {
    cores = each.value.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
    floating  = each.value.memory
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }
}