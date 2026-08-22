{{- define "o1adapter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "o1adapter.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "o1adapter.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "o1adapter.labels" -}}
app.kubernetes.io/name: {{ include "o1adapter.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{- end -}}

{{- define "o1adapter.selectorLabels" -}}
app.kubernetes.io/name: {{ include "o1adapter.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
