<!-- Setup -->
terraform plan
terraform apply

<!-- Config -->
terraform output -raw talosconfig > talosconfig.yaml
terraform output -raw kubeconfig > kubeconfig.yaml

<!-- Teardown -->
terraform destroy