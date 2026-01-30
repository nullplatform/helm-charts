<h2 align="center">
    <a href="https://httpie.io" target="blank_">
        <img height="100" alt="nullplatform" src="https://nullplatform.com/favicon/android-chrome-192x192.png" />
    </a>
    <br>
    <br>
    Helm Charts Repository
    <br>
</h2>

Welcome to the Helm Charts repository for nullplatform. This repository hosts packaged Helm charts and serves them via GitHub Pages.

## Charts

This repository contains the following charts:

| Chart | Description | Version |
|------|-------------|---------|
| istio-metrics | Nullplatform Istio metrics enrichment for Kubernetes applications | 1.3.0 |
| nullplatform-agent | Agent used to interact with services, scopes and telemetry inside a cluster | 2.34.0 |
| nullplatform-base | A Helm chart for deploying the nullplatform base dependencies applications using Kubernetes | 2.34.0 |
| nullplatform-cert-manager-config | A Helm chart for cert-manager configurations | 2.34.0 |

## How to Use This Repository

### 1. Add Helm Repository

```bash
helm repo add nullplatform https://nullplatform.github.io/helm-charts
helm repo update
```

### 2. Search Charts in the Repository

```bash
helm search repo nullplatform
```

### 3. Install a Helm Chart

```bash
helm install <release-name> nullplatform/<chart-name> --version <chart-version>
```

### 4. Upgrade a Helm Chart

```bash
helm upgrade <release-name> nullplatform/<chart-name> --version <new-chart-version>
```

### 5. Remove a Helm Release

```bash
helm uninstall <release-name>
```

## Conventions

### Branch naming

Accepted formats:
- feature/<kebab-case>
- bugfix/<kebab-case>
- hotfix/<kebab-case>
- chore/<kebab-case>
- release/x.y.z

### Commit messages

This repository uses Conventional Commits.

Examples:
- feat: add autoscaling values
- fix: correct service name
- chore: update docs

## Tooling

Install yamllint for local YAML validation:

```bash
pip install yamllint
```
