# nullplatform-agent

![Version: 3.0.0](https://img.shields.io/badge/Version-3.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.32.1](https://img.shields.io/badge/AppVersion-2.32.1-informational?style=flat-square)

Agent used to interact with services, scopes and telemetry inside a cluster

**Homepage:** <https://nullplatform.com>

## Installation

```bash
helm repo add nullplatform https://nullplatform.github.io/helm-charts
helm repo update
helm install nullplatform-agent nullplatform/nullplatform-agent
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Nullplatform | <support@nullplatform.com> |  |

## Source Code

* <https://github.com/nullplatform/helm-charts>

## Configuration

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| args[0] | string | `"--tags=$(TAGS)"` |  |
| args[1] | string | `"--apikey=$(NP_API_KEY)"` |  |
| args[2] | string | `"--runtime=host"` |  |
| args[3] | string | `"--command-executor-env=NP_API_KEY=$(NP_API_KEY)"` |  |
| args[4] | string | `"--command-executor-debug"` |  |
| args[5] | string | `"--webserver-enabled"` |  |
| args[6] | string | `"--command-executor-git-command-repos $(AGENT_REPO)"` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `2` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| configuration.create | bool | `true` |  |
| configuration.secretName | string | `"nullplatform-agent-secret"` |  |
| configuration.values.AGENT_REPO | string | `""` |  |
| configuration.values.NP_API_KEY | string | `""` |  |
| configuration.values.NP_LOG_LEVEL | string | `"DEBUG"` |  |
| configuration.values.TAGS | string | `"gato:negro"` |  |
| fullnameOverride | string | `""` |  |
| github | object | `{"apps":[],"mountPath":"/etc/nullplatform/github-apps","secret":{"create":false,"name":""}}` | GitHub credentials for cloning the command repos: one set per GitHub organization, each with its own App ID and private key. Orgs not listed here keep using the credential embedded in their repo URL. |
| github.apps | list | `[]` | One entry per GitHub organization; empty disables GitHub App auth. Each entry takes `org`, `appId` and one key source: `privateKeySecretKey` (a file from the Secret), `privateKeySsmParameter` (AWS SSM, needs IRSA on the serviceAccount) or `privateKey` (inline PEM, requires `secret.create: true`). `installationId` is optional; when unset it is resolved from the org. |
| github.mountPath | string | `"/etc/nullplatform/github-apps"` | Read-only mount point for the PEM files inside the agent container. |
| github.secret.create | bool | `false` | Create the Secret holding the PEMs from `apps[].privateKey`. Dev only: the keys live in values.yaml. In production leave this false and point `secret.name` at an existing Secret. |
| github.secret.name | string | `""` | Existing Secret holding one PEM per org. Required when `create` is false and any org reads its key from a file. Defaults to "nullplatform-agent-github-apps-<release>" when `create` is true. |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"public.ecr.aws/nullplatform/controlplane-agent"` |  |
| image.tag | string | `"latest"` |  |
| imagePullSecret.create | bool | `false` |  |
| initContainers | list | `[]` |  |
| initScripts | list | `[]` |  |
| lifecycle.preStop.exec.command[0] | string | `"/bin/sh"` |  |
| lifecycle.preStop.exec.command[1] | string | `"-c"` |  |
| lifecycle.preStop.exec.command[2] | string | `"pid=$(pgrep -f agent) && kill -15 $pid && sleep 30"` |  |
| livenessProbe.httpGet.path | string | `"/health"` |  |
| livenessProbe.httpGet.port | int | `8080` |  |
| nameOverride | string | `""` |  |
| namespace | string | `"nullplatform-tools"` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations.name | string | `"nullplatform-agent"` |  |
| podLabels.name | string | `"nullplatform-agent"` |  |
| podSecurityContext | object | `{}` |  |
| priorityClass.enabled | bool | `true` |  |
| priorityClass.value | int | `500000` |  |
| readinessProbe.httpGet.path | string | `"/health"` |  |
| readinessProbe.httpGet.port | int | `8080` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.clusterWide | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `"nullplatform-agent"` |  |
| serviceAccount.role.rules[0].apiGroups[0] | string | `"*"` |  |
| serviceAccount.role.rules[0].apiGroups[1] | string | `""` |  |
| serviceAccount.role.rules[0].resources[0] | string | `"*"` |  |
| serviceAccount.role.rules[0].verbs[0] | string | `"*"` |  |
| statefulset.podManagementPolicy | string | `"OrderedReady"` |  |
| statefulset.serviceName | string | `"nullplatform-agent"` |  |
| statefulset.updateStrategy.type | string | `"RollingUpdate"` |  |
| statefulset.volumeClaimTemplates | list | `[]` |  |
| tolerations[0].effect | string | `"NoExecute"` |  |
| tolerations[0].key | string | `"node.kubernetes.io/not-ready"` |  |
| tolerations[0].operator | string | `"Exists"` |  |
| tolerations[0].tolerationSeconds | int | `300` |  |
| tolerations[1].effect | string | `"NoExecute"` |  |
| tolerations[1].key | string | `"node.kubernetes.io/unreachable"` |  |
| tolerations[1].operator | string | `"Exists"` |  |
| tolerations[1].tolerationSeconds | int | `300` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |
| worker.allowedRegistries | list | `[]` |  |
| worker.backend | string | `"kubernetes"` |  |
| worker.defaults.env | object | `{}` |  |
| worker.defaults.imagePullSecrets | list | `[]` |  |
| worker.defaults.labels | object | `{}` |  |
| worker.defaults.nodeSelector | object | `{}` |  |
| worker.defaults.resources.limits.cpu | string | `"500m"` |  |
| worker.defaults.resources.limits.memory | string | `"256Mi"` |  |
| worker.defaults.resources.requests.cpu | string | `"50m"` |  |
| worker.defaults.resources.requests.memory | string | `"64Mi"` |  |
| worker.defaults.serviceAccount | string | `""` |  |
| worker.grpcPort | int | `50051` |  |
| worker.idleTTL | string | `""` |  |
| worker.namespace | string | `""` |  |
| worker.networkPolicy.create | bool | `false` |  |
| worker.patches | list | `[]` |  |
| worker.pins | list | `[]` |  |
| worker.rbac.create | bool | `false` |  |
| worker.rules | list | `[]` |  |
| worker.security | string | `"insecure"` |  |
| workloadType | string | `"deployment"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
