# SOPS using AGE encryption

## AGE usage
- use for SOPS operater kubernetes?
  - CRD for SOPS Operator
- taloshelper?

<!-- $SOPS_AGE_KEY_FILE defined in .zshrc env variable -->

manual encrypt
```
sops --encrypt --age $(cat $SOPS_AGE_KEY_FILE |grep -oP "public key: \K(.*)") --encrypted-regex '^(data|stringData)$' --in-place ./secret.yaml
```

manual decrypt
```
sops --decrypt --age $(cat $SOPS_AGE_KEY_FILE |grep -oP "public key: \K(.*)") --encrypted-regex '^(data|stringData)$' --in-place ./secret.yaml
```

simpliy manual encryption/description
- leverage .sops.yaml?