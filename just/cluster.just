[doc("Bootstrap VMs and talos cluster")]
[working-directory('../infrastructure')]
cluster:
    just tf::init
    just tf::apply -auto-approve
    just cluster::create_cluster_config

[doc("Create talasconfig and kubeconfig")]
[working-directory('../infrastructure')]
create_cluster_config:
    terraform output -raw talosconfig > talosconfig.yaml
    terraform output -raw kubeconfig > kubeconfig.yaml