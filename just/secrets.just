[doc("Decrypt required files committed to git")]
decrypt_required:
    just secrets decrypt_cluster_config
    just secrets decrypt_terraform_secrets
    just secrets decrypt_terraform_state

[doc("Encrypt talosconfig and kubeconfig")]
[working-directory('../infrastructure')]
encrypt_cluster_config:
    sops --encrypt kubeconfig.yaml > kubeconfig.encrypted.yaml
    sops --encrypt talosconfig.yaml > talosconfig.encrypted.yaml

[doc("Decrypt talosconfig and kubeconfig")]
[working-directory('../infrastructure')]
decrypt_cluster_config:
    sops --decrypt talosconfig.encrypted.yaml > talosconfig.yaml
    sops --decrypt kubeconfig.encrypted.yaml > kubeconfig.yaml
    chmod 600 talosconfig.yaml kubeconfig.yaml

[doc("Encrypt secrets.auto.tfvars")]
[working-directory('../infrastructure')]
encrypt_terraform_secrets:
    sops --encrypt secrets.auto.tfvars > secrets.auto.encrypted.tfvars

[doc("Decrypt secrets.auto.tfvars")]
[working-directory('../infrastructure')]
decrypt_terraform_secrets:
    sops --decrypt secrets.auto.encrypted.tfvars > secrets.auto.tfvars
    chmod 600 secrets.auto.tfvars

[doc("Encrypt terraform.tfstate")]
[working-directory('../infrastructure')]
encrypt_terraform_state:
    sops --encrypt --input-type json --output-type json terraform.tfstate > terraform.encrypted.tfstate

[doc("Decrypt terraform.tfstate")]
[working-directory('../infrastructure')]
decrypt_terraform_state:
    # If the encrypted state doesn't exist yet (fresh repo), skip silently.
    test -f terraform.encrypted.tfstate || exit 0
    sops --decrypt --input-type json --output-type json terraform.encrypted.tfstate > terraform.tfstate
    chmod 600 terraform.tfstate
