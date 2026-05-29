[doc("terraform init")]
[working-directory('../infrastructure')]
init *args:
    terraform init {{args}}

[doc("terraform apply")]
[working-directory('../infrastructure')]
apply *args:
    terraform apply {{args}}

[doc("terraform destroy")]
[working-directory('../infrastructure')]
destroy *args:
    terraform destroy {{args}}