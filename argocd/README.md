<!--
@license
Copyright (c) rljson

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# argocd

ArgoCD in the namespace `argocd`, installed by Helm. `apps` holds the app
of apps.

| File              | Purpose                                                       |
| ----------------- | ------------------------------------------------------------- |
| `values.yaml`     | Values of the chart `argo/argo-cd`: accounts, RBAC, resources |
| `install.sh`      | `helm upgrade --install` with the pinned chart version        |
| `set-password.sh` | Sets the password of a personal account in `argocd-secret`    |
| `ui.sh`           | Port-forward of the UI to <https://localhost:8443>            |

Add an account: list it in `configs.cm` and `configs.rbac` of
`values.yaml`, run `install.sh`, then `set-password.sh <account>`.
