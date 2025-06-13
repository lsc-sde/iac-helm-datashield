{{/*
Expand the name of the chart.
*/}}
{{- define "datashield.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "datashield.agate.name" -}}
{{- printf "%s-agate" .Release.Name }}
{{- end }}


{{- define "datashield.mongodb.name" -}}
{{- printf "%s-mongo" .Release.Name }}
{{- end }}

{{- define "datashield.mysqldb.name" -}}
{{- printf "%s-mysqldb" .Release.Name }}
{{- end }}

{{- define "datashield.mica.name" -}}
{{- printf "%s-mica" .Release.Name }}
{{- end }}

{{- define "datashield.opal.name" -}}
{{- printf "%s-opal" .Release.Name }}
{{- end }}

{{- define "datashield.rock.name" -}}
{{- printf "%s-rock" .Release.Name }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "datashield.fullname" -}}
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
{{- define "datashield.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "datashield.labels" -}}
helm.sh/chart: {{ include "datashield.chart" . }}
{{ include "datashield.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "datashield.selectorLabels" -}}
app.kubernetes.io/name: {{ include "datashield.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "datashield.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "datashield.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
