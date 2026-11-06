#!/usr/bin/env bash
# @license
# Copyright (c) rljson
#
# Use of this source code is governed by terms that can be
# found in the LICENSE file in the root of this package.

# Opens the ArgoCD UI on https://localhost:8443 through a port-forward.
# The certificate is self-signed.
#
# Usage: ./ui.sh

set -euo pipefail
kubectl -n argocd port-forward svc/argocd-server 8443:443
