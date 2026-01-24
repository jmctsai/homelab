# TODO: NEW
https://docs.siderolabs.com/kubernetes-guides/csi/synology-csi


# OLD
https://www.talos.dev/v1.10/kubernetes-guides/configuration/synology-csi/
https://github.com/zebernst/synology-csi-talos?tab=readme-ov-file#procedure

<!-- Synology NAS -->
"Volume 1" = /volume1 (checked via SSH)
- need admin permission for service user used

git clone https://github.com/SynologyOpenSource/synology-csi.git
cd synology-csi
cp config/client-info-template.yml config/client-info.yml

<!-- update client-info.yml, create secret to be used -->
kubectl create secret -n synology-csi generic client-info-secret --from-file=config/client-info.yml
<!-- debug: delete to recreate if need to make change -->
k delete secret client-info-secret -n synology-csi

<!-- credential to be used in controller.yaml your locally built image pushed to ghcr -->
GITHUB_USER=
GH_PACKAGES_PAT=
kubectl create secret docker-registry ghcr-login-secret --docker-server=https://ghcr.io --docker-username=$GITHUB_USER --docker-password=$GH_PACKAGES_PAT -n synology-csi
