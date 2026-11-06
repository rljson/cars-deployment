<!--
@license
Copyright (c) rljson

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# cars-deployment

[English](README.md) | Deutsch

Was im Kubernetes-Cluster der Cars-Anwendung läuft, einer Beispiel-App auf
Rljson: Helm-Charts und die ArgoCD-Applications, die den Cluster mit diesem Repo synchron halten.

## Motivation

- Der Zustand des Clusters ist in Git beschrieben; ArgoCD wendet jede
  gemergte Änderung an und macht Abweichungen rückgängig
- Ein neues Image erreicht den Cluster durch eine gemergte Änderung seiner
  `image-tag.yaml`, durch nichts sonst
- Die Azure-Ressourcen liegen in
  [cars-infra](https://github.com/rljson/cars-infra); ArgoCD beobachtet nur
  dieses Repo

## Aufbau

| Ordner        | Inhalt                                                                          |
| ------------- | ------------------------------------------------------------------------------- |
| `charts`      | Ein Helm-Chart je Workload: `values.yaml`, `demo-values.yaml`, `image-tag.yaml` |
| `argocd`      | Werte der ArgoCD-Installation                                                   |
| `argocd/apps` | App of Apps: `root.yaml` und eine Application je Workload und Umgebung          |

Drei Workloads laufen im Namespace `demo`, jeder für sich und nur über
HTTP erreichbar: `cars-ui`, das Frontend als statische Dateien, leitet
`/api` an `cars-bff` weiter, das Backend for Frontend, das `cars-master`
fragt, den Stammdaten-Server.

## Verwendung

Zuerst wird ein Image in der Registry gebaut; dann wird sein Tag in
`charts/<workload>/image-tag.yaml` per Pull Request geändert. Nach dem
Merge synchronisiert ArgoCD ihn in den Cluster.

```bash
az acr build --registry <registry> --image <workload>:<tag> .
```

### ArgoCD

ArgoCD läuft im Namespace `argocd`. Installieren oder aktualisieren,
das Passwort eines persönlichen Kontos setzen und die Oberfläche auf
<https://localhost:8443> öffnen:

```bash
argocd/install.sh
argocd/set-password.sh <konto>
argocd/ui.sh
```

Die App of Apps wird einmal von Hand angewendet; danach synchronisiert
ArgoCD jede Application in `argocd/apps` von `main`, mit Auto-Sync, Prune
und Self-Heal:

```bash
kubectl apply -n argocd -f argocd/apps/root.yaml
```

Der eingebaute `admin` ist aus; Konten und ihre Rollen stehen in
`argocd/values.yaml`. Single Sign-on mit Entra folgt später.

## Grenzen

- Keine CI: ein Betreiber baut Images und ändert Tags von Hand
- Nur eine Umgebung, `demo`

## Stand

ArgoCD synchronisiert `cars-ui`, `cars-bff` und `cars-master` aus ihren
Charts in den Namespace `demo`. Nichts wird mehr von Hand angewendet.
