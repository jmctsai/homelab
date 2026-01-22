# preface
download iso, launch on instance
talos is runnin in RAM until config applied (specify to wipe - talosconfig)

talhelper to setup talos cluster

All done on Ubuntu WSL on Windows

# Create `talconfig.yaml` defining cluster config

manually created
example: https://github.com/budimanjojo/talhelper/blob/master/example/talconfig.yaml
documentation: https://budimanjojo.github.io/talhelper/latest/reference/configuration/

# create cluster secrets
`talhelper gensecret > talsecret.sops.yaml`

# pre-req: Encrypt secrets with sops
sops and age installed
`age-keygen -o <sops-config-dir>/age/keys.txt`
## create `.sops.yaml` where `talenv.sops.yaml` and `talsecrets.sops.yaml` lives

## talenv.sops.yaml?? where do I use this

# Encrypt secrets with sops
`sops -e -i talsecret.sops.yaml`

# .gitignore
`talhelper genconfig`
clusterconfig/homelab-master01.yaml
talosconfig

> [!WARNING]
> Please don't push the generated files into your public git repository.
> By default talhelper will create a .gitignore file to ignore the generated files for you unless you use --no-gitignore flag.

> [!WARNING]
> Do not update or change your talsecret.sops.yaml file once you have a working cluster unless you want to recreate a new cluster or know what you're doing as you will break the cluster and lose access to it.


# safely commit
talconfig.yaml
talsecret.sops.yaml
talenv.sops.yaml (non yet)


# boostrap talosctl deployment
https://docs.siderolabs.com/talos/v1.12/getting-started/getting-started
`--insecure` for initial configuration

## first node need bootstrap - any control plane
```sh
# shell pre-req
MASTER01_IP=192.168.3.1
KUBECONFIG="$HOME/git/homelab/talos/clusterconfig/kubeconfig"
TALOSCONFIG="$HOME/git/homelab/talos/clusterconfig/talosconfig"
```

```sh
talosctl bootstrap --nodes $MASTER01_IP --talosconfig=$TALOSCONFIG`
talosctl apply-config --talosconfig=$TALOSCONFIG --nodes=$MASTER01_IP --file=./clusterconfig/homelab-master01.yaml

# Repeat for additional machines
talosctl apply-config --talosconfig=$TALOSCONFIG --nodes=$MASTER01_IP --file=./clusterconfig/homelab-master02.yaml
talosctl apply-config --talosconfig=$TALOSCONFIG --nodes=$MASTER01_IP --file=./clusterconfig/homelab-master03.yaml
```

## get KUBECONFIG - https://docs.siderolabs.com/talos/v1.12/getting-started/getting-started#step-10:-get-kubernetes-access
### merge with local Kubernetes config
```sh
talosctl kubeconfig --nodes $MASTER01_IP --talosconfig=$TALOSCONFIG
```

### specify alternative file
```sh
talosctl kubeconfig $KUBECONFIG --nodes $MASTER01_IP --talosconfig=$TALOSCONFIG
```
#### make sure kubeconfig file is not uploaded to git
```sh
echo "kubeconfig" >> ./clusterconfig/.gitignore
```

# How to add new nodes
https://budimanjojo.github.io/talhelper/latest/guides/
update `talconfig.yaml`
run `talhelper genconfig`