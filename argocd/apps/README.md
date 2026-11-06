<!--
@license
Copyright (c) rljson

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# argocd/apps

App of apps: `root.yaml` points ArgoCD to this folder of `main`; one
application per workload and environment, e.g. `cars-ui-demo.yaml`, with
auto-sync, prune and self-heal. Each one renders `charts/<workload>` with
`values.yaml`, `<environment>-values.yaml` and `image-tag.yaml`, the last
one wins.

`root.yaml` is applied once by hand and not synced by itself:

```bash
kubectl apply -n argocd -f argocd/apps/root.yaml
```
