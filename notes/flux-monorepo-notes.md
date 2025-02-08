# Tutorial: https://bash.ghost.io/k8s-home-lab-gitops-with-fluxcd/

Each application will have its own directory under `apps/base`
environment specific setting will reside under `apps/VERSION`

k get pvc -A
k describe pvc linkding-data-pvc
k describe pvc -A