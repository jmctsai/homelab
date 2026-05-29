mod bootstrap 'just/bootstrap.just'
mod tf 'just/tf.just'

# With this `just` will give you a list of the modules.
[private]
default:
    just -l

export KUBECONFIG := justfile_directory() / "infrastructure/kubeconfig.yaml"
export TALOSCONFIG := justfile_directory() / "infrastructure/talosconfig.yaml"