# FluxCD

install flux on own system for debug

```
curl -s https://fluxcd.io/install.sh | sudo bash
flux -v
```


## FluxCD Usage

```
export GITHUB_TOKEN=<token>
export GITHUB_USER=jmctsai
export HOMELAB_REPO=homelab

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=$HOMELAB_REPO \
  --branch=main \
  --path=./clusters/staging/ \
  --personal
```

### FluxCD Debug
DEBUG flux deployment:
- flux logs
- flux events

TODO:
Flux Docs/Guides/Sealed Secrets