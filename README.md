# 🏡 Homelab

Kubernetes homelab setup with Talos Linux, automated with Terraform and GitOps with Jonas Hietala's [Modern Kubernetes homelab](https://www.jonashietala.se/series/kube-homelab/)

## Cluster Provisioning
- Talos Linux automated with Terraform

### Hardware
- Proxmox Cluster
  - Lenovo ThinkCenter M90q Gen 1
  - Lenovo ThinkCenter M90q Gen 1
  - Gigabyte Brix

- NAS
  - Synology RS815+

### Services
- [Homepage](https://gethomepage.dev/)

### Infrastructure
- [Terraform](https://developer.hashicorp.com/terraform)
  - [Terraform-Proxmox](https://registry.terraform.io/providers/bpg/proxmox)
  - [Terraform-Talos](https://registry.terraform.io/providers/siderolabs/talos)
- [Flux CD](https://fluxcd.io/)
- [Renovate](https://www.mend.io/renovate/)
- [Synology CSI Driver](https://github.com/zebernst/synology-csi-talos)

## Stack Bootstrap

```
just bootstrap full
```

## Secrets
- SOPS + Age

Create and ensure keys.txt is store somehwere safe (Proton Pass)

```sh
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```


# TODO:
- GitOps (FluxCD/ArgosCD) Bootstrap
- Domain, certificates, DNS
- Data & Storage
- SSO