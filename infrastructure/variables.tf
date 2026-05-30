# Variables are inputs provided from outside Terraform (tfvars, .env, CLI).
# Add a variable here for any value that changes per environment or is secret.
# ── Proxmox ────────────────────────────────────────────
variable "pve_endpoint"  { type = string }
variable "ssh_username"  { type = string }

variable "api_token" {
  type      = string
  sensitive = true
}

variable "ssh_password" {
  type      = string
  sensitive = true
}

# ── Network ────────────────────────────────────────────
variable "gateway_ip"  { type = string }
variable "cluster_vip" { type = string }

# ── Nodes ──────────────────────────────────────────────
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

# ── Talos ──────────────────────────────────────────────
variable "talos_version"          { type = string }
variable "talos_image_factory_id" { type = string }
variable "kubernetes_version"     { type = string }
variable "cluster_name"           { type = string }