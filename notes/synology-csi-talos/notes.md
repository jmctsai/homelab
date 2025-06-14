https://www.talos.dev/v1.10/kubernetes-guides/configuration/synology-csi/
https://github.com/zebernst/synology-csi-talos?tab=readme-ov-file#procedure

# Synology CSI
git clone https://github.com/SynologyOpenSource/synology-csi.git
cd synology-csi
cp config/client-info-template.yml config/client-info.yml

<!-- update client-info.yml -->
kubectl create secret -n synology-csi generic client-info-secret --from-file=config/client-info.yml
k delete secret client-info-secret -n synology-csi

<!-- logs -->
k get events -n synology-csi