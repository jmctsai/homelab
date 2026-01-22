# FluxCD

## upgrade flux
brew upgrade flux

## install flux on own system for debug

```
curl -s https://fluxcd.io/install.sh | sudo bash
flux -v
```


## FluxCD Usage

```
flux check --pre
export GITHUB_TOKEN=<token>
flux bootstrap github \
  --owner=jmctsai \
  --repository=homelab \
  --branch=main \
  --path=./clusters/staging/ \
  --personal


export GITHUB_TOKEN=<token>
flux bootstrap github \
  --owner=jmctsai \
  --repository=homelab \
  --branch=main \
  --path=./clusters/cobalt/ \
  --personal
```

### FluxCD Debug
DEBUG flux deployment:
- flux logs
- flux events

TODO:
Flux Docs/Guides/Sealed Secrets