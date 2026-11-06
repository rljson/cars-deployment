#!/usr/bin/env bash
# @license
# Copyright (c) rljson
#
# Use of this source code is governed by terms that can be
# found in the LICENSE file in the root of this package.

# Installs or upgrades ArgoCD in the namespace argocd of the current
# kubectl context, with the values of values.yaml.
#
# Usage: ./install.sh

set -euo pipefail
cd "$(dirname "$0")"

chart_version="10.14.0" # ArgoCD v3.6.1
namespace="argocd"

command -v helm >/dev/null || { echo "helm is missing: brew install helm" >&2; exit 1; }

context="$(kubectl config current-context)"
read -r -p "Install ArgoCD $chart_version into '$context'? [y/N] " answer
[ "$answer" = "y" ] || { echo "Aborted"; exit 1; }

helm repo add argo https://argoproj.github.io/argo-helm --force-update >/dev/null
helm upgrade --install argocd argo/argo-cd \
  --version "$chart_version" \
  --namespace "$namespace" --create-namespace \
  --values values.yaml \
  --wait

kubectl -n "$namespace" get pods
