# Tutorial: https://bash.ghost.io/k8s-home-lab-gitops-with-fluxcd/

Each application will have its own directory under `apps/base`
environment specific setting will reside under `apps/VERSION`

k get pvc -A
k describe pvc linkding-data-pvc
k describe pvc -A


https://stackoverflow.com/questions/52977119/how-do-i-create-a-persistent-volume-on-an-in-house-kubernetes-cluster
For production use case, you will need dynamic provisioning using the StorageClass for PVC, so that the volume/data is available when the pod moves across the cluster.
