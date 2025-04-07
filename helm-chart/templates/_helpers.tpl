{{- define "common.namespace" -}}
{{ .Values.namespace | default "symfony" }}
{{- end }}

{{- define "common.labels" -}}
app: {{ .Chart.Name }}
release: {{ .Release.Name }}
environment: {{ .Values.environment | default "dev" }}
{{- end }}