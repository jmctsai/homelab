https://www.talos.dev/v1.10/kubernetes-guides/configuration/synology-csi/
https://github.com/zebernst/synology-csi-talos?tab=readme-ov-file#procedure


git clone https://github.com/SynologyOpenSource/synology-csi.git

cd synology-csi

cp config/client-info-template.yml config/client-info.yml

<!-- update client-info.yml -->

kubectl create secret -n synology-csi generic client-info-secret --from-file=config/client-info.yml

<!-- for ghcr built image -->
GITHUB_USER=
GH_PACKAGES_PAT=
kubectl create secret docker-registry ghcr-login-secret --docker-server=https://ghcr.io --docker-username=$GITHUB_USER --docker-password=$GH_PACKAGES_PAT -n synology-csi



