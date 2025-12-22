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
helm install cert-manager-config nullplatform/nullplatform-cert-manager-config \
  --set azure.enabled=true \
  --set azure.subscriptionID=1231234-1231-23 \
  --set azure.resourceGroupName=my-resource-group \
  --set azure.clientID=23432-23423-23423 \
  --set hostedZoneName=my-poc.nullapps.io \
  --set azure.secretKey=client-secret \
  --set azure.clientSecret="" \
  --set azure.tenantID="" \
  --namespace cert-manager
```

```bash
helm install cert-manager-config nullplatform/nullplatform-cert-manager-config \
  --set gcp.enabled=true \
  --set gcp.projectId=my-project \
  --set gcp.serviceAccountKey=my-key \
  --set hostedZoneName=my-poc.nullapps.io \
  --namespace cert-manager
```

```bash
helm install cert-manager-config nullplatform/nullplatform-cert-manager-config \
  --set route53.enabled=true \
  --set route53.region=us-east-1 \
  --set route53.role=arn:aws:iam::123456789012:role/cert-manager-role \
  --set route53.auth.kubernetes.serviceAccountRef.name=cert-manager \
  --set hostedZoneName=my-poc.nullapps.io \
  --namespace cert-manager
```

## Supported DNS providers

- Azure
- GCP
- AWS (Route53)
- Cloudflare

## Configuration

The following table lists the configurable parameters of the Null chart and their default values.

| Parameter                                       | Description                                               |
|-------------------------------------------------| --------------------------------------------------------- |
| `azure.enabled`                                 | Enable Azure resolution                                   |
| `azure.subscriptionId`                          | Azure subscriptionId where the hostedzone exists          |
| `azure.resourceGroupName`                       | Azure resourceGroupName where the hostedzone exists       |
| `azure.clientId`                                | Azure Client id to operate the hostedZone                 |
| `azure.tenantID`                                | Azure Tenant ID                                           |
| `azure.clientSecret`                            | Azure Client Secret                                       |
| `gcp.enabled`                                   | Enable GCP resolution                                     |
| `gcp.projectId`                                 | GCP Project where the hostedZone lives                    |
| `gcp.serviceAccountKey`                         | GCP Service Account Key                                   |
| `route53.enabled`                               | Enable AWS Route53 resolution                             |
| `route53.region`                                | AWS Region where Route53 hosted zone exists               |
| `route53.role`                                  | IAM Role ARN for cert-manager to assume                   |
| `route53.auth.kubernetes.serviceAccountRef.name`| Kubernetes ServiceAccount name for IRSA authentication    |
| `cloudflare.enabled`                            | Enable Cloudflare resolution                              |
| `cloudflare.apiToken`                           | Cloudflare API Token                                      |
| `hostedZoneName`                                | The domain name used to validate the certificate          |

For a complete list of configurable options, please refer to the `values.yaml` file.

## Notes

- Tipically the clientId is provided by the AKS kubelete identity created when provisioning the cluster
- For AWS (Route53), the chart uses IRSA (IAM Roles for Service Accounts) for authentication. Ensure your EKS cluster has IRSA enabled and the cert-manager ServiceAccount is annotated with the appropriate IAM role
