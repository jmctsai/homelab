export GITHUB_TOKEN=<token>
export GITHUB_USER=jmctsai
export HOMELAB_REPO=homelab
<!-- export HOMELAB_REPO=https://github.com/jmctsai/homelab.git -->
<!-- export HOMELAB_REPO=git@github.com:jmctsai/homelab.git -->

```
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=homelab \
  --branch=main \
  --path=./clusters/staging/ \
  --personal
```

DEBUG flux deployment:
- flux logs
- flux events

TODO:
Flux Docs/Guides/Sealed Secrets