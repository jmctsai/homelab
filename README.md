# 🏡 Homelab

Kubernetes homelab following FluxCD [monorepo structure](https://github.com/fluxcd/flux2-kustomize-helm-example)

## Cluster Provisioning
- Talos Linux automated with Terraform

## Hardware
- Proxmox VM

### Apps
- [Homepage](https://gethomepage.dev/)

### Infrastructure
- [Terraform-Proxmox](https://registry.terraform.io/providers/bpg/proxmox)
- [Terraform-Talos](https://registry.terraform.io/providers/siderolabs/talos)
- [Flux CD](https://fluxcd.io/)
- [Renovate](https://www.mend.io/renovate/)
- [Synology CSI Driver](https://github.com/zebernst/synology-csi-talos)

### Storage
- Synology RS815+

## Stack Bootstrap

```
just bootstrap full
```

# TODO: add into bootstrap with just
## FluxCD Bootstrap

```sh
flux bootstrap github \
  --owner=jmctsai \
  --repository=homelab \
  --branch=main \
  --path=./gitops/clusters/staging/ \
  --personal
```

## Secrets

- SOPS Age
```sh
k create secret generic sops-age \
--from-file=age.agekey=$HOME/.config/sops/key.txt \
-n flux-system
```