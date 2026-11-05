<!--
@license
Copyright (c) rljson

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# argocd/apps

App of apps: `root.yaml` points ArgoCD to this folder; one application per
workload and environment, e.g. `cars-ui-demo.yaml`, with auto-sync, prune
and self-heal.
