{{/*
Expand the name of the chart.
*/}}
{{- define "gateway-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gateway-api.fullname" -}}
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
{{- define "gateway-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "gateway-api.labels" -}}
helm.sh/chart: {{ include "gateway-api.chart" . }}
{{ include "gateway-api.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.labels }}
{{ toYaml .Values.labels }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "gateway-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gateway-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "gateway-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "gateway-api.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
The version of the Gateway resource.
*/}}
{{- define "gateway-api.gatewayVersion" -}}
v1beta1
{{- end }}

{{/*
The version of the HTTPRoute resource.
*/}}
{{- define "gateway-api.httpRouteVersion" -}}
v1beta1
{{- end }}

{{/*
The version of the ReferenceGrant resource.
*/}}
{{- define "gateway-api.referenceGrantVersion" -}}
{{- if semverCompare "< 0.6.0" .Values.gatewayAPIVersion -}}
v1alpha2
{{- else -}}
v1beta1
{{- end -}}
{{- end }}
