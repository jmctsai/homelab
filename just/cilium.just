[doc("Bootstrap Cilium")]
[working-directory('../gitops')]
cilium: wait_for_api
    kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml
    helm install cilium \
        --repo https://helm.cilium.io/ \
        cilium \
        --namespace kube-system \
        --version 1.19.2 \
        --set kubeProxyReplacement=true \
        --set k8sServiceHost=10.123.20.200 \
        --set k8sServicePort=6443 \
        --set l2announcements.enabled=true \
        --set externalIPs.enabled=true \
        --set gatewayAPI.enabled=true \
        --set ipam.mode=kubernetes \
        --set operator.replicas=1 \
        --set securityContext.privileged=true
    kubectl rollout status daemonset/cilium -n kube-system
    kubectl apply -f bootstrap/cilium_config.yaml
    talosctl health -n 10.123.20.200 --wait-timeout 10m

[private]
wait_for_api:
    until kubectl get nodes 2>/dev/null | grep -q "NotReady\|Ready"; do sleep 5; done