<!--
@license
Copyright (c) rljson

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# cars-deployment

English | [Deutsch](README.de.md)

What runs on the Azure resources of the cars application, an example app
built on Rljson: the container apps of its masters and clients.

## Motivation

- What runs on Azure is described in git, next to nothing else
- The Azure resources live in
  [cars-infra](https://github.com/rljson/cars-infra); a change to an image
  never touches them

## Layout

The repo is empty for now. The Helm charts and the ArgoCD applications of
the Kubernetes cluster are removed together with the cluster. A Bicep
template `container-app`, one parameter file per side, service and stage
(`<side>-<service>-<stage>.bicepparam`) and a Node.js script `deploy.js`
follow.

## Limitations

- No CI: an operator deploys by hand
- Nothing is deployed until the stages `dev`, `stage` and `prod` exist
