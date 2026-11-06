<!--
@license
Copyright (c) rljson

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# cars-deployment

English | [Deutsch](README.de.md)

What runs in the Kubernetes cluster of the cars application, an example
app built on Rljson: Helm charts and the ArgoCD applications that keep the cluster in sync with this repo.

## Motivation

- The cluster state is described in git; ArgoCD applies every merged
  change and reverts drift
- A new image reaches the cluster by a merged change of its
  `image-tag.yaml`, nothing else
- The Azure resources live in
  [cars-infra](https://github.com/rljson/cars-infra); ArgoCD watches only
  this repo

## Layout

| Folder        | Content                                                                          |
| ------------- | -------------------------------------------------------------------------------- |
| `charts`      | One Helm chart per workload: `values.yaml`, `demo-values.yaml`, `image-tag.yaml` |
| `argocd`      | Values of the ArgoCD installation                                                |
| `argocd/apps` | App of apps: `root.yaml` and one application per workload and environment        |

Three workloads run in the namespace `demo`, each on its own and reached
over HTTP only: `cars-ui`, the front end as static files, which forwards
`/api` to `cars-bff`, the backend for frontend, which asks `cars-master`,
the master data server.

## Usage

An image is built in the registry first; then its tag is changed in
`charts/<workload>/image-tag.yaml` by pull request. Once merged, ArgoCD
syncs it to the cluster.

```bash
az acr build --registry <registry> --image <workload>:<tag> .
```

### ArgoCD

ArgoCD runs in the namespace `argocd`. Install or upgrade it, set the
password of a personal account and open the UI on
<https://localhost:8443>:

```bash
argocd/install.sh
argocd/set-password.sh <account>
argocd/ui.sh
```

The app of apps is applied once by hand; from then on ArgoCD syncs every
application in `argocd/apps` of `main`, with auto-sync, prune and
self-heal:

```bash
kubectl apply -n argocd -f argocd/apps/root.yaml
```

The built-in `admin` is off; accounts and their roles are in
`argocd/values.yaml`. Single sign-on with Entra follows later.

## Limitations

- No CI: an operator builds images and changes tags by hand
- One environment only, `demo`

## Status

ArgoCD syncs `cars-ui`, `cars-bff` and `cars-master` into the namespace
`demo` from their charts. Nothing is applied by hand any more.
