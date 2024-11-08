<h2 align="center">
    <a href="https://httpie.io" target="blank_">
        <img height="100" alt="nullplatform" src="https://nullplatform.com/favicon/android-chrome-192x192.png" />
    </a>
    <br>
    <br>
    Nullplatform Cert-Manager config Helm Chart
    <br>
</h2>

To ensure we have letsencrypt certificates provisioned by (cert-manager)[]

```bash
helm install cert-manager-config nullplatform/cert-manager \
  --set azure.subscriptionId=1231234-1231-23 \
  --set azure.resourceGroupName=my-resource-group \
  --set azure.clientId=23432-23423-23423 \
  --set hostedZoneName=my-poc.nullapps.io 
```
## Configuration

The following table lists the configurable parameters of the Null chart and their default values.

| Parameter                   | Description                                               | 
|-----------------------------| --------------------------------------------------------- |
| `azure.subscriptionId`      | Azure subscriptionId where the hostedzone exists          |
| `azure.resourceGroupName`   | Azure resourceGroupName where the hostedzone exists       |
| `azure.clientId`            | Azure Client id to operate the hostedZone                 |
| `hostedZoneName`            | The domain name used to validate the certificate          |

For a complete list of configurable options, please refer to the `values.yaml` file.

## Notes

- Tipically the clientId is provided by the AKS kubelete identity created when provisioning the cluster
