# 🏡 Homelab

Kubernetes homelab following FluxCD [monorepo structure](https://github.com/fluxcd/flux2-kustomize-helm-example)

## Cluster Provisioning
- Talos Linux

## Hardware
- Control Plane and Worker Nodes with bare metal nodes

### Apps
- [Homepage](https://gethomepage.dev/)

### Infrastructure
- [Flux CD](https://fluxcd.io/)
- [Renovate](https://www.mend.io/renovate/)
- [Synology CSI Driver](https://github.com/zebernst/synology-csi-talos)

### Storage
- Synology RS815+

## FluxCD Bootstrap

```sh
flux bootstrap github \
  --owner=jmctsai \
  --repository=homelab \
  --branch=main \
  --path=./clusters/staging/ \
  --personal
```

## Secrets

- SOPS Age
```sh
k create secret generic sops-age \
--from-file=age.agekey=$HOME/.config/sops/key.txt \
-n flux-system
```


## Repository structure

The Git repository contains the following top directories:

- **apps** dir contains Helm releases with a custom configuration per cluster
- **infrastructure** dir contains common infra tools such as ingress-nginx and cert-manager
- **clusters** dir contains the Flux configuration per cluster

```
├── apps
│   ├── base
│   ├── production
│   └── staging
├── infrastructure
│   ├── configs
│   └── controllers
└── clusters
    ├── production
    └── staging
```

### Applications

The apps configuration is structured into:

- **apps/base/** dir contains namespaces and Helm release definitions
- **apps/production/** dir contains the production Helm release values
- **apps/staging/** dir contains the staging values

```
./apps/
├── base
│   └── podinfo
│       ├── kustomization.yaml
│       ├── namespace.yaml
│       ├── release.yaml
│       └── repository.yaml
├── production
│   ├── kustomization.yaml
│   └── podinfo-patch.yaml
└── staging
    ├── kustomization.yaml
    └── podinfo-patch.yaml
```

In **apps/base/podinfo/** dir we have a Flux `HelmRelease` with common values for both clusters:

```yaml
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: podinfo
  namespace: podinfo
spec:
  releaseName: podinfo
  chart:
    spec:
      chart: podinfo
      sourceRef:
        kind: HelmRepository
        name: podinfo
        namespace: flux-system
  interval: 50m
  values:
    ingress:
      enabled: true
      className: nginx
```

In **apps/staging/** dir we have a Kustomize patch with the staging specific values:

```yaml
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: podinfo
spec:
  chart:
    spec:
      version: ">=1.0.0-alpha"
  test:
    enable: true
  values:
    ingress:
      hosts:
        - host: podinfo.staging
```

Note that with `version: ">=1.0.0-alpha"` we configure Flux to automatically upgrade
the `HelmRelease` to the latest chart version including alpha, beta and pre-releases.

In **apps/production/** dir we have a Kustomize patch with the production specific values:

```yaml
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: podinfo
  namespace: podinfo
spec:
  chart:
    spec:
      version: ">=1.0.0"
  values:
    ingress:
      hosts:
        - host: podinfo.production
```

Note that with ` version: ">=1.0.0"` we configure Flux to automatically upgrade
the `HelmRelease` to the latest stable chart version (alpha, beta and pre-releases will be ignored).

### Infrastructure

The infrastructure is structured into:

- **infrastructure/controllers/** dir contains namespaces and Helm release definitions for Kubernetes controllers
- **infrastructure/configs/** dir contains Kubernetes custom resources such as cert issuers and networks policies

```
./infrastructure/
├── configs
│   ├── cluster-issuers.yaml
│   └── kustomization.yaml
└── controllers
    ├── cert-manager.yaml
    ├── ingress-nginx.yaml
    └── kustomization.yaml
```

In **infrastructure/controllers/** dir we have the Flux definitions such as:

```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: OCIRepository
metadata:
  name: cert-manager
  namespace: cert-manager
spec:
  interval: 24h
  url: oci://quay.io/jetstack/charts/cert-manager
  layerSelector:
    mediaType: "application/vnd.cncf.helm.chart.content.v1.tar+gzip"
    operation: copy
  ref:
    semver: "1.x"
---
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: cert-manager
  namespace: cert-manager
spec:
  interval: 12h
  chartRef:
    kind: OCIRepository
    name: cert-manager
  values:
    crds:
      enabled: true
      keep: false
```

Note that in the `OCIRepository` we configure Flux to check for new chart versions every 24 hours.
If a newer chart is found that matches the `semver: 1.x` constraint, Flux will upgrade the release accordingly.

In **infrastructure/configs/** dir we have Kubernetes custom resources, such as the Let's Encrypt issuer:

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    # Replace the email address with your own contact email
    email: fluxcdbot@users.noreply.github.com
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-nginx
    solvers:
      - http01:
          ingress:
            class: nginx
```

In **clusters/production/infrastructure.yaml** we replace the Let's Encrypt server value to point to the production API:

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: infra-configs
  namespace: flux-system
spec:
  # ...omitted for brevity
  dependsOn:
    - name: infra-controllers
  patches:
    - patch: |
        - op: replace
          path: /spec/acme/server
          value: https://acme-v02.api.letsencrypt.org/directory
      target:
        kind: ClusterIssuer
        name: letsencrypt
```

Note that with `dependsOn` we tell Flux to first install or upgrade the controllers and only then the configs.
This ensures that the Kubernetes CRDs are registered on the cluster, before Flux applies any custom resources.

### Clusters

A cluster is configured inside its own directory under **clusters/** dir, containing:

- **artifacts.yaml** contains an `ArtifactGenerator` that splits the monorepo into infrastructure and apps artifacts
- **infrastructure.yaml** contains the Flux `Kustomization` definitions for reconciling the infrastructure controllers and configs
- **apps.yaml** contains the Flux `Kustomization` definition for reconciling the apps Kustomize overlay for the specific cluster

```
./clusters/
├── production
│   ├── apps.yaml
│   ├── artifacts.yaml
│   └── infrastructure.yaml
└── staging
    ├── apps.yaml
    ├── artifacts.yaml
    └── infrastructure.yaml
```

In **clusters/staging/** dir we have the Flux Kustomization definitions, for example:

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: apps
  namespace: flux-system
spec:
  dependsOn:
    - name: infra-configs
  interval: 1h
  retryInterval: 2m
  timeout: 5m
  sourceRef:
    kind: ExternalArtifact
    name: apps
  path: ./staging
  prune: true
  wait: true
```

With `path: ./staging` we configure Flux to sync the apps staging Kustomize overlay and
with `dependsOn` we tell Flux to wait for the infrastructure configs to be installed before applying the apps.

Note that the `ExternalArtifact` source is generated by the `ArtifactGenerator`
from the contents of the **apps/base** and **apps/staging** dirs.
The `ArtifactGenerator` allows us to split the monorepo into smaller artifacts that can be synced independently.
Changes to files outside the **apps/** dirs will not trigger a reconciliation of the apps Kustomization.
