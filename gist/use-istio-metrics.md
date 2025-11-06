# Complete Setup Guide: Istio Gateway Metrics with K8s Labels

This guide documents the complete setup for enriching Istio gateway metrics with Kubernetes service labels and response codes.

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Prerequisites](#prerequisites)
4. [Step 1: Deploy K8s Labels Exporter](#step-1-deploy-k8s-labels-exporter)
5. [Step 2: Configure Prometheus Recording Rules](#step-2-configure-prometheus-recording-rules)
6. [Step 3: Add Response Code to Metrics](#step-3-add-response-code-to-metrics)
7. [Step 4: Verification](#step-4-verification)
8. [Step 5: Example Queries](#step-5-example-queries)
9. [Troubleshooting](#troubleshooting)

---

## Overview

This solution provides:
- **Dynamic label enrichment** - Automatically adds K8s service labels to Istio metrics
- **No sidecar required** - Works with gateway-only Istio deployments
- **Zero dataplane overhead** - Enrichment happens in Prometheus via recording rules
- **Response code tracking** - Adds HTTP response codes to metrics for error rate calculations
- **Fully scalable** - Works for thousands of services without configuration changes

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Kubernetes Cluster                           │
│                                                                 │
│  ┌──────────────┐         ┌─────────────────┐                   │
│  │ K8s Services │────────▶│ K8s Labels      │                   │
│  │ (all labels) │ watch   │ Exporter        │                   │
│  └──────────────┘         │ (Python pod)    │                   │
│                           └────────┬────────┘                   │
│                                    │ exposes                    │
│                                    │ k8s_service_labels_info    │
│  ┌──────────────┐                  │                            │
│  │ Istio Gateway│──────┐           │                            │
│  │ (EnvoyFilter)│      │           │                            │
│  └──────────────┘      │ metrics   │                            │
│                        │ w/        │                            │
│                        │ response  │                            │
│                        │ _code     │                            │
│                        │           │                            │
│                        ▼           ▼                            │
│                  ┌─────────────────────────┐                    │
│                  │   Prometheus            │                    │
│                  │   - Scrapes both        │                    │
│                  │   - Recording rules     │                    │
│                  │   - Joins metrics       │                    │
│                  └──────────┬──────────────┘                    │
│                             │                                   │
│                             ▼                                   │
│                  ┌─────────────────────────┐                    │
│                  │ Enriched Metrics:       │                    │
│                  │ - istio_requests_total  │                    │
│                  │   _enriched             │                    │
│                  │ - All K8s labels        │                    │
│                  │ - response_code         │                    │
│                  └─────────────────────────┘                    │
└─────────────────────────────────────────────────────────────────┘
```

**How it works:**

1. **K8s Labels Exporter** watches all Kubernetes Services via K8s API
2. **Exports service labels** as `k8s_service_labels_info` metric to Prometheus
3. **Prometheus scrapes** both Istio gateway metrics and exporter metrics
4. **Recording rules** join Istio metrics with K8s labels every 15 seconds
5. **EnvoyFilter** adds `response_code` dimension to Istio metrics
6. **Result**: Enriched metrics with all K8s labels + response codes available for queries

## Prerequisites

- Kubernetes cluster with Istio installed (gateway-only or mesh)
- Prometheus installed and configured to scrape Istio metrics
- `kubectl` configured to access your cluster
- Istio Gateway API gateway deployed

---

## Step 1: Deploy K8s Labels Exporter

The K8s Labels Exporter watches all Kubernetes services and exports their labels as Prometheus metrics.

### 1.1 Create the Exporter Deployment

Save the following YAML and apply it:

```yaml
---
# ConfigMap with the Python script
apiVersion: v1
kind: ConfigMap
metadata:
  name: k8s-labels-exporter-script
  namespace: prometheus
data:
  exporter.py: |
    #!/usr/bin/env python3
    """
    Kubernetes Labels Exporter for Prometheus
    Dynamically watches all K8s Services and Pods and exports their labels as Prometheus metrics
    """

    import time
    import logging
    from prometheus_client import start_http_server, Info, REGISTRY
    from kubernetes import client, config, watch
    import threading

    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    logger = logging.getLogger(__name__)

    class LabelsExporter:
        def __init__(self):
            self.service_info = Info('k8s_service_labels', 'Kubernetes service labels', ['service', 'namespace'])
            self.pod_info = Info('k8s_pod_labels', 'Kubernetes pod labels', ['pod', 'namespace'])
            self.services = {}
            self.pods = {}
            self.lock = threading.RLock()

        def update_service(self, name, namespace, labels):
            with self.lock:
                key = f"{namespace}/{name}"
                self.services[key] = {
                    'service': name,
                    'namespace': namespace,
                    'labels': labels or {}
                }

                # Create labels dict for prometheus
                prom_labels = {}
                for label_key, label_value in (labels or {}).items():
                    # Skip 'namespace' label to avoid conflict with the metric's namespace dimension
                    if label_key == 'namespace':
                        continue
                    # Sanitize label names for prometheus
                    safe_key = label_key.replace('.', '_').replace('-', '_').replace('/', '_')
                    prom_labels[safe_key] = str(label_value)

                # Set the info metric
                self.service_info.labels(service=name, namespace=namespace).info(prom_labels)
                logger.info(f"Updated service {key} with {len(labels or {})} labels")

        def delete_service(self, name, namespace):
            with self.lock:
                key = f"{namespace}/{name}"
                if key in self.services:
                    del self.services[key]
                    logger.info(f"Deleted service {key}")

        def update_pod(self, name, namespace, labels, pod_ip=None):
            with self.lock:
                key = f"{namespace}/{name}"
                self.pods[key] = {
                    'pod': name,
                    'namespace': namespace,
                    'labels': labels or {},
                    'pod_ip': pod_ip
                }

                # Create labels dict for prometheus
                prom_labels = {}
                for label_key, label_value in (labels or {}).items():
                    # Skip 'namespace' label to avoid conflict with the metric's namespace dimension
                    if label_key == 'namespace':
                        continue
                    # Sanitize label names for prometheus
                    safe_key = label_key.replace('.', '_').replace('-', '_').replace('/', '_')
                    prom_labels[safe_key] = str(label_value)

                # Add pod_ip if available
                if pod_ip:
                    prom_labels['pod_ip'] = pod_ip

                # Set the info metric
                self.pod_info.labels(pod=name, namespace=namespace).info(prom_labels)
                logger.info(f"Updated pod {key} with {len(labels or {})} labels and IP {pod_ip}")

        def delete_pod(self, name, namespace):
            with self.lock:
                key = f"{namespace}/{name}"
                if key in self.pods:
                    del self.pods[key]
                    logger.info(f"Deleted pod {key}")

    def watch_services(exporter):
        """Watch all Kubernetes Services and update exporter"""
        try:
            config.load_incluster_config()
            logger.info("Loaded in-cluster config for services")
        except:
            config.load_kube_config()
            logger.info("Loaded kube config for services")

        v1 = client.CoreV1Api()
        w = watch.Watch()

        logger.info("Starting service watcher...")

        while True:
            try:
                for event in w.stream(v1.list_service_for_all_namespaces, timeout_seconds=0):
                    service = event['object']
                    event_type = event['type']

                    name = service.metadata.name
                    namespace = service.metadata.namespace
                    labels = service.metadata.labels

                    if event_type in ['ADDED', 'MODIFIED']:
                        exporter.update_service(name, namespace, labels)
                    elif event_type == 'DELETED':
                        exporter.delete_service(name, namespace)

            except Exception as e:
                logger.error(f"Service watch error: {e}")
                time.sleep(5)

    def watch_pods(exporter):
        """Watch all Kubernetes Pods and update exporter"""
        try:
            config.load_incluster_config()
            logger.info("Loaded in-cluster config for pods")
        except:
            config.load_kube_config()
            logger.info("Loaded kube config for pods")

        v1 = client.CoreV1Api()
        w = watch.Watch()

        logger.info("Starting pod watcher...")

        while True:
            try:
                for event in w.stream(v1.list_pod_for_all_namespaces, timeout_seconds=0):
                    pod = event['object']
                    event_type = event['type']

                    name = pod.metadata.name
                    namespace = pod.metadata.namespace
                    labels = pod.metadata.labels
                    pod_ip = pod.status.pod_ip if pod.status else None

                    if event_type in ['ADDED', 'MODIFIED']:
                        exporter.update_pod(name, namespace, labels, pod_ip)
                    elif event_type == 'DELETED':
                        exporter.delete_pod(name, namespace)

            except Exception as e:
                logger.error(f"Pod watch error: {e}")
                time.sleep(5)

    def main():
        port = 9101

        # Start Prometheus metrics server
        start_http_server(port)
        logger.info(f"Metrics server listening on port {port}")
        logger.info(f"Endpoint: http://0.0.0.0:{port}/metrics")

        # Create exporter
        exporter = LabelsExporter()

        # Start watcher threads
        service_watcher = threading.Thread(target=watch_services, args=(exporter,), daemon=True)
        service_watcher.start()

        pod_watcher = threading.Thread(target=watch_pods, args=(exporter,), daemon=True)
        pod_watcher.start()

        # Keep alive
        try:
            while True:
                time.sleep(60)
        except KeyboardInterrupt:
            logger.info("Shutting down...")

    if __name__ == '__main__':
        main()
---
# ServiceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: k8s-labels-exporter
  namespace: prometheus
---
# ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: k8s-labels-exporter
rules:
- apiGroups: [""]
  resources: ["services", "pods"]
  verbs: ["get", "list", "watch"]
---
# ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: k8s-labels-exporter
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: k8s-labels-exporter
subjects:
- kind: ServiceAccount
  name: k8s-labels-exporter
  namespace: prometheus
---
# Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: k8s-labels-exporter
  namespace: prometheus
  labels:
    app: k8s-labels-exporter
spec:
  replicas: 1
  selector:
    matchLabels:
      app: k8s-labels-exporter
  template:
    metadata:
      labels:
        app: k8s-labels-exporter
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "9101"
        prometheus.io/path: "/metrics"
    spec:
      serviceAccountName: k8s-labels-exporter
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        runAsGroup: 1000
        fsGroup: 1000
      containers:
      - name: exporter
        image: python:3.11-slim
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: false
          capabilities:
            drop:
            - ALL
        env:
        - name: HOME
          value: /tmp
        command:
        - /bin/sh
        - -c
        - |
          pip install --user --no-cache-dir prometheus-client==0.19.0 kubernetes==28.1.0 && \
          python /app/exporter.py
        ports:
        - containerPort: 9101
          name: metrics
        volumeMounts:
        - name: script
          mountPath: /app
        resources:
          requests:
            cpu: 50m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
        livenessProbe:
          httpGet:
            path: /metrics
            port: 9101
          initialDelaySeconds: 30
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /metrics
            port: 9101
          initialDelaySeconds: 20
          periodSeconds: 10
      volumes:
      - name: script
        configMap:
          name: k8s-labels-exporter-script
---
# Service
apiVersion: v1
kind: Service
metadata:
  name: k8s-labels-exporter
  namespace: prometheus
  labels:
    app: k8s-labels-exporter
spec:
  type: ClusterIP
  ports:
  - port: 9101
    targetPort: 9101
    protocol: TCP
    name: metrics
  selector:
    app: k8s-labels-exporter
```

**Apply the configuration:**

```bash
kubectl apply -f k8s-labels-exporter-configmap.yaml
```

### 1.2 Wait for Deployment

```bash
kubectl wait --for=condition=ready pod -l app=k8s-labels-exporter -n default --timeout=60s
```

### 1.3 Verify Exporter is Running

```bash
# Check pod status
kubectl get pods -n default -l app=k8s-labels-exporter

# Check logs
kubectl logs -n default -l app=k8s-labels-exporter -f
```

**Expected output:**
```
INFO - Loaded in-cluster config
INFO - Starting service watcher...
INFO - Metrics server listening on port 9101
INFO - Updated nullplatform/d-1058242870-2068649195 with 13 labels
```

### 1.4 Test Metrics Endpoint

```bash
# Port-forward to exporter
kubectl port-forward -n default svc/k8s-labels-exporter 9101:9101 &

# Check metrics
curl http://localhost:9101/metrics | grep k8s_service_labels_info

# Kill port-forward
pkill -f "port-forward.*k8s-labels"
```

**Expected output:**
```
k8s_service_labels_info{service="d-1058242870-2068649195",namespace="nullplatform",account="gabriel-trainingingenia",account_id="1702691120",...} 1
```

---

## Step 2: Configure Prometheus Recording Rules

Recording rules join Istio metrics with K8s service labels dynamically.

### 2.1 Create Prometheus Recording Rules ConfigMap

**IMPORTANT:** This ConfigMap patches/updates your existing Prometheus server ConfigMap. Adjust the namespace and name to match your Prometheus installation.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-server
  namespace: prometheus
data:
  alerting_rules.yml: |
    {}
  alerts: |
    {}
  allow-snippet-annotations: 'false'
  prometheus.yml: |
    global:
      evaluation_interval: 1m
      scrape_interval: 1m
      scrape_timeout: 10s
    rule_files:
    - /etc/config/recording_rules.yml
    - /etc/config/alerting_rules.yml
    - /etc/config/rules
    - /etc/config/alerts
    scrape_configs:
    - job_name: prometheus
      static_configs:
      - targets:
        - localhost:9090
    - bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      job_name: kubernetes-apiservers
      kubernetes_sd_configs:
      - role: endpoints
      relabel_configs:
      - action: keep
        regex: default;kubernetes;https
        source_labels:
        - __meta_kubernetes_namespace
        - __meta_kubernetes_service_name
        - __meta_kubernetes_endpoint_port_name
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    - bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      job_name: kubernetes-nodes
      kubernetes_sd_configs:
      - role: node
      relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)
      - replacement: kubernetes.default.svc:443
        target_label: __address__
      - regex: (.+)
        replacement: /api/v1/nodes/$1/proxy/metrics
        source_labels:
        - __meta_kubernetes_node_name
        target_label: __metrics_path__
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    - bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      job_name: kubernetes-nodes-cadvisor
      kubernetes_sd_configs:
      - role: node
      relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)
      - replacement: kubernetes.default.svc:443
        target_label: __address__
      - regex: (.+)
        replacement: /api/v1/nodes/$1/proxy/metrics/cadvisor
        source_labels:
        - __meta_kubernetes_node_name
        target_label: __metrics_path__
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    - honor_labels: true
      job_name: kubernetes-service-endpoints
      kubernetes_sd_configs:
      - role: endpoints
      relabel_configs:
      - action: keep
        regex: true
        source_labels:
        - __meta_kubernetes_service_annotation_prometheus_io_scrape
      - action: drop
        regex: true
        source_labels:
        - __meta_kubernetes_service_annotation_prometheus_io_scrape_slow
      - action: replace
        regex: (https?)
        source_labels:
        - __meta_kubernetes_service_annotation_prometheus_io_scheme
        target_label: __scheme__
      - action: replace
        regex: (.+)
        source_labels:
        - __meta_kubernetes_service_annotation_prometheus_io_path
        target_label: __metrics_path__
      - action: replace
        regex: (.+?)(?::\d+)?;(\d+)
        replacement: $1:$2
        source_labels:
        - __address__
        - __meta_kubernetes_service_annotation_prometheus_io_port
        target_label: __address__
      - action: labelmap
        regex: __meta_kubernetes_service_annotation_prometheus_io_param_(.+)
        replacement: __param_$1
      - action: labelmap
        regex: __meta_kubernetes_service_label_(.+)
      - action: replace
        source_labels:
        - __meta_kubernetes_namespace
        target_label: namespace
      - action: replace
        source_labels:
        - __meta_kubernetes_service_name
        target_label: service
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_node_name
        target_label: node
    - honor_labels: true
      job_name: kubernetes-service-endpoints-slow
      kubernetes_sd_configs:
      - role: endpoints
      relabel_configs:
      - action: keep
        regex: true
        source_labels:
        - __meta_kubernetes_service_annotation_prometheus_io_scrape_slow
      - action: replace
        regex: (https?)
        source_labels:
        - __meta_kubernetes_service_annotation_prometheus_io_scheme
        target_label: __scheme__
      - action: replace
        regex: (.+)
        source_labels:
        - __meta_kubernetes_service_annotation_prometheus_io_path
        target_label: __metrics_path__
      - action: replace
        regex: (.+?)(?::\d+)?;(\d+)
        replacement: $1:$2
        source_labels:
        - __address__
        - __meta_kubernetes_service_annotation_prometheus_io_port
        target_label: __address__
      - action: labelmap
        regex: __meta_kubernetes_service_annotation_prometheus_io_param_(.+)
        replacement: __param_$1
      - action: labelmap
        regex: __meta_kubernetes_service_label_(.+)
      - action: replace
        source_labels:
        - __meta_kubernetes_namespace
        target_label: namespace
      - action: replace
        source_labels:
        - __meta_kubernetes_service_name
        target_label: service
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_node_name
        target_label: node
      scrape_interval: 5m
      scrape_timeout: 30s
    - honor_labels: true
      job_name: prometheus-pushgateway
      kubernetes_sd_configs:
      - role: service
      relabel_configs:
      - action: keep
        regex: pushgateway
        source_labels:
        - __meta_kubernetes_service_annotation_prometheus_io_probe
    - honor_labels: true
      job_name: kubernetes-services
      kubernetes_sd_configs:
      - role: service
      metrics_path: /probe
      params:
        module:
        - http_2xx
      relabel_configs:
      - action: keep
        regex: true
        source_labels:
        - __meta_kubernetes_service_annotation_prometheus_io_probe
      - source_labels:
        - __address__
        target_label: __param_target
      - replacement: blackbox
        target_label: __address__
      - source_labels:
        - __param_target
        target_label: instance
      - action: labelmap
        regex: __meta_kubernetes_service_label_(.+)
      - source_labels:
        - __meta_kubernetes_namespace
        target_label: namespace
      - source_labels:
        - __meta_kubernetes_service_name
        target_label: service
    - honor_labels: true
      job_name: kubernetes-pods
      kubernetes_sd_configs:
      - role: pod
      relabel_configs:
      - action: keep
        regex: true
        source_labels:
        - __meta_kubernetes_pod_annotation_prometheus_io_scrape
      - action: drop
        regex: true
        source_labels:
        - __meta_kubernetes_pod_annotation_prometheus_io_scrape_slow
      - action: replace
        regex: (https?)
        source_labels:
        - __meta_kubernetes_pod_annotation_prometheus_io_scheme
        target_label: __scheme__
      - action: replace
        regex: (.+)
        source_labels:
        - __meta_kubernetes_pod_annotation_prometheus_io_path
        target_label: __metrics_path__
      - action: replace
        regex: (\d+);(([A-Fa-f0-9]{1,4}::?){1,7}[A-Fa-f0-9]{1,4})
        replacement: '[$2]:$1'
        source_labels:
        - __meta_kubernetes_pod_annotation_prometheus_io_port
        - __meta_kubernetes_pod_ip
        target_label: __address__
      - action: replace
        regex: (\d+);((([0-9]+?)(\.|$)){4})
        replacement: $2:$1
        source_labels:
        - __meta_kubernetes_pod_annotation_prometheus_io_port
        - __meta_kubernetes_pod_ip
        target_label: __address__
      - action: labelmap
        regex: __meta_kubernetes_pod_annotation_prometheus_io_param_(.+)
        replacement: __param_$1
      - action: labelmap
        regex: __meta_kubernetes_pod_label_(.+)
      - action: replace
        source_labels:
        - __meta_kubernetes_namespace
        target_label: namespace
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_name
        target_label: pod
      - action: drop
        regex: Pending|Succeeded|Failed|Completed
        source_labels:
        - __meta_kubernetes_pod_phase
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_node_name
        target_label: node
    - honor_labels: true
      job_name: kubernetes-pods-slow
      kubernetes_sd_configs:
      - role: pod
      relabel_configs:
      - action: keep
        regex: true
        source_labels:
        - __meta_kubernetes_pod_annotation_prometheus_io_scrape_slow
      - action: replace
        regex: (https?)
        source_labels:
        - __meta_kubernetes_pod_annotation_prometheus_io_scheme
        target_label: __scheme__
      - action: replace
        regex: (.+)
        source_labels:
        - __meta_kubernetes_pod_annotation_prometheus_io_path
        target_label: __metrics_path__
      - action: replace
        regex: (\d+);(([A-Fa-f0-9]{1,4}::?){1,7}[A-Fa-f0-9]{1,4})
        replacement: '[$2]:$1'
        source_labels:
        - __meta_kubernetes_pod_annotation_prometheus_io_port
        - __meta_kubernetes_pod_ip
        target_label: __address__
      - action: replace
        regex: (\d+);((([0-9]+?)(\.|$)){4})
        replacement: $2:$1
        source_labels:
        - __meta_kubernetes_pod_annotation_prometheus_io_port
        - __meta_kubernetes_pod_ip
        target_label: __address__
      - action: labelmap
        regex: __meta_kubernetes_pod_annotation_prometheus_io_param_(.+)
        replacement: __param_$1
      - action: labelmap
        regex: __meta_kubernetes_pod_label_(.+)
      - action: replace
        source_labels:
        - __meta_kubernetes_namespace
        target_label: namespace
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_name
        target_label: pod
      - action: drop
        regex: Pending|Succeeded|Failed|Completed
        source_labels:
        - __meta_kubernetes_pod_phase
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_node_name
        target_label: node
      scrape_interval: 5m
      scrape_timeout: 30s
    alerting:
      alertmanagers:
      - kubernetes_sd_configs:
          - role: pod
        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        relabel_configs:
        - source_labels: [__meta_kubernetes_namespace]
          regex: prometheus
          action: keep
        - source_labels: [__meta_kubernetes_pod_label_app_kubernetes_io_instance]
          regex: kaas-prometheus
          action: keep
        - source_labels: [__meta_kubernetes_pod_label_app_kubernetes_io_name]
          regex: alertmanager
          action: keep
        - source_labels: [__meta_kubernetes_pod_container_port_number]
          regex: "9093"
          action: keep
  recording_rules.yml: |
    groups:
    - name: istio_enriched_with_k8s_labels
      interval: 15s
      rules:
      # Join Istio requests with K8s pod labels
      - record: np_requests_total_enriched
        expr: |
          label_replace(
            istio_requests_total{source_workload=~"gateway-public-istio|gateway-private-istio"},
            "destination_pod_ip_clean", "$1", "destination_pod_ip", "(.*):.*"
          )
          * on(destination_pod_ip_clean, destination_workload_namespace) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id, destination_pod)
          (
            max by (destination_pod_ip_clean, destination_workload_namespace, account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id, destination_pod) (
              label_replace(
                label_replace(
                  label_replace(
                    k8s_pod_labels_info{application_id!=""},
                    "destination_workload_namespace", "$1", "namespace", "(.*)"
                  ),
                  "destination_pod_ip_clean", "$1", "pod_ip", "(.*)"
                ),
                "destination_pod", "$1", "pod", "(.*)"
              )
            )
          )
      
      # Join Istio request duration buckets with K8s pod labels
      - record: np_request_duration_milliseconds_bucket_enriched
        expr: |
          label_replace(
            istio_request_duration_milliseconds_bucket{source_workload=~"gateway-public-istio|gateway-private-istio"},
            "destination_pod_ip_clean", "$1", "destination_pod_ip", "(.*):.*"
          )
          * on(destination_pod_ip_clean, destination_workload_namespace) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id, destination_pod)
          (
            max by (destination_pod_ip_clean, destination_workload_namespace, account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id, destination_pod) (
              label_replace(
                label_replace(
                  label_replace(
                    k8s_pod_labels_info{application_id!=""},
                    "destination_workload_namespace", "$1", "namespace", "(.*)"
                  ),
                  "destination_pod_ip_clean", "$1", "pod_ip", "(.*)"
                ),
                "destination_pod", "$1", "pod", "(.*)"
              )
            )
          )
      
      # Join Istio request duration sum with K8s pod labels
      - record: np_request_duration_milliseconds_sum_enriched
        expr: |
          label_replace(
            istio_request_duration_milliseconds_sum{source_workload=~"gateway-public-istio|gateway-private-istio"},
            "destination_pod_ip_clean", "$1", "destination_pod_ip", "(.*):.*"
          )
          * on(destination_pod_ip_clean, destination_workload_namespace) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id, destination_pod)
          (
            max by (destination_pod_ip_clean, destination_workload_namespace, account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id, destination_pod) (
              label_replace(
                label_replace(
                  label_replace(
                    k8s_pod_labels_info{application_id!=""},
                    "destination_workload_namespace", "$1", "namespace", "(.*)"
                  ),
                  "destination_pod_ip_clean", "$1", "pod_ip", "(.*)"
                ),
                "destination_pod", "$1", "pod", "(.*)"
              )
            )
          )
      
      # Join Istio request duration count with K8s pod labels
      - record: np_request_duration_milliseconds_count_enriched
        expr: |
          label_replace(
            istio_request_duration_milliseconds_count{source_workload=~"gateway-public-istio|gateway-private-istio"},
            "destination_pod_ip_clean", "$1", "destination_pod_ip", "(.*):.*"
          )
          * on(destination_pod_ip_clean, destination_workload_namespace) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id, destination_pod)
          (
            max by (destination_pod_ip_clean, destination_workload_namespace, account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id, destination_pod) (
              label_replace(
                label_replace(
                  label_replace(
                    k8s_pod_labels_info{application_id!=""},
                    "destination_workload_namespace", "$1", "namespace", "(.*)"
                  ),
                  "destination_pod_ip_clean", "$1", "pod_ip", "(.*)"
                ),
                "destination_pod", "$1", "pod", "(.*)"
              )
            )
          )

    - name: container_resources_enriched_with_k8s_labels
      interval: 15s
      rules:
      # CPU usage rate enriched with pod labels
      # This joins container metrics directly with k8s_pod_labels_info on namespace and pod
      - record: np_container_cpu_usage_rate_enriched
        expr: |
          rate(container_cpu_usage_seconds_total{container!="", container!="POD"}[5m])
          * on(namespace, pod) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id)
          k8s_pod_labels_info

      # CPU usage percentage (vs limits) enriched with pod labels
      - record: np_container_cpu_usage_percent_enriched
        expr: |
          (
            rate(container_cpu_usage_seconds_total{container!="", container!="POD"}[5m])
            / on(namespace, pod, container) group_left() (max by(namespace, pod, container, resource, unit) (kube_pod_container_resource_limits{resource="cpu"}))
            * 100
          )
          * on(namespace, pod) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id)
          k8s_pod_labels_info

      # Memory usage enriched with pod labels
      - record: np_container_memory_usage_bytes_enriched
        expr: |
          container_memory_usage_bytes{container!="", container!="POD"}
          * on(namespace, pod) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id)
          k8s_pod_labels_info

      # Memory usage percentage (vs limits) enriched with pod labels
      - record: np_container_memory_usage_percent_enriched
        expr: |
          (
            container_memory_usage_bytes{container!="", container!="POD"}
            / on(namespace, pod, container) group_left() (max by(namespace, pod, container, resource, unit) (kube_pod_container_resource_limits{resource="memory"}))
            * 100
          )
          * on(namespace, pod) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id)
          k8s_pod_labels_info

      # Memory working set enriched with pod labels
      - record: np_container_memory_working_set_bytes_enriched
        expr: |
          container_memory_working_set_bytes{container!="", container!="POD"}
          * on(namespace, pod) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id)
          k8s_pod_labels_info

      # Memory working set percentage (vs limits) enriched with pod labels
      - record: np_container_memory_working_set_percent_enriched
        expr: |
          (
            container_memory_working_set_bytes{container!="", container!="POD"}
            / on(namespace, pod, container) group_left() (max by(namespace, pod, container, resource, unit) (kube_pod_container_resource_limits{resource="memory"}))
            * 100
          )
          * on(namespace, pod) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id)
          k8s_pod_labels_info

    - name: pod_health_enriched_with_k8s_labels
      interval: 15s
      rules:
      # Pod readiness status enriched with pod labels
      - record: np_kube_pod_status_ready_enriched
        expr: |
          kube_pod_status_ready
          * on(namespace, pod) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id)
          k8s_pod_labels_info

      # Container ready status enriched with pod labels
      - record: np_kube_pod_container_status_ready_enriched
        expr: |
          kube_pod_container_status_ready
          * on(namespace, pod) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id)
          k8s_pod_labels_info

      # Container restarts enriched with pod labels
      - record: np_kube_pod_container_status_restarts_total_enriched
        expr: |
          kube_pod_container_status_restarts_total
          * on(namespace, pod) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id)
          k8s_pod_labels_info

      # Container running status enriched with pod labels
      - record: np_kube_pod_container_status_running_enriched
        expr: |
          kube_pod_container_status_running
          * on(namespace, pod) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id)
          k8s_pod_labels_info

      # Container waiting status enriched with pod labels
      - record: np_kube_pod_container_status_waiting_enriched
        expr: |
          kube_pod_container_status_waiting
          * on(namespace, pod) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id)
          k8s_pod_labels_info

      # Container terminated status enriched with pod labels
      - record: np_kube_pod_container_status_terminated_enriched
        expr: |
          kube_pod_container_status_terminated
          * on(namespace, pod) group_left(account, account_id, application, application_id, deployment_id, scope, scope_id, namespace_id)
          k8s_pod_labels_info
  rules: |
    {}
```

**Apply the recording rules:**

```bash
kubectl apply -f prometheus-recording-rules-dynamic.yaml
```

### 2.2 Restart Prometheus

```bash
kubectl rollout restart deployment -n default prometheus-server
kubectl rollout status deployment -n default prometheus-server
```

### 2.3 Verify Recording Rules

```bash
# Port-forward Prometheus
kubectl port-forward -n default svc/prometheus-server 9090:80 &

# Check if recording rules are loaded
curl -s http://localhost:9090/api/v1/rules | jq '.data.groups[] | select(.name=="istio_enriched_with_k8s_labels")'
```

### 2.4 Test Enriched Metrics

```bash
# Query enriched metric (wait ~30 seconds after restart)
curl -s 'http://localhost:9090/api/v1/query?query=istio_requests_total_enriched' | jq -r '.data.result[0].metric'
```

**Expected output should include:**
- `account`, `account_id`
- `application`, `application_id`
- `deployment_id`
- `scope`, `scope_id`
- `namespace_id`

---

## Step 3: Add Response Code to Metrics

By default, Istio metrics don't include HTTP response codes. We use Telemetry and EnvoyFilter to add this dimension.

### 3.1 Create Telemetry Configuration

```yaml
apiVersion: telemetry.istio.io/v1alpha1
kind: Telemetry
metadata:
  name: gateway-metrics-response-code
  namespace: gateways
spec:
  metrics:
  - providers:
    - name: prometheus
    overrides:
    - match:
        metric: REQUEST_COUNT
      tagOverrides:
        response_code:
          value: response.code | "unknown"
    - match:
        metric: REQUEST_DURATION
      tagOverrides:
        response_code:
          value: response.code | "unknown"
    - match:
        metric: REQUEST_SIZE
      tagOverrides:
        response_code:
          value: response.code | "unknown"
    - match:
        metric: RESPONSE_SIZE
      tagOverrides:
        response_code:
          value: response.code | "unknown"
```

**Apply:**

```bash
kubectl apply -f istio-telemetry-add-response-code.yaml
```

### 3.2 Create EnvoyFilter

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: stats-filter-response-code
  namespace: gateways
spec:
  workloadSelector:
    labels:
      gateway.networking.k8s.io/gateway-name: gateway-public
  configPatches:
  # Add response_code to istio metrics
  - applyTo: HTTP_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: "envoy.filters.network.http_connection_manager"
            subFilter:
              name: "istio.stats"
    patch:
      operation: MERGE
      value:
        typed_config:
          "@type": type.googleapis.com/stats.PluginConfig
          metrics:
          - dimensions:
              response_code: response.code
              destination_pod_ip: upstream.address
---
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: stats-filter-response-code-private
  namespace: gateways
spec:
  workloadSelector:
    labels:
      gateway.networking.k8s.io/gateway-name: gateway-private
  configPatches:
  # Add response_code to istio metrics
  - applyTo: HTTP_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: "envoy.filters.network.http_connection_manager"
            subFilter:
              name: "istio.stats"
    patch:
      operation: MERGE
      value:
        typed_config:
          "@type": type.googleapis.com/stats.PluginConfig
          metrics:
          - dimensions:
              response_code: response.code
              destination_pod_ip: upstream.address
```

**Apply:**

```bash
kubectl apply -f envoyfilter-add-response-code.yaml
```

### 3.3 Restart Gateway

**IMPORTANT:** Replace `gateway-public-istio` and namespace `gateways` with your gateway deployment name and namespace.

```bash
kubectl rollout restart deployment -n gateways gateway-public-istio
kubectl rollout status deployment -n gateways gateway-public-istio
```

### 3.4 Verify Response Code in Gateway Metrics

Wait ~30 seconds for metrics to generate, then:

```bash
# Get gateway pod name
POD=$(kubectl get pods -n gateways -l gateway.networking.k8s.io/gateway-name=gateway-public --no-headers | head -1 | awk '{print $1}')

# Check raw metrics from gateway
kubectl exec -n gateways $POD -- curl -s http://localhost:15020/stats/prometheus | grep 'istio_requests_total{' | grep response_code | head -3
```

**Expected output:**
```
istio_requests_total{...,response_code="200",...} 100
istio_requests_total{...,response_code="404",...} 50
```

### 3.5 Verify in Prometheus

Wait ~1 minute for Prometheus to scrape, then:

```bash
# Check enriched metrics include response_code
kubectl port-forward -n default svc/prometheus-server 9090:80 &

curl -s 'http://localhost:9090/api/v1/query?query=istio_requests_total_enriched' | jq -r '.data.result[0].metric.response_code'
```

**Expected output:** `200`, `404`, `500`, etc.

---

## Step 4: Verification

### 4.1 Complete Verification Script

```bash
#!/bin/bash

echo "=== Checking K8s Labels Exporter ==="
kubectl get pods -n default -l app=k8s-labels-exporter

echo ""
echo "=== Checking Exporter Metrics ==="
kubectl port-forward -n default svc/k8s-labels-exporter 9101:9101 >/dev/null 2>&1 &
PF_PID=$!
sleep 2
curl -s http://localhost:9101/metrics | grep k8s_service_labels_info | head -3
kill $PF_PID 2>/dev/null

echo ""
echo "=== Checking Prometheus ==="
kubectl get pods -n default -l app.kubernetes.io/name=prometheus-server

echo ""
echo "=== Checking Gateway ==="
kubectl get pods -n gateways -l gateway.networking.k8s.io/gateway-name=gateway-public

echo ""
echo "=== Checking Enriched Metrics ==="
kubectl port-forward -n default svc/prometheus-server 9090:80 >/dev/null 2>&1 &
PF_PID=$!
sleep 2
echo "Available labels:"
curl -s 'http://localhost:9090/api/v1/query?query=istio_requests_total_enriched' | jq -r '.data.result[0].metric | keys | .[]' | grep -E '(account|application|scope|response_code)'
kill $PF_PID 2>/dev/null

echo ""
echo "=== Setup Complete! ==="
```

### 4.2 Quick Test Queries

Access Prometheus UI:

```bash
kubectl port-forward -n default svc/prometheus-server 9090:80
```

Open browser: http://localhost:9090

Try these queries:
- `istio_requests_total_enriched`
- `sum(rate(istio_requests_total_enriched[5m])) by (account)`
- `sum(rate(istio_requests_total_enriched{response_code=~"[45].."}[5m])) by (application)`

---

## Step 5: Example Queries

### 5.1 Throughput Queries

**Request rate by account:**
```promql
sum(rate(istio_requests_total_enriched[5m])) by (account)
```

**Request rate by application:**
```promql
sum(rate(istio_requests_total_enriched[5m])) by (application)
```

**Request rate by scope:**
```promql
sum(rate(istio_requests_total_enriched[5m])) by (scope)
```

**Top 10 applications by traffic:**
```promql
topk(10, sum(rate(istio_requests_total_enriched[5m])) by (application))
```

**Requests for specific account:**
```promql
sum(rate(istio_requests_total_enriched{account="gabriel-trainingingenia"}[5m]))
```

**Multi-dimensional (account + application + scope):**
```promql
sum(rate(istio_requests_total_enriched[5m])) by (account, application, scope)
```

### 5.2 Latency Queries

**P50 latency by application:**
```promql
histogram_quantile(0.50,
  sum(rate(istio_request_duration_milliseconds_bucket_enriched[5m])) by (application, le)
)
```

**P95 latency by application:**
```promql
histogram_quantile(0.95,
  sum(rate(istio_request_duration_milliseconds_bucket_enriched[5m])) by (application, le)
)
```

**P99 latency by account:**
```promql
histogram_quantile(0.99,
  sum(rate(istio_request_duration_milliseconds_bucket_enriched[5m])) by (account, le)
)
```

**Average response time by scope:**
```promql
sum(rate(istio_request_duration_milliseconds_sum_enriched[5m])) by (scope)
/
sum(rate(istio_request_duration_milliseconds_count_enriched[5m])) by (scope)
```

**Top 10 slowest applications (P95):**
```promql
topk(10,
  histogram_quantile(0.95,
    sum(rate(istio_request_duration_milliseconds_bucket_enriched[5m])) by (application, le)
  )
)
```

### 5.3 Error Rate Queries

**Overall error rate (4xx + 5xx) by scope:**
```promql
sum(rate(istio_requests_total_enriched{response_code=~"[45].."}[5m])) by (scope)
/
sum(rate(istio_requests_total_enriched[5m])) by (scope)
* 100
```

**Overall error rate by account:**
```promql
sum(rate(istio_requests_total_enriched{response_code=~"[45].."}[5m])) by (account)
/
sum(rate(istio_requests_total_enriched[5m])) by (account)
* 100
```

**Overall error rate by application:**
```promql
sum(rate(istio_requests_total_enriched{response_code=~"[45].."}[5m])) by (application)
/
sum(rate(istio_requests_total_enriched[5m])) by (application)
* 100
```

**5xx error rate by application:**
```promql
sum(rate(istio_requests_total_enriched{response_code=~"5.."}[5m])) by (application)
/
sum(rate(istio_requests_total_enriched[5m])) by (application)
* 100
```

**4xx error rate by scope:**
```promql
sum(rate(istio_requests_total_enriched{response_code=~"4.."}[5m])) by (scope)
/
sum(rate(istio_requests_total_enriched[5m])) by (scope)
* 100
```

**Success rate (2xx) by application:**
```promql
sum(rate(istio_requests_total_enriched{response_code=~"2.."}[5m])) by (application)
/
sum(rate(istio_requests_total_enriched[5m])) by (application)
* 100
```

**Top 10 applications with highest error rate:**
```promql
topk(10,
  sum(rate(istio_requests_total_enriched{response_code=~"[45].."}[5m])) by (application)
  /
  sum(rate(istio_requests_total_enriched[5m])) by (application)
)
```

**Error count by response code:**
```promql
sum(rate(istio_requests_total_enriched{response_code=~"[45].."}[5m])) by (response_code)
```

**Error rate by application and response code:**
```promql
sum(rate(istio_requests_total_enriched{response_code=~"[45].."}[5m])) by (application, response_code)
```

### 5.4 Filtering Queries

**Specific account and application:**
```promql
sum(rate(istio_requests_total_enriched{
  account="gabriel-trainingingenia",
  application="test-geisbruch-training-2"
}[5m]))
```

**Specific scope with errors only:**
```promql
sum(rate(istio_requests_total_enriched{
  scope="test-2",
  response_code=~"[45].."
}[5m]))
```

**Multiple accounts:**
```promql
sum(rate(istio_requests_total_enriched{
  account=~"account1|account2|account3"
}[5m])) by (account)
```

### 5.5 Time-Series Comparisons

**Compare current vs 1 hour ago:**
```promql
sum(rate(istio_requests_total_enriched[5m])) by (application)
/
sum(rate(istio_requests_total_enriched[5m] offset 1h)) by (application)
```

**Error rate increase vs yesterday:**
```promql
(
  sum(rate(istio_requests_total_enriched{response_code=~"5.."}[5m])) by (application)
  -
  sum(rate(istio_requests_total_enriched{response_code=~"5.."}[5m] offset 24h)) by (application)
)
/
sum(rate(istio_requests_total_enriched[5m] offset 24h)) by (application)
* 100
```

### 5.6 RED Metrics (Rate, Errors, Duration)

**Rate:**
```promql
sum(rate(istio_requests_total_enriched[5m])) by (application)
```

**Errors:**
```promql
sum(rate(istio_requests_total_enriched{response_code=~"[45].."}[5m])) by (application)
/
sum(rate(istio_requests_total_enriched[5m])) by (application)
* 100
```

**Duration (P50, P95, P99):**
```promql
histogram_quantile(0.50, sum(rate(istio_request_duration_milliseconds_bucket_enriched[5m])) by (application, le))
histogram_quantile(0.95, sum(rate(istio_request_duration_milliseconds_bucket_enriched[5m])) by (application, le))
histogram_quantile(0.99, sum(rate(istio_request_duration_milliseconds_bucket_enriched[5m])) by (application, le))
```

---

## Troubleshooting

### Problem: Exporter Not Working

**Symptoms:** No `k8s_service_labels_info` metric in Prometheus

**Check pod status:**
```bash
kubectl get pods -n default -l app=k8s-labels-exporter
kubectl describe pod -n default -l app=k8s-labels-exporter
kubectl logs -n default -l app=k8s-labels-exporter
```

**Common causes:**
- RBAC permissions not applied: Re-apply the full YAML
- Pod crash loop: Check logs for Python errors
- Dependencies install failing: Check internet access in cluster

**Fix:**
```bash
kubectl delete deployment -n default k8s-labels-exporter
kubectl apply -f k8s-labels-exporter-configmap.yaml
```

### Problem: Enriched Metrics Not Appearing

**Symptoms:** `istio_requests_total_enriched` metric missing

**Check 1: Prometheus is scraping exporter**
```bash
kubectl port-forward -n default svc/prometheus-server 9090:80 &
curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | select(.labels.app=="k8s-labels-exporter")'
```

**Check 2: Base metric exists**
```bash
curl -s 'http://localhost:9090/api/v1/query?query=k8s_service_labels_info' | jq '.data.result | length'
# Should return > 0
```

**Check 3: Recording rules loaded**
```bash
curl -s http://localhost:9090/api/v1/rules | jq '.data.groups[] | select(.name=="istio_enriched_with_k8s_labels")'
```

**Check 4: Istio base metrics exist**
```bash
curl -s 'http://localhost:9090/api/v1/query?query=istio_requests_total' | jq '.data.result | length'
# Should return > 0
```

**Fix:**
```bash
# Reload recording rules
kubectl rollout restart deployment -n default prometheus-server
kubectl rollout status deployment -n default prometheus-server

# Wait 30 seconds, then check again
sleep 30
curl -s 'http://localhost:9090/api/v1/query?query=istio_requests_total_enriched' | jq '.data.result | length'
```

### Problem: Response Code Not Appearing

**Symptoms:** `response_code` label missing from metrics

**Check 1: EnvoyFilter applied**
```bash
kubectl get envoyfilter -n gateways stats-filter-response-code
kubectl get telemetry -n gateways gateway-metrics-response-code
```

**Check 2: Gateway has response_code**
```bash
POD=$(kubectl get pods -n gateways -l gateway.networking.k8s.io/gateway-name=gateway-public --no-headers | head -1 | awk '{print $1}')
kubectl exec -n gateways $POD -- curl -s http://localhost:15020/stats/prometheus | grep response_code | head -5
```

**If missing:**
```bash
# Re-apply and restart gateway
kubectl apply -f envoyfilter-add-response-code.yaml
kubectl apply -f istio-telemetry-add-response-code.yaml
kubectl rollout restart deployment -n gateways gateway-public-istio
kubectl rollout status deployment -n gateways gateway-public-istio

# Wait 1-2 minutes for metrics to generate
sleep 60
```

### Problem: Labels Not Matching / Join Failing

**Symptoms:** Enriched metrics exist but have no K8s labels

The join uses `destination_service_name` and `destination_workload_namespace`.

**Verify match:**
```bash
kubectl port-forward -n default svc/prometheus-server 9090:80 &

# Check Istio metric labels
echo "Istio metric:"
curl -s 'http://localhost:9090/api/v1/query?query=istio_requests_total' | jq -r '.data.result[0].metric | {destination_service_name, destination_workload_namespace}'

# Check exporter metric labels
echo "Exporter metric:"
curl -s 'http://localhost:9090/api/v1/query?query=k8s_service_labels_info' | jq -r '.data.result[0].metric | {service, namespace}'
```

These should match! If not:
- Check service names in K8s: `kubectl get svc -A`
- Verify Istio is reporting correct service names

### Problem: No Traffic / No Metrics

**Symptoms:** All configs applied but no metrics showing

**Generate traffic:**
```bash
# Get gateway external IP or port-forward
kubectl port-forward -n gateways svc/gateway-public-istio 8080:80 &

# Send requests
for i in {1..100}; do curl -s http://localhost:8080/ >/dev/null; done
```

Wait 30 seconds, then check metrics again.

---

## Adding New Services

No configuration needed! Just ensure your services have labels:

```bash
kubectl label service -n <namespace> <service-name> \
  account=<account> \
  application=<app> \
  scope=<scope> \
  custom_label=<value>
```

Within 15 seconds, labels will appear in enriched Istio metrics.

**Example:**
```bash
kubectl label service -n production my-api \
  account=customer-a \
  application=payment-api \
  scope=prod \
  team=payments
```

Then query:
```promql
sum(rate(istio_requests_total_enriched{application="payment-api"}[5m]))
```

---

## Performance Notes

- **Exporter**: ~50m CPU, ~128Mi RAM (single replica sufficient)
- **Recording Rules**: Computed every 15s, minimal Prometheus overhead
- **No per-request impact**: Enrichment happens in Prometheus, not in dataplane
- **Scales to thousands of services**: Dynamic watching of K8s API
- **Cardinality**: Each unique service + label combination creates one metric series

---

## Summary

You now have:

✅ **K8s Labels Exporter** - Watches all services, exports labels to Prometheus
✅ **Prometheus Recording Rules** - Joins Istio + K8s metrics every 15s
✅ **Response Code Tracking** - Via Telemetry + EnvoyFilter
✅ **Enriched Metrics** - `istio_requests_total_enriched` with all labels
✅ **Zero Dataplane Overhead** - All enrichment in Prometheus
✅ **Fully Dynamic** - Works for thousands of services automatically

**Available enriched metrics:**
- `istio_requests_total_enriched` - Request count with all labels + response_code
- `istio_request_duration_milliseconds_bucket_enriched` - Latency histogram
- `istio_request_duration_milliseconds_sum_enriched` - Latency sum
- `istio_request_duration_milliseconds_count_enriched` - Request count

**Available labels** (from K8s services):
- `account`, `account_id`
- `application`, `application_id`
- `deployment_id`
- `scope`, `scope_id`
- `namespace_id`
- `response_code` (200, 404, 500, etc.)
- Any custom labels on your services!

**Query directly in Prometheus for:**
- Throughput by account, application, scope
- Latency (P50, P95, P99) by any dimension
- Error rates (4xx, 5xx) by any dimension
- Multi-dimensional analysis
- Time-series comparisons

Enjoy your comprehensive Istio observability! 🎉
