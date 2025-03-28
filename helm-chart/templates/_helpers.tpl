{{- define "common.namespace" -}}
{{ .Values.namespace | default "symfony" }}
{{- end }}

{{- define "common.labels" -}}
app: {{ .deploymentName | default "app" }}
environment: {{ .environment | default "dev" }}
{{- end }}
