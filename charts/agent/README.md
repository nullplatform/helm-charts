<h2 align="center">
    <a href="https://httpie.io" target="blank_">
        <img height="100" alt="nullplatform" src="https://nullplatform.com/favicon/android-chrome-192x192.png" />
    </a>
    <br>
    <br>
    Nullplatform Agent Helm Chart
    <br>
</h2>

This chart installs the **nullplatform agent** to operate on your behalf to operate the lifecycle of:
* Agent-backed scopes
* Services
* Actions

```bash
helm install nullplatform-agent nullplatform/nullplatform-agent \
  --set configuration.values.NP_API_KEY=$NP_API_KEY \
  --set configuration.values.TAGS="$AGENT_TAGS" \
  --set configuration.values.AGENT_REPO=$AGENT_REPO
```

## Configuration

This chart supports configuring the agent container, the runtime args it receives, and the Kubernetes resources around
it (service account, RBAC, scheduling, and optional persistence).

* Override `args` to change the command and map it up with secret-backed values
* Add any env variable needed to start the agent using `configuration.values`

### Secrets and init scripts

When `configuration.create` is `true`, the chart creates a Secret named
`${configuration.secretName}-${releaseName}` and mounts it into the pod with `envFrom`.

If `initScripts` is set, the chart creates a ConfigMap named `init-scripts-${releaseName}` and sets
`INIT_SCRIPTS_CONFIGMAP` on the container for the agent to pick up.

### Environment variables

The chart expects these values to be supplied (typically via `--set configuration.values.*`):

```bash
export NP_API_KEY=<your_api_key>
export AGENT_TAGS=<key:value[,key:value]>
export AGENT_REPO=<https://git-provider/org/repo.git#branch[,https://token@.../repo.git#branch]>
```

> `AGENT_REPO` supports a single repository or a comma-separated list. For private repos, include a token in the URL.

| Configuration Section | Key | Value | Purpose |
|----------------------|-----|-------|---------|
| **Basic Deployment** | `replicaCount` | `1` | Number of pod replicas to run |
| | `namespace` | `nullplatform-tools` | Kubernetes namespace for deployment |
| | `workloadType` | `deployment` | Workload type: `deployment` or `statefulset` |
| **StatefulSet** | `statefulset.serviceName` | `nullplatform-agent` | Headless service name for StatefulSet |
| | `statefulset.podManagementPolicy` | `OrderedReady` | Pod management policy |
| | `statefulset.updateStrategy.type` | `RollingUpdate` | Update strategy for StatefulSet |
| | `statefulset.volumeClaimTemplates` | `[]` | PVC templates for StatefulSet |
| **Application Arguments** | `args[0]` | `"--tags=$(TAGS)"` | Sets application tags from env → `configuration.values.TAGS` |
| | `args[1]` | `"--apikey=$(NP_API_KEY)"` | Provides API key → `configuration.values.NP_API_KEY` |
| | `args[2]` | `"--runtime=host"` | Runs the agent on the host runtime |
| | `args[3]` | `"--command-executor-env=NP_API_KEY=$(NP_API_KEY)"` | Passes API key to command executor |
| | `args[4]` | `"--command-executor-debug"` | Enables debug for command execution |
| | `args[5]` | `"--webserver-enabled"` | Enables built-in web server |
| | `args[6]` | `"--command-executor-git-command-repos $(AGENT_REPO)"` | Repo(s) for agent-backed scope execution → `configuration.values.AGENT_REPO` |
| **Secret Configuration** | `configuration.create` | `true` | Creates a Kubernetes secret |
| | `configuration.secretName` | `nullplatform-agent-secret` | Base name for the secret (suffixed with release name) |
| | `configuration.values.TAGS` | `""` | Agent tags |
| | `configuration.values.NP_LOG_LEVEL` | `DEBUG` | Sets logging level to debug |
| | `configuration.values.NP_API_KEY` | `""` | Nullplatform API key (to be filled) |
| | `configuration.values.AGENT_REPO` | `""` | Git repo(s) for agent-backed scopes |
| **Container Image** | `image.repository` | `public.ecr.aws/nullplatform/controlplane-agent` | Container image repository |
| | `image.pullPolicy` | `Always` | Always pull image |
| | `image.tag` | `latest` | Image tag |
| **Image Pull Secret** | `imagePullSecret.create` | `false` | Create a new image pull secret (set to `true` and provide credentials) |
| | `imagePullSecret.name` | _(unset)_ | Name of the image pull secret (when set, the pod will reference it) |
| | `imagePullSecret.registry` | `""` | Container registry URL (required if `create: true`) |
| | `imagePullSecret.username` | `""` | Username for registry authentication (required if `create: true`) |
| | `imagePullSecret.password` | `""` | Password for registry authentication (required if `create: true`) |
| **Service Account** | `serviceAccount.create` | `true` | Creates a service account |
| | `serviceAccount.automount` | `true` | Auto-mounts service account token |
| | `serviceAccount.name` | `nullplatform-agent` | Service account name |
| | `serviceAccount.clusterWide` | `true` | ClusterRole vs Role (cluster-wide access when `true`) |
| | `serviceAccount.role.rules` | Full access (`*`) | RBAC rules for the created role |
| **Pod Configuration** | `podAnnotations` | `{ name: nullplatform-agent }` | Pod annotations |
| | `podLabels` | `{ name: nullplatform-agent }` | Pod labels |
| **Resource Management** | `resources` | `{}` | Optional CPU/memory requests and limits |
| **Health Checks** | `livenessProbe.httpGet.path` | `/health` | Health check endpoint path → **Correlates with**: `args[5]` webserver |
| | `livenessProbe.httpGet.port` | `8080` | Health check port → **Correlates with**: `args[5]` webserver |
| | `readinessProbe.httpGet.path` | `/health` | Readiness check endpoint path → **Correlates with**: `args[5]` webserver |
| | `readinessProbe.httpGet.port` | `8080` | Readiness check port → **Correlates with**: `args[5]` webserver |
| **Auto Scaling** | `autoscaling.enabled` | `false` | Horizontal pod autoscaling disabled |
| | `autoscaling.minReplicas` | `1` | Minimum replicas when scaling |
| | `autoscaling.maxReplicas` | `2` | Maximum replicas when scaling |
| | `autoscaling.targetCPUUtilizationPercentage` | `80` | CPU threshold for scaling |
| **Scheduling** | `nodeSelector` | `{}` | Node selector constraints |
| **Pod Scheduling** | `tolerations[0]` | Node not ready toleration | Allows pod to run on not-ready nodes for 5 minutes |
| | `tolerations[1]` | Node unreachable toleration | Allows pod to run on unreachable nodes for 5 minutes |
| | `affinity` | `{}` | Pod affinity/anti-affinity rules |
| **Priority Class** | `priorityClass.enabled` | `true` | Create and use a PriorityClass |
| | `priorityClass.value` | `500000` | Priority value for the agent pods |
| **Init Containers** | `initContainers` | `[]` | Init containers run before the agent |
| **Init Scripts** | `initScripts` | `[]` | Inline shell scripts mounted via ConfigMap |
| **Storage** | `volumes` | `[]` | Additional volumes to mount |
| | `volumeMounts` | `[]` | Additional volume mounts |
| **Lifecycle** | `lifecycle.preStop.exec.command` | `["/bin/sh","-c","pid=$(pgrep -f agent) && kill -15 $pid && sleep 30"]` | Graceful shutdown hook |

## Argument and Configuration Correlations

### Environment Variable Flow:
- **`configuration.values`** → **Secret** → **Pod envFrom** → **`args` command-line arguments**

### Key Relationships:
1. **`NP_API_KEY`**: Defined in `configuration.values.NP_API_KEY` → Used in `args[1]` and `args[3]`
2. **`TAGS`**: Defined in `configuration.values.TAGS` → Used in `args[0]`
3. **Agent-backed scopes**: `AGENT_REPO` from `configuration.values` → Used in `args[6]`
4. **Web Server**: Enabled by `args[5]` → Health probes depend on this server running on port 8080
5. **Storage**: `volumes` + `volumeMounts` enable persistence for agent data or cloned repos
