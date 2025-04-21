<h2 align="center">
    <a href="https://httpie.io" target="blank_">
        <img height="100" alt="nullplatform" src="https://nullplatform.com/favicon/android-chrome-192x192.png" />
    </a>
    <br>
    <br>
    Nullplatform Base Helm Chart
    <br>
</h2>

To install the nullplatform base helm chart with custom values, you can use the following `helm install` command with specific `--set` parameters:

```bash
helm install my-release nullplatform/base \
  --set global.provider=eks \
  --set global.awsRegion=us-east-1 \
  --set tls.secretName=my-tls-secret \
  --set logging.datadog.enabled=true \
  --set logging.datadog.apiKey=my-datadog-api-key
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
| `imagePullSecrets.enabled`  | Enable image pull secret                                  | `false`                            |
| `imagePullSecrets.name`     | Name of the image pull secret                             | `"image-pull-secret-nullplatform"` |
| `imagePullSecrets.registry` | Container registry URL for image pull secret              | `""`                               |
| `imagePullSecrets.username` | Username for container registry                           | `""`                               |
| `imagePullSecrets.password` | Password for container registry                           | `""`                               |

For a complete list of configurable options, please refer to the `values.yaml` file.

## Uninstalling the chart

This Helm chart includes a protection mechanism that prevents deletion of the release. The protection works by using a pre-delete hook that runs indefinitely, blocking the Helm uninstall process. This protection is permanent - Once deployed, the Helm release cannot be deleted through normal Helm commands
This is by design to prevent unauthorized deletion of critical infrastructure
Only the Nullplatform team can safely remove this chart
When users attempt to run helm uninstall, they must check the job logs to see the message.


## Notes

- When using specific logging solutions (GELF, Loki, Datadog), make sure to set their respective `enabled` flag to `true` and provide the necessary configuration details.
- The `global.provider` must be set to one of the supported providers: "oks", "gke", "eks", or "aks".
- For EKS installations, you may want to enable CloudWatch by setting `cloudwatch.enabled=true`.
- Always provide a valid `tls.secretName` when configuring TLS.
- The `metrics-server` and `gateway-api` are enabled by default. Set their `enabled` flag to `false` if you don't want to use them.
- If you have `nullplatform` and/or `nullplatform-tools` already created run helm with `--no-hooks` option
