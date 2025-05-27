<h2 align="center">
    <a href="https://httpie.io" target="blank_">
        <img height="100" alt="nullplatform" src="https://nullplatform.com/favicon/android-chrome-192x192.png" />
    </a>
    <br>
    <br>
    Nullplatform Agent Helm Chart
    <br>
</h2>

This chart installs the Nullplatform agent to operate on your behalf to operate the lifecycle of:
* Custom Scopes
* Services
* Custom Actions

```bash
helm install nullplatform-agent nullplatform/agent \
  --set configuration.values.NP_API_KEY=$NP_API_KEY \
  --set configuration.values.TAGS="$AGENT_TAGS" \
  --set configuration.values.GITHUB_TOKEN=$GITHUB_TOKEN \
  --set configuration.values.GITHUB_REPO=$GITHUB_REPO
```

## Configuration

This chart supports to extend the agent into a different registry and change the command being executed:

* Override the `args` value to change the command and map it up with secrets mounted
* Add any env variable needed to start the agent using `configuration.values`

| Configuration Section | Key | Value | Purpose |
|----------------------|-----|-------|---------|
| **Basic Deployment** | `replicaCount` | `1` | Number of pod replicas to run |
| | `namespace` | `nullplatform-tools` | Kubernetes namespace for deployment |
| **Application Arguments** | `args[0]` | `"--tags=$(TAGS)"` | Sets application tags from environment variable → **References**: `configuration.values.TAGS` |
| | `args[1]` | `"--apikey=$(NP_API_KEY)"` | Provides API key for authentication → **References**: `configuration.values.NP_API_KEY` |
| | `args[2]` | `"--runtime=host"` | Configures runtime environment as host (static value) |
| | `args[3]` | `"--command-executor-env=NP_API_KEY=$(NP_API_KEY)"` | Passes API key to command executor → **References**: `configuration.values.NP_API_KEY` |
| | `args[4]` | `"--command-executor-debug"` | Enables debug mode for command executor (static value) |
| | `args[5]` | `"--webserver-enabled"` | Enables built-in web server (static value) |
| | `args[6]` | `"--command-executor-git-command-repos https://$(GITHUB_TOKEN)@$(GITHUB_REPO)#$(GITHUB_BRANCH)"` | Configures Git repository access → **References**: `configuration.values.GITHUB_TOKEN`, `configuration.values.GITHUB_REPO`, `configuration.values.GITHUB_BRANCH` |
| **Secret Configuration** | `configuration.create` | `true` | Creates a Kubernetes secret |
| | `configuration.secretName` | `nullplatform-agent-secret` | Name of the secret to create |
| | `configuration.values.TAGS` | `""` | Empty tags value (to be filled) |
| | `configuration.values.NP_LOG_LEVEL` | `DEBUG` | Sets logging level to debug |
| | `configuration.values.NP_API_KEY` | `""` | Nullplatform API key (to be filled) |
| | `configuration.values.GITHUB_USER` | `""` | GitHub username (to be filled) |
| | `configuration.values.GITHUB_TOKEN` | `""` | GitHub personal access token (to be filled) |
| | `configuration.values.GITHUB_REPO` | `""` | GitHub repository URL (to be filled) |
| | `configuration.values.GITHUB_BRANCH` | `main` | Git branch to use |
| **Container Image** | `image.repository` | `public.ecr.aws/nullplatform/controlplane-agent` | Container image repository |
| | `image.pullPolicy` | `Never` | Never pull image (use local) |
| | `image.tag` | `beta` | Image tag version |
| **Service Account** | `serviceAccount.create` | `true` | Creates a service account |
| | `serviceAccount.automount` | `true` | Auto-mounts service account token |
| | `serviceAccount.name` | `nullplatform-agent` | Service account name |
| | `serviceAccount.role.rules` | Full access (`*`) | Grants full cluster permissions |
| **Pod Configuration** | `podAnnotations.name` | `nullplatform-agent` | Pod annotation for identification |
| | `podLabels.name` | `nullplatform-agent` | Pod label for identification |
| **Resource Management** | `resources.requests.cpu` | `100m` | Minimum CPU requirement |
| | `resources.requests.memory` | `64Mi` | Minimum memory requirement |
| | `resources.limits.cpu` | `200m` | Maximum CPU limit |
| | `resources.limits.memory` | `128Mi` | Maximum memory limit |
| **Health Checks** | `livenessProbe.httpGet.path` | `/health` | Health check endpoint path → **Correlates with**: `args[5]` webserver |
| | `livenessProbe.httpGet.port` | `8080` | Health check port → **Correlates with**: `args[5]` webserver |
| | `readinessProbe.httpGet.path` | `/health` | Readiness check endpoint path → **Correlates with**: `args[5]` webserver |
| | `readinessProbe.httpGet.port` | `8080` | Readiness check port → **Correlates with**: `args[5]` webserver |
| **Auto Scaling** | `autoscaling.enabled` | `false` | Horizontal pod autoscaling disabled |
| | `autoscaling.minReplicas` | `1` | Minimum replicas when scaling |
| | `autoscaling.maxReplicas` | `2` | Maximum replicas when scaling |
| | `autoscaling.targetCPUUtilizationPercentage` | `80` | CPU threshold for scaling |
| **Pod Scheduling** | `tolerations[0]` | Node not ready toleration | Allows pod to run on not-ready nodes for 5 minutes |
| | `tolerations[1]` | Node unreachable toleration | Allows pod to run on unreachable nodes for 5 minutes |
| **Storage** | `volumes[0].name` | `repos` | Volume name for repository storage → **Correlates with**: `volumeMounts[0].name` and Git operations from `args[6]` |
| | `volumes[0].type` | `emptyDir` | Temporary volume type for Git repository cloning |
| | `volumeMounts[0].name` | `repos` | Mount the repos volume → **References**: `volumes[0].name` |
| | `volumeMounts[0].mountPath` | `/root/.np` | Mount path inside container for Nullplatform agent data and Git repos |

## Argument and Configuration Correlations

### Environment Variable Flow:
- **`configuration.values`** → **Pod Environment Variables** → **`args` command-line arguments**

### Key Relationships:
1. **`NP_API_KEY`**: Defined in `configuration.values.NP_API_KEY` → Used in `args[1]` and `args[3]`
2. **`TAGS`**: Defined in `configuration.values.TAGS` → Used in `args[0]`
3. **GitHub Integration**: `GITHUB_TOKEN`, `GITHUB_REPO`, `GITHUB_BRANCH` from `configuration.values` → Combined in `args[6]`
4. **Web Server**: Enabled by `args[5]` → Health probes depend on this server running on port 8080
5. **Storage**: `volumes[0]` creates storage → `volumeMounts[0]` mounts it → Git operations from `args[6]` use it
