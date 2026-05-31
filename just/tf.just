[doc("terraform init")]
[working-directory('../infrastructure')]
init *args:
    terraform init {{args}}

[doc("terraform plan")]
[working-directory('../infrastructure')]
plan *args:
    terraform plan {{args}}

[doc("terraform apply")]
[working-directory('../infrastructure')]
apply *args:
    #!/usr/bin/env bash
    set -e
    trap 'just secrets::encrypt_terraform_state' EXIT
    terraform apply {{args}}

[doc("terraform destroy")]
[working-directory('../infrastructure')]
destroy *args:
    #!/usr/bin/env bash
    set -e
    trap 'just secrets::encrypt_terraform_state' EXIT
    terraform destroy {{args}}
