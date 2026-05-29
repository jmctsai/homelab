<!-- Setup -->
terraform plan
terraform apply

<!-- Config -->
terraform output -raw talosconfig > talosconfig.yaml
terraform output -raw kubeconfig > kubeconfig.yaml

export KUBECONFIG=./kubeconfig.yaml
export TALOSCONFIG=./talosconfig.yaml

talosctl health -n 192.168.3.200
kubectl get pods -A


<!-- Cilium -->
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml
helm repo add cilium https://helm.cilium.io/
helm repo update
helm install cilium cilium/cilium \
  --namespace kube-system \
  --version 1.19.2 \
  --set kubeProxyReplacement=true \
  --set k8sServiceHost=192.168.3.200 \
  --set k8sServicePort=6443 \
  --set l2announcements.enabled=true \
  --set externalIPs.enabled=true \
  --set gatewayAPI.enabled=true \
  --set ipam.mode=kubernetes \
  --set operator.replicas=1 \
  --set securityContext.privileged=true

<!-- apply cilium load balancing -->
kubectl apply -f cilium_config.yaml

<!-- Test -->
kubectl run nginx --image=nginx --port=80
kubectl expose pod nginx --type=LoadBalancer --port=80
kubectl get svc nginx


<!-- Teardown -->
terraform destroy