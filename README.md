<!--
@license
Copyright (c) rljson

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# cars-deployment

English | [Deutsch](README.de.md)

What runs in the Kubernetes cluster of the cars application, an example
app built on Rljson: manifests, Helm charts and the ArgoCD applications
that keep the cluster in sync with this repo.

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
| `k8s/base`    | Plain manifests, applied by hand before ArgoCD runs                              |
| `k8s/demo`    | Changes of the environment `demo` to the manifests in `k8s/base`                 |
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

## Limitations

- No CI: an operator builds images and changes tags by hand
- One environment only, `demo`

## Status

Structure only; no workload is described yet.
