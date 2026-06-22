[doc("Bootstrap everything from zero")]
full:
    just cluster::cluster
    just cilium::cilium
    just secrets::restore_sealed_secrets_private_key
    just bootstrap::sealed_secrets

[doc("Install sealed secrets controller")]
sealed_secrets:
    helm install sealed-secrets \
        --repo https://bitnami.github.io/sealed-secrets \
        sealed-secrets \
        --version 2.16.2 \
        --namespace sealed-secrets \
        --create-namespace \
        --set fullnameOverride=sealed-secrets-controller
    # Wait for it to deploy
    kubectl rollout status deployment/sealed-secrets-controller -n sealed-secrets
