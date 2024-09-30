{{- define "outputCommands" -}}
{{/* Export commands for retrieving gateway external IPs */}}
export GATEWAY_PRIVATE_EXTERNAL_IP=$(kubectl get services --namespace {{ .Values.namespaces.gateway }} | grep {{ .Values.gateway.internal.name }} | awk '{print $4}')
export GATEWAY_PUBLIC_EXTERNAL_IP=$(kubectl get services --namespace {{ .Values.namespaces.gateway }} | grep {{ .Values.gateway.public.name }} | awk '{print $4}')
{{- end -}}