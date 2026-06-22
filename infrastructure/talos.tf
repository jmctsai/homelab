# ── Secrets ────────────────────────────────────────────
resource "talos_machine_secrets" "machine_secrets" {
  talos_version = "v${var.talos_version}"
}

# ── Configuration ──────────────────────────────────────
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
    # Disk & image
    yamlencode({
      machine = {
        install = {
          disk  = "/dev/vda"
          image = local.install_image
        }
      }
    }),
    # Cluster: scheduling, CNI, proxy
    yamlencode({
      cluster = {
        allowSchedulingOnControlPlanes = true
        network                        = { cni = { name = "none" } } # disable Flannel
        proxy                          = { disabled = true }         # disable kube-proxy
      }
    }),
    # Network: VIP + nameservers
    yamlencode({
      machine = {
        network = {
          interfaces  = [{ interface = "eth0", vip = { ip = var.cluster_vip } }]
          nameservers = [var.gateway_ip, "1.1.1.1"]
        }
      }
    }),
  ]
}

resource "talos_machine_configuration_apply" "control_machine_config_apply" {
  for_each                    = { for node in var.nodes : node.hostname => node }
  depends_on                  = [proxmox_virtual_environment_vm.talos]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_machine_config.machine_configuration
  node                        = each.value.ip
}

# ── Bootstrap ──────────────────────────────────────────
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