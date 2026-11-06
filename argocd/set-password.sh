#!/usr/bin/env bash
# @license
# Copyright (c) rljson
#
# Use of this source code is governed by terms that can be
# found in the LICENSE file in the root of this package.

# Sets the password of a personal ArgoCD account. The account must be
# listed in configs.cm of values.yaml. The password is asked for and
# stored as a bcrypt hash in the secret argocd-secret only.
#
# Usage: ./set-password.sh <account>

set -euo pipefail

account="${1:-}"
[ -n "$account" ] || { echo "Usage: ./set-password.sh <account>" >&2; exit 1; }
namespace="argocd"

read -r -s -p "New password for $account: " password; echo
read -r -s -p "Repeat: " repeat; echo
[ "$password" = "$repeat" ] || { echo "Passwords differ" >&2; exit 1; }
[ "${#password}" -ge 12 ] || { echo "At least 12 characters" >&2; exit 1; }

# Through stdin, so the password never shows up in the process list.
hash="$(printf '%s' "$password" | htpasswd -niBC 10 "" | tr -d ':\n' | sed 's/^\$2y/$2a/')"
mtime="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

kubectl -n "$namespace" patch secret argocd-secret --type merge -p \
  "{\"stringData\":{\"accounts.$account.password\":\"$hash\",\"accounts.$account.passwordMtime\":\"$mtime\"}}"

echo "Password of $account set"
