# Nullplatform Helm Chart

## How to use it

### Basic installation

```bash
helm dependency update
helm package .
helm install nullplatform-chart ./nullplatform-chart-x.x.x.tgz \
  --set tls.secretName=www-tls \
  --set global.provider="oks/gke/eks/aks"
```

### If you use Datadog and Gelf

```bash
helm install nullplatform-chart ./nullplatform-chart-x.x.x.tgz \
  --set tls.secretName=www-tls \
  --set global.provider="oks/gke/eks/aks" \
  --set logging.gelf.enabled=true \
  --set logging.gelf.host=xxxx \
  --set logging.gelf.port=xxxx \
  --set logging.datadog.enabled=true \
  --set logging.datadog.apiKey=xxxx
```

### If you are installing it in AWS EKS

```bash
helm install nullplatform-chart ./nullplatform-chart-x.x.x.tgz \
  --set global.provider=eks \
  --set cloudwatch.enabled=true
```

### If you are installing it in GCP GKE and using Loki

```bash
helm install nullplatform-chart ./nullplatform-chart-x.x.x.tgz \
  --set tls.secretName=www-tls \
  --set global.provider=gke \
  --set logging.loki.enabled=true \
  --set logging.loki.host=xxx \
  --set logging.loki.port=xxx \
  --set logging.loki.bearerToken=xxx
```

## Configuration

The following table lists the configurable parameters of the Null chart and their default values.

| Parameter                   | Description                                               | Default                            |
|-----------------------------| --------------------------------------------------------- |------------------------------------|
| `global.provider`           | Kubernetes provider (options: "oks", "gke", "eks", "aks") | `"eks"`                            |
| `global.awsRegion`          | AWS region (applicable for EKS provider)                  | `"us-east-1"`                      |
| `tls.secretName`            | Name of the TLS secret                                    | `""`                               |
| `logging.gelf.enabled`      | Enable GELF logging                                       | `false`                            |
| `logging.loki.enabled`      | Enable Loki logging                                       | `false`                            |
| `logging.datadog.enabled`   | Enable Datadog logging                                    | `false`                            |
| `cloudwatch.enabled`        | Enable CloudWatch                                         | `false`                            |
| `metricsServer.enabled`     | Enable metrics server                                     | `true`                             |
| `gatewayAPI.enabled`        | Enable Gateway API                                        | `true`                             |
| `istio.enabled`             | Enable Istio                                              | `false`                            |
| `imagePullSecrets.enabled`  | Enable image pull secret                                  | `false`                            |
| `imagePullSecrets.name`     | Name of the image pull secret                             | `"image-pull-secret-nullplatform"` |
| `imagePullSecrets.registry` | Container registry URL for image pull secret              | `""`                               |
| `imagePullSecrets.username` | Username for container registry                           | `""`                               |
| `imagePullSecrets.password` | Password for container registry                           | `""`                               |

For a complete list of configurable options, please refer to the `values.yaml` file.

## Notes

- When using specific logging solutions (GELF, Loki, Datadog), make sure to set their respective `enabled` flag to `true` and provide the necessary configuration details.
- The `global.provider` must be set to one of the supported providers: "oks", "gke", "eks", or "aks".
- For EKS installations, you may want to enable CloudWatch by setting `cloudwatch.enabled=true`.
- Always provide a valid `tls.secretName` when configuring TLS.
- The `metrics-server` and `gateway-api` are enabled by default. Set their `enabled` flag to `false` if you don't want to use them.
