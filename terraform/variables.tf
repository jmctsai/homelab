# Proxmox
variable "ssh_username" {
  type      = string
}

variable "ssh_password" {
  type      = string
  sensitive = true
}

variable "api_token" {
  type      = string
  sensitive = true
}

variable "virtual_environment_endpoint" {
  type      = string
}

variable "gateway_ip" {
  type      = string
}

# Talos Linux
variable "talos_version" {
  type      = string
}

variable "talos_image_factory_id" {
  type      = string
}

variable "kubernetes_version" {
  type      = string
}

variable "cluster_name" {
  type      = string
}

variable "cluster_vip" {
  type      = string
}