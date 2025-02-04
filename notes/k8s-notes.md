DEBUG

kubectl - cli to communicate to API server, create/manage objects
deployment  - manage replicated application
ingress - API taht allow external access (outside cluster)
namespace - virtual clusteer to provision resource, scope for pod, service, deployment
node - worker machine
workload - object define deployment rules for pod (scheduling, scaling, upgrading)
pod - smallest object (1 or more container running together)
service - abstraction which define set of pods, make sure traffice can be directed to pods for workload
manifest - each of the .yaml files

manifest
vs.
helm - helm chart?


helm (declaratively)
- add helm repository that points to helm chart location
- `kind: GitRepository`

- release - release helm chart

patches?


CONTROL PLANE
https://www.talos.dev/v1.9/learn-more/control-plane/
3 or 5 control plan nodes
- if replacing not yet failed node - add new, then remove old


METALLB
loadbalancing + externalIP


MINIPC
3 Lenovo m720q with 32gb and 1TB NVMe. I run a 9 node talos cluster across them.