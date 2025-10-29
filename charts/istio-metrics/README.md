# Nullplatform Istio Metrics Helm Chart

This Helm chart deploys components that enrich Istio gateway metrics with Kubernetes labels, providing enhanced observability for applications running behind Istio gateways.

## Overview

The istio-metrics chart:
- Deploys a K8s labels exporter that watches all services and pods
- Creates Prometheus recording rules to join Istio metrics with K8s labels
- Adds response code dimensions to Istio metrics via Telemetry and EnvoyFilter
- Optionally installs Prometheus if not already present

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Istio installed with gateway API
- Gateway pods labeled with `gateway.networking.k8s.io/gateway-name`
- Prometheus (can be installed via this chart)

## Installing the Chart

To install the chart with the release name `my-istio-metrics`:

```bash
helm repo add nullplatform https://nullplatform.github.io/helm-charts
helm install my-istio-metrics nullplatform/istio-metrics
```

### Installing with Prometheus

To install the chart with Prometheus included:

```bash
helm install my-istio-metrics nullplatform/istio-metrics \
  --set prometheus.enabled=true
```

### Using with existing Prometheus

If you already have Prometheus installed, ensure it's in the correct namespace:

```bash
helm install my-istio-metrics nullplatform/istio-metrics \
  --set prometheusNamespace=monitoring \
  --set gatewaysNamespace=istio-system
```

### Creating a Complete Prometheus ConfigMap

If you need to create a complete Prometheus ConfigMap with the recording rules included:

```bash
# Create Prometheus ConfigMap with default configuration
helm install my-istio-metrics nullplatform/istio-metrics \
  --set prometheusConfig.create=true \
  --set prometheusConfig.name=my-prometheus-server

# Create Prometheus ConfigMap with custom configuration
cat > my-prometheus-config.yaml <<EOF
prometheus.yml: |
  global:
    scrape_interval: 15s
  rule_files:
    - /etc/config/recording_rules.yml
  scrape_configs:
    - job_name: 'prometheus'
      static_configs:
        - targets: ['localhost:9090']
recording_rules.yml: |
  # Your custom recording rules here
EOF

helm install my-istio-metrics nullplatform/istio-metrics \
  --set prometheusConfig.create=true \
  --set prometheusConfig.name=my-prometheus-server \
  --set-file prometheusConfig.customConfig=my-prometheus-config.yaml
```

### Using Standalone Recording Rules

By default, the chart creates a standalone ConfigMap with just the recording rules:

```bash
# The recording rules ConfigMap will be created as 'prometheus-recording-rules'
# You can mount this in your existing Prometheus deployment

helm install my-istio-metrics nullplatform/istio-metrics \
  --set recordingRules.name=my-recording-rules
```

## Configuration

The following table lists the configurable parameters and their default values:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `prometheus.enabled` | Enable Prometheus installation | `false` |
| `prometheus.namespaceOverride` | Override namespace for Prometheus | `"prometheus"` |
| `prometheus.server.persistentVolume.size` | Prometheus PV size | `8Gi` |
| `prometheus.server.retention` | Prometheus data retention | `"15d"` |
| `prometheusNamespace` | Namespace where Prometheus is/will be installed | `"prometheus"` |
| `gatewaysNamespace` | Namespace where Istio gateways are installed | `"gateways"` |
| `gateway.public.name` | Name of the public gateway | `"gateway-public"` |
| `gateway.internal.enabled` | Enable metrics for internal gateway | `true` |
| `gateway.internal.name` | Name of the internal gateway | `"gateway-private"` |
| `exporter.enabled` | Enable K8s labels exporter | `true` |
| `exporter.image` | Image for the exporter | `"python:3.11-slim"` |
| `exporter.port` | Port for the exporter metrics | `9101` |
| `exporter.resources` | Resources for the exporter | See values.yaml |
| `recordingRules.enabled` | Enable Prometheus recording rules ConfigMap | `true` |
| `recordingRules.name` | Name of the recording rules ConfigMap | `"prometheus-recording-rules"` |
| `prometheusConfig.create` | Create complete Prometheus ConfigMap | `false` |
| `prometheusConfig.name` | Name of Prometheus ConfigMap to create | `"prometheus-server"` |
| `prometheusConfig.customConfig` | Custom ConfigMap data (replaces default) | `{}` |
| `prometheusConfig.additionalScrapeConfigs` | Additional scrape configs for default config | `""` |

## Enriched Metrics

After installation, the following enriched metrics will be available:

### Istio Gateway Metrics
- `np_requests_total_enriched` - Total requests with K8s labels
- `np_request_duration_milliseconds_bucket_enriched` - Request duration histogram
- `np_request_duration_milliseconds_sum_enriched` - Request duration sum
- `np_request_duration_milliseconds_count_enriched` - Request duration count

### Container Resource Metrics
- `np_container_cpu_usage_rate_enriched` - CPU usage rate
- `np_container_cpu_usage_percent_enriched` - CPU usage percentage
- `np_container_memory_usage_bytes_enriched` - Memory usage
- `np_container_memory_usage_percent_enriched` - Memory usage percentage
- `np_container_restarts_enriched` - Container restart count

### Pod Status Metrics
- `np_pod_ready_enriched` - Pod ready status
- `np_pod_phase_enriched` - Pod phase (Running, Pending, etc.)

All metrics include these K8s labels:
- `account`, `account_id`
- `application`, `application_id`
- `deployment_id`
- `scope`, `scope_id`
- `namespace_id`

## Verifying the Installation

1. Check the K8s labels exporter:
```bash
kubectl get deployment k8s-labels-exporter -n prometheus
kubectl logs -n prometheus deployment/k8s-labels-exporter
```

2. Check the recording rules:
```bash
kubectl get configmap prometheus-recording-rules -n prometheus
```

3. Check Istio configurations:
```bash
kubectl get telemetry,envoyfilter -n gateways
```

4. Query enriched metrics in Prometheus:
```promql
np_requests_total_enriched{application_id!=""}
```

## Troubleshooting

### No enriched metrics appearing
1. Ensure pods have the required labels (especially `application_id`)
2. Check that the k8s-labels-exporter is running and scraping successfully
3. Verify Prometheus is scraping the exporter endpoint
4. Check Prometheus logs for recording rule evaluation errors

### Gateway metrics not enriched
1. Verify gateway pods have the label `gateway.networking.k8s.io/gateway-name`
2. Check that Telemetry and EnvoyFilter resources are created in the gateways namespace
3. Ensure Istio telemetry v2 is enabled

## Uninstalling the Chart

To uninstall/delete the deployment:

```bash
helm delete my-istio-metrics
```

This command removes all the Kubernetes components associated with the chart and deletes the release.