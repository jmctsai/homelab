helm chart. if doesn't come with helm chart, wrap into bjw-s' common chart(https://github.com/bjw-s/helm-charts/tree/main/charts)

longhorn
- bare metal cluster, no network storage, just direct attach
- running stateful workloads in cluster

mounted drive
- persistent volume (PV)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mypv
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ""
  nfs:  # NFS configuration
    server: 192.168.1.9  # Replace with your NFS server IP
    path: "/mydata1"     # Replace with NFS server path
```