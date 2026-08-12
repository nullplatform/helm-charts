{{/*
Expand the name of the chart.
*/}}
{{- define "agent.name" -}}
{{- default "nullplatform-agent" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "agent.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "agent.labels" -}}
helm.sh/chart: {{ include "agent.chart" . }}
{{ include "agent.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "agent.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "agent.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "agent.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the EXISTING Secret holding one GitHub App private key per org. The chart
never creates it: key material must be provisioned out of band (external-secrets,
Vault, SOPS, by hand) so a PEM never passes through Helm values. Validation
guarantees this is set whenever an org reads its key from a file.
*/}}
{{- define "agent.githubAppsSecretName" -}}
{{- .Values.githubApps.secret.name -}}
{{- end -}}

{{/*
Validate githubApps. Renders nothing; aborts the render with an actionable
message. This mirrors the agent's own boot-time validation, so a bad values file
fails at `helm template` instead of crash-looping a pod.
*/}}
{{- define "agent.githubAppsValidate" -}}
{{- if .Values.githubApps.enabled -}}
{{- if not .Values.githubApps.apps -}}
{{- fail "githubApps.enabled is true but githubApps.apps is empty: add one entry per GitHub org" -}}
{{- end -}}
{{- if .Values.githubApps.secret.create -}}
{{- fail "githubApps.secret.create is no longer supported: the chart never creates a Secret holding private keys. Provision the Secret out of band (external-secrets, Vault, SOPS) and reference it with githubApps.secret.name" -}}
{{- end -}}
{{- $secretName := .Values.githubApps.secret.name -}}
{{- $seen := dict -}}
{{- range $i, $app := .Values.githubApps.apps -}}
  {{- if not $app.org -}}
  {{- fail (printf "githubApps.apps[%d]: org is required" $i) -}}
  {{- end -}}
  {{- if not $app.appId -}}
  {{- fail (printf "githubApps.apps[%d] (org %s): appId is required" $i $app.org) -}}
  {{- end -}}
  {{- $org := lower $app.org -}}
  {{- if hasKey $seen $org -}}
  {{- fail (printf "githubApps.apps: duplicate entry for org %s; one entry per org" $org) -}}
  {{- end -}}
  {{- $_ := set $seen $org true -}}
  {{- if $app.privateKey -}}
  {{- fail (printf "githubApps.apps[%d] (org %s): privateKey is not supported — a PEM must never be a chart parameter. Put the key in a Secret in the cluster and reference it with githubApps.secret.name + privateKeySecretKey, or use privateKeySsmParameter" $i $org) -}}
  {{- end -}}
  {{- if $app.privateKeySsmParameter -}}
    {{- if $app.privateKeySecretKey -}}
    {{- fail (printf "githubApps.apps[%d] (org %s): privateKeySsmParameter cannot be combined with privateKeySecretKey; pick one key source" $i $org) -}}
    {{- end -}}
  {{- else if not $secretName -}}
  {{- fail (printf "githubApps.apps[%d] (org %s): reads its private key from a file, so githubApps.secret.name must name an existing Secret in the cluster (or use privateKeySsmParameter)" $i $org) -}}
  {{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Render the per-org GitHub App config as the agent's NP_GITHUB_APPS env var. The
agent's --github-app flag is repeatable and Kubernetes can only substitute
$(VAR) inside a single argument value, so the env var is the only way a chart can
pass N orgs. Entries are separated by ";", fields within an entry by ",".
Only paths, ids and parameter names are rendered here — never key material.
*/}}
{{- define "agent.githubAppsEnv" -}}
{{- include "agent.githubAppsValidate" . -}}
{{- if .Values.githubApps.enabled -}}
{{- $mountPath := .Values.githubApps.mountPath -}}
{{- $entries := list -}}
{{- range .Values.githubApps.apps -}}
  {{- $org := lower .org -}}
  {{- $fields := list (printf "org=%s" $org) (printf "app-id=%s" (.appId | toString)) -}}
  {{- if .installationId -}}
  {{- $fields = append $fields (printf "installation-id=%s" (.installationId | toString)) -}}
  {{- end -}}
  {{- if .privateKeySsmParameter -}}
  {{- $fields = append $fields (printf "private-key-ssm-parameter=%s" .privateKeySsmParameter) -}}
  {{- else -}}
  {{- $fields = append $fields (printf "private-key=%s/%s" $mountPath (.privateKeySecretKey | default (printf "%s.pem" $org))) -}}
  {{- end -}}
  {{- $entries = append $entries (join "," $fields) -}}
{{- end -}}
- name: NP_GITHUB_APPS
  value: {{ join ";" $entries | quote }}
{{- end -}}
{{- end -}}

{{/*
"true" when at least one org reads its private key from a file, meaning the
Secret has to be mounted. Empty when every org uses AWS SSM, so no key material
touches the cluster at all.
*/}}
{{- define "agent.githubAppsNeedsKeyVolume" -}}
{{- $needs := false -}}
{{- if .Values.githubApps.enabled -}}
{{- range .Values.githubApps.apps -}}
{{- if not .privateKeySsmParameter -}}{{- $needs = true -}}{{- end -}}
{{- end -}}
{{- end -}}
{{- if $needs -}}true{{- end -}}
{{- end -}}

{{/*
Join a map into "k1=v1,k2=v2" for the agent's NP_WORKER_* env vars.
*/}}
{{- define "agent.kvJoin" -}}
{{- $pairs := list -}}
{{- range $k, $v := . -}}{{- $pairs = append $pairs (printf "%s=%s" $k $v) -}}{{- end -}}
{{- join "," $pairs -}}
{{- end -}}

{{/*
Render the worker orchestrator config as NP_WORKER_* env for the agent container.
The agent reads these (os.Getenv) to pick the backend and shape worker pods.
*/}}
{{- define "agent.workerEnv" -}}
{{- with .Values.worker }}
- name: NP_WORKER_BACKEND
  value: {{ .backend | default "kubernetes" | quote }}
- name: NP_WORKER_SECURITY
  value: {{ .security | default "insecure" | quote }}
- name: NP_WORKER_NAMESPACE
  value: {{ .namespace | default $.Values.namespace | quote }}
# Stable per-install identity: this agent only ever manages workers labelled with
# it, so two agents in one cluster never collide on worker names or talk to each
# other's workers. The release name is constant across pod restarts.
- name: NP_AGENT_INSTANCE
  value: {{ $.Release.Name | quote }}
{{- if .allowedRegistries }}
- name: NP_ALLOWED_REGISTRIES
  value: {{ join "," .allowedRegistries | quote }}
{{- end }}
{{- if .pins }}
- name: NP_WORKERS
  value: {{ .pins | toJson | quote }}
{{- end }}
{{- if .rules }}
- name: NP_WORKER_RULES
  value: {{ .rules | toJson | quote }}
{{- end }}
{{- if .patches }}
- name: NP_WORKER_PATCHES
  value: {{ .patches | toJson | quote }}
{{- end }}
{{- if .idleTTL }}
- name: NP_WORKER_IDLE_TTL
  value: {{ .idleTTL | quote }}
{{- end }}
{{- with .defaults }}
{{- if .serviceAccount }}
- name: NP_WORKER_SERVICE_ACCOUNT
  value: {{ .serviceAccount | quote }}
{{- end }}
{{- if .nodeSelector }}
- name: NP_WORKER_NODE_SELECTOR
  value: {{ include "agent.kvJoin" .nodeSelector | quote }}
{{- end }}
{{- if .labels }}
- name: NP_WORKER_LABELS
  value: {{ include "agent.kvJoin" .labels | quote }}
{{- end }}
{{- if .imagePullSecrets }}
- name: NP_WORKER_IMAGE_PULL_SECRETS
  value: {{ join "," .imagePullSecrets | quote }}
{{- end }}
{{- if .env }}
- name: NP_WORKER_ENV
  value: {{ include "agent.kvJoin" .env | quote }}
{{- end }}
{{- with .resources }}
{{- with .requests }}
{{- if .cpu }}
- name: NP_WORKER_CPU_REQUEST
  value: {{ .cpu | quote }}
{{- end }}
{{- if .memory }}
- name: NP_WORKER_MEM_REQUEST
  value: {{ .memory | quote }}
{{- end }}
{{- end }}
{{- with .limits }}
{{- if .cpu }}
- name: NP_WORKER_CPU_LIMIT
  value: {{ .cpu | quote }}
{{- end }}
{{- if .memory }}
- name: NP_WORKER_MEM_LIMIT
  value: {{ .memory | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}{{/* end with .defaults */}}
{{- end }}{{/* end with .Values.worker */}}
{{- end -}}
