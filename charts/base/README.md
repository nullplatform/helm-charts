# nullplatform-base

![Version: 2.33.1](https://img.shields.io/badge/Version-2.33.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.32.1](https://img.shields.io/badge/AppVersion-2.32.1-informational?style=flat-square)

A Helm chart for deploying the nullplatform base dependencies applications using Kubernetes

**Homepage:** <https://nullplatform.com>

## Installation

```bash
helm repo add nullplatform https://nullplatform.github.io/helm-charts
helm repo update
helm install nullplatform-base nullplatform/nullplatform-base
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Nullplatform | <support@nullplatform.com> |  |

## Source Code

* <https://github.com/nullplatform/helm-charts>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://kubernetes-sigs.github.io/metrics-server | metrics-server | ^3.12.0 |

## Configuration

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cloudwatch.accessLogs.enabled | bool | `false` |  |
| cloudwatch.customMetrics.enabled | bool | `true` |  |
| cloudwatch.enabled | bool | `false` |  |
| cloudwatch.logs.enabled | bool | `true` |  |
| cloudwatch.performanceMetrics.enabled | bool | `true` |  |
| cloudwatch.region | string | `"us-east-1"` |  |
| cloudwatch.retentionDays | int | `7` |  |
| controlPlane.agent.image | string | `"public.ecr.aws/nullplatform/controlplane-agent:latest"` |  |
| controlPlane.agent.resources.limits.cpu | string | `"100m"` |  |
| controlPlane.agent.resources.limits.memory | string | `"150Mi"` |  |
| controlPlane.agent.resources.requests.cpu | string | `"50m"` |  |
| controlPlane.agent.resources.requests.memory | string | `"100Mi"` |  |
| controlPlane.enabled | bool | `false` |  |
| customConf.configMapName | string | `""` |  |
| customConf.enabled | bool | `false` |  |
| envoy.filters.preserveExternalRequestId.enabled | bool | `false` |  |
| gateway.http.enabled | bool | `false` |  |
| gateway.internal.addresses | object | `{}` |  |
| gateway.internal.autoscaling.maxReplicas | int | `10` |  |
| gateway.internal.autoscaling.minReplicas | int | `2` |  |
| gateway.internal.aws.name | string | `"k8s-nullplatform-internal"` |  |
| gateway.internal.aws.securityGroups | string | `""` |  |
| gateway.internal.azure.networkSecurityGroup | string | `""` |  |
| gateway.internal.azure_load_balancer_subnet | string | `nil` |  |
| gateway.internal.enabled | bool | `true` |  |
| gateway.internal.gcp.firewallRule | string | `""` |  |
| gateway.internal.loadBalancerSourceRanges | list | `[]` |  |
| gateway.internal.loadBalancerType | string | `"internal"` |  |
| gateway.internal.name | string | `"gateway-private"` |  |
| gateway.internal.oci.loadBalancerType | string | `"lb"` |  |
| gateway.internal.oci.networkSecurityGroupIds | string | `""` |  |
| gateway.internal.oci.securityListManagementMode | string | `"None"` |  |
| gateway.internal.oci.shape | string | `"flexible"` |  |
| gateway.internal.oci.shapeFlexMax | string | `"100"` |  |
| gateway.internal.oci.shapeFlexMin | string | `"10"` |  |
| gateway.internal.oci.subnet | string | `""` |  |
| gateway.public.addresses | object | `{}` |  |
| gateway.public.autoscaling.maxReplicas | int | `10` |  |
| gateway.public.autoscaling.minReplicas | int | `2` |  |
| gateway.public.aws.name | string | `"k8s-nullplatform-internet-facing"` |  |
| gateway.public.aws.securityGroups | string | `""` |  |
| gateway.public.azure.networkSecurityGroup | string | `""` |  |
| gateway.public.gcp.firewallRule | string | `""` |  |
| gateway.public.loadBalancerSourceRanges | list | `[]` |  |
| gateway.public.loadBalancerType | string | `"external"` |  |
| gateway.public.name | string | `"gateway-public"` |  |
| gateway.public.oci.loadBalancerType | string | `"lb"` |  |
| gateway.public.oci.networkSecurityGroupIds | string | `""` |  |
| gateway.public.oci.securityListManagementMode | string | `"None"` |  |
| gateway.public.oci.shape | string | `"flexible"` |  |
| gateway.public.oci.shapeFlexMax | string | `"100"` |  |
| gateway.public.oci.shapeFlexMin | string | `"10"` |  |
| gateway.public.oci.subnet | string | `""` |  |
| gatewayAPI.crds.install | bool | `true` |  |
| gatewayAPI.enabled | bool | `true` |  |
| gateways.enabled | bool | `true` |  |
| global.awsRegion | string | `"us-east-1"` |  |
| global.installGatewayV2Crd | bool | `true` |  |
| global.provider | string | `"eks"` |  |
| imagePullSecrets.enabled | bool | `false` |  |
| imagePullSecrets.name | string | `"image-pull-secret-nullplatform"` |  |
| imagePullSecrets.password | string | `""` |  |
| imagePullSecrets.registry | string | `""` |  |
| imagePullSecrets.username | string | `""` |  |
| ingressControllers.private.domain | string | `""` |  |
| ingressControllers.private.enabled | bool | `true` |  |
| ingressControllers.private.name | string | `"internal"` |  |
| ingressControllers.private.scope | string | `"Internal"` |  |
| ingressControllers.public.domain | string | `""` |  |
| ingressControllers.public.enabled | bool | `true` |  |
| ingressControllers.public.name | string | `"internet-facing"` |  |
| ingressControllers.public.scope | string | `"External"` |  |
| logging.controller.image | string | `"public.ecr.aws/nullplatform/k8s-logs-controller:latest"` |  |
| logging.controller.resources.limits.cpu | string | `"700m"` |  |
| logging.controller.resources.limits.memory | string | `"300Mi"` |  |
| logging.controller.resources.requests.cpu | string | `"100m"` |  |
| logging.controller.resources.requests.memory | string | `"200Mi"` |  |
| logging.datadog.apiKey | string | `""` |  |
| logging.datadog.enabled | bool | `false` |  |
| logging.datadog.region | string | `""` |  |
| logging.dynatrace.apiKey | string | `""` |  |
| logging.dynatrace.enabled | bool | `false` |  |
| logging.dynatrace.environmentId | string | `""` |  |
| logging.enabled | bool | `true` |  |
| logging.gelf.enabled | bool | `false` |  |
| logging.gelf.host | string | `""` |  |
| logging.gelf.port | string | `""` |  |
| logging.loki.bearerToken | string | `""` |  |
| logging.loki.enabled | bool | `false` |  |
| logging.loki.host | string | `""` |  |
| logging.loki.matchRegex | string | `"container.*.application"` |  |
| logging.loki.password | string | `""` |  |
| logging.loki.port | string | `""` |  |
| logging.loki.user | string | `""` |  |
| logging.newrelic.enabled | bool | `false` |  |
| logging.newrelic.licenseKey | string | `""` |  |
| logging.newrelic.region | string | `""` |  |
| logging.prometheus.enabled | bool | `false` |  |
| logging.prometheus.exporterPort | int | `2021` |  |
| logging.streams.enabled | bool | `false` |  |
| logging.streams.mountPath | string | `"/etc/null-logs/streams-dd.conf"` |  |
| logging.streams.subPath | string | `"streams-dd.conf"` |  |
| logging.streamsConfigMapName | string | `"streams-dd-config"` |  |
| metricsServer.enabled | bool | `true` |  |
| namespaces.gateway | string | `"gateways"` |  |
| namespaces.nullplatformApplications | string | `"nullplatform"` |  |
| namespaces.nullplatformTools | string | `"nullplatform-tools"` |  |
| nullplatform.apiKey | string | `""` |  |
| nullplatform.secretName | string | `""` |  |
| tls.required | bool | `true` |  |
| tls.secretName | string | `"wildcard-tls"` |  |
| tls.secretPrivateName | string | `"wildcard-tls-internal"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
