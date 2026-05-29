terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.107.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.11.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.virtual_environment_endpoint
  api_token = var.api_token
  insecure  = true
  ssh {
    agent    = false
    username = var.ssh_username
    password = var.ssh_password
  }
}