# Cilium deployment via gitops
1. talos setup with proxy and cni disabled
2. manual helm install
  ```sh
  helm install cilium cilium/cilium \
    --version 1.18.1 \
    --namespace kube-system \
    --set ipam.mode=kubernetes \
    --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    --set cgroup.autoMount.enabled=false \
    --set cgroup.hostRoot=/sys/fs/cgroup \
    --set operator.replicas=1 \
    --set kubeProxyReplacement=true \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set k8sServiceHost=localhost \
    --set k8sServicePort=7445 \
    --set=gatewayAPI.enabled=true \
    --set=gatewayAPI.enableAlpn=true \
    --set=gatewayAPI.enableAppProtocol=true
  ```
3. flux bootstrap
4. uninstall helm
  `helm uninstall cilium --namespace kube-system`
5. test if working
  `cilium status`

## manual method: helm install
`helm get values cilium -n kube-system -o yaml > current-values.yaml`
```yaml
cgroup:
  autoMount:
    enabled: false
  hostRoot: /sys/fs/cgroup
gatewayAPI:
  enableAlpn: true
  enableAppProtocol: true
  enabled: true
hubble:
  relay:
    enabled: true
  ui:
    enabled: true
ipam:
  mode: kubernetes
k8sServiceHost: localhost
k8sServicePort: 7445
kubeProxyReplacement: true
operator:
  replicas: 1
securityContext:
  capabilities:
    ciliumAgent:
    - CHOWN
    - KILL
    - NET_ADMIN
    - NET_RAW
    - IPC_LOCK
    - SYS_ADMIN
    - SYS_RESOURCE
    - DAC_OVERRIDE
    - FOWNER
    - SETGID
    - SETUID
    cleanCiliumState:
    - NET_ADMIN
    - SYS_ADMIN
    - SYS_RESOURCE
```