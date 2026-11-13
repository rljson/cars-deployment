<!--
@license
Copyright (c) rljson

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# cars-deployment

[English](README.md) | Deutsch

Was auf den Azure-Ressourcen der cars-Anwendung läuft, einer
Beispiel-App auf Rljson: die Container Apps ihrer Master und Clients.

## Motivation

- Was auf Azure läuft, ist in Git beschrieben, getrennt von allem anderen
- Die Azure-Ressourcen liegen in
  [cars-infra](https://github.com/rljson/cars-infra); eine Änderung an
  einem Image berührt sie nie

## Aufbau

Das Repo ist vorerst leer. Die Helm-Charts und die ArgoCD-Anwendungen des
Kubernetes-Clusters sind mit dem Cluster entfernt. Es folgen eine
Bicep-Vorlage `container-app`, eine Parameterdatei je Seite, Dienst und
Stufe (`<side>-<service>-<stage>.bicepparam`) und ein Node.js-Skript
`deploy.js`.

## Grenzen

- Keine CI: ein Betreiber rollt von Hand aus
- Nichts ist ausgerollt, bis die Stufen `dev`, `test` und `prod` bestehen
