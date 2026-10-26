# nullplatform-agent

![Version: 3.5.0](https://img.shields.io/badge/Version-3.5.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.32.1](https://img.shields.io/badge/AppVersion-2.32.1-informational?style=flat-square)

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
| podAnnotations | object | `{"cluster-autoscaler.kubernetes.io/safe-to-evict":"false","karpenter.sh/do-not-disrupt":"true","name":"nullplatform-agent"}` | Pod annotations. The defaults keep node autoscalers from evicting the agent to consolidate or scale down its node: an eviction kills the actions running on it (a deploy fails mid-way and leaves its resources behind). Each autoscaler reads its own key and ignores the other, and a cluster without them ignores both: `karpenter.sh/do-not-disrupt` for Karpenter (EKS Auto Mode, AKS node auto-provisioning) and `cluster-autoscaler.kubernetes.io/safe-to-evict` for Cluster Autoscaler (EKS managed node groups, AKS, GKE). With Karpenter the agent's node is then never consolidated or expired; give the NodePool a `terminationGracePeriod` if its nodes must still rotate. |
| podDisruptionBudget | object | `{"enabled":false}` | Optional PodDisruptionBudget for the agent. Off by default: with a single replica a budget that allows no eviction blocks node drains and cluster upgrades, so the chart refuses `maxUnavailable: 0` and a `minAvailable` that is not below the replica count. Set either minAvailable or maxUnavailable; with neither, the budget uses maxUnavailable: 1. |
| podLabels.name | string | `"nullplatform-agent"` |  |
| podSecurityContext | object | `{}` |  |
| priorityClass.enabled | bool | `true` |  |
| priorityClass.value | int | `500000` |  |
| readinessProbe.httpGet.path | string | `"/health"` |  |
| readinessProbe.httpGet.port | int | `8080` |  |
| replicaCount | int | `1` |  |
| resources | object | `{"limits":{"memory":"1Gi"},"requests":{"cpu":"100m","memory":"256Mi"}}` | Agent container resources. From load tests on t3.medium nodes (64 secrets per deploy): the agent idles at 14-47Mi and, with the parameters-provider value cache, peaks under 143Mi and ~600m; without the cache it went past 2.29Gi and took its node down. The request reflects real use, and the 1Gi memory limit is the safety ceiling: an excess OOM-restarts the agent instead of starving the node. No CPU limit: the spikes are short (~600m for ~2s), and throttling the process that fills the cache delays every retrieve waiting on it. |
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
| shutdownDrainTimeoutSeconds | int | `90` | Seconds the agent waits on SIGTERM for the commands it is running to finish and report their result before it disconnects (NP_SHUTDOWN_DRAIN_TIMEOUT, agent >= 0.14.0). Commands still running after that are re-delivered by the platform to the next agent, so size it to your longest action (a start-blue-green takes ~70s). 0 disables the wait. A NP_SHUTDOWN_DRAIN_TIMEOUT in configuration.values takes precedence and skips the check against terminationGracePeriodSeconds. |
| startupProbe | object | `{"failureThreshold":30,"httpGet":{"path":"/health","port":8080},"periodSeconds":10}` | Holds off the liveness and readiness probes until the agent first answers /health, which it does only after cloning every command repo. Without it the liveness probe kills the container after ~30s on a slow clone and the pod restarts, re-cloning from scratch each time. The default allows up to 5 minutes. |
| statefulset.podManagementPolicy | string | `"OrderedReady"` |  |
| statefulset.serviceName | string | `"nullplatform-agent"` |  |
| statefulset.updateStrategy.type | string | `"RollingUpdate"` |  |
| statefulset.volumeClaimTemplates | list | `[]` |  |
| terminationGracePeriodSeconds | int | `120` | Seconds the agent gets to stop after SIGTERM before it is killed. It has to fit the shutdown drain plus the disconnect that follows, so the chart refuses a value that is not at least 10s above shutdownDrainTimeoutSeconds. |
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
| worker.defaults.resources.limits.cpu | string | `"1"` |  |
| worker.defaults.resources.limits.memory | string | `"2Gi"` |  |
| worker.defaults.resources.requests.cpu | string | `"100m"` |  |
| worker.defaults.resources.requests.memory | string | `"256Mi"` |  |
| worker.defaults.serviceAccount | string | `""` |  |
| worker.grpcPort | int | `50051` |  |
| worker.idleTTL | string | `""` |  |
| worker.namespace | string | `""` |  |
| worker.networkPolicy.create | bool | `false` |  |
| worker.patches | list | `[]` |  |
| worker.pins | list | `[]` |  |
| worker.rbac.create | bool | `false` |  |
| worker.rules | list | `[]` |  |
| worker.security | string | `"plaintext"` |  |
| workloadType | string | `"deployment"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
