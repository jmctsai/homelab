variable "nodes" {
  description = "List of nodes and their configurations."
  type = list(object({
    node_name = string
    hostname  = string
    vm_id     = number
    ip        = string
    cores     = number
    memory    = number
  }))
}

locals {
  lvm_datastore = {
    pve      = "local-lvm"
    pve02    = "local-lvm"
    pve03    = "local-lvm"
    pve04    = "local-lvm"
  }
}

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

# Talos Linux cluster configuration
locals {
  node_ips = [for node in var.nodes : node.ip]
  primary_control_node_ip = local.node_ips[0]
  install_image = "factory.talos.dev/installer/${var.talos_image_factory_id}:v${var.talos_version}"
  cluster_endpoint = "https://${var.cluster_vip}:6443"
}

resource "talos_machine_secrets" "machine_secrets" {
  talos_version = "v${var.talos_version}"
}

data "talos_client_configuration" "client_config" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoints            = local.node_ips
  nodes                = local.node_ips
}

data "talos_machine_configuration" "control_machine_config" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = local.cluster_endpoint
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.machine_secrets.machine_secrets
  kubernetes_version = "v${var.kubernetes_version}"
  talos_version      = "v${var.talos_version}"

  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk  = "/dev/vda" # virtio0 disk
          image = local.install_image
        }
      }
    }),
    yamlencode({
      cluster = {
        allowSchedulingOnControlPlanes = true
      }
    }),
    # Disables the Flannel, the default CNI for Talos
    yamlencode({
      cluster = {
        network = {
          cni = {
            name = "none"
          }
        }
      }
    }),
    # Disables kube-proxy, the default proxy service
    yamlencode({
      cluster = {
        proxy = {
          disabled = true
        }
      }
    }),
    # Tell the nodes to use the VIP for the Kubernetes API endpoint
    yamlencode({
      machine = {
        network = {
          interfaces = [{
            interface = "eth0"
            vip = {
              ip = var.cluster_vip
            }
          }]
        }
      }
    }),
    # Add additional nameservers to ensure the nodes can resolve external domains
    yamlencode({
      machine = {
        network = {
          nameservers = ["192.168.0.1", "1.1.1.1"]
        }
      }
    })
  ]
}

resource "talos_machine_configuration_apply" "control_machine_config_apply" {
  for_each                    = { for node in var.nodes : node.hostname => node }
  depends_on                  = [proxmox_virtual_environment_vm.talos]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_machine_config.machine_configuration
  node                        = each.value.ip
}

resource "talos_machine_bootstrap" "bootstrap" {
  depends_on           = [talos_machine_configuration_apply.control_machine_config_apply]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = local.primary_control_node_ip
  endpoint             = local.primary_control_node_ip
}

resource "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on           = [talos_machine_bootstrap.bootstrap]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = local.primary_control_node_ip
}

output "talosconfig" {
  value     = data.talos_client_configuration.client_config.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = resource.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  sensitive = true
}
