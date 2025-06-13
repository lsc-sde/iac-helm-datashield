{{/*
Expand the name of the chart.
*/}}
{{- define "datashield.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
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

{{/*
Component specific names
*/}}
{{- define "datashield.mongodb.name" -}}
{{- printf "%s-mongodb" (include "datashield.fullname" .) }}
{{- end }}

{{- define "datashield.mysql.name" -}}
{{- printf "%s-mysql" (include "datashield.fullname" .) }}
{{- end }}

{{- define "datashield.opal.name" -}}
{{- printf "%s-opal" (include "datashield.fullname" .) }}
{{- end }}

{{- define "datashield.rock.name" -}}
{{- printf "%s-rock" (include "datashield.fullname" .) }}
{{- end }}

{{- define "datashield.agate.name" -}}
{{- printf "%s-agate" (include "datashield.fullname" .) }}
{{- end }}

{{- define "datashield.mica.name" -}}
{{- printf "%s-mica" (include "datashield.fullname" .) }}
{{- end }}

{{/*
Component specific labels
*/}}
{{- define "datashield.mongodb.labels" -}}
{{ include "datashield.labels" . }}
app.kubernetes.io/component: mongodb
{{- end }}

{{- define "datashield.mysql.labels" -}}
{{ include "datashield.labels" . }}
app.kubernetes.io/component: mysql
{{- end }}

{{- define "datashield.opal.labels" -}}
{{ include "datashield.labels" . }}
app.kubernetes.io/component: opal
{{- end }}

{{- define "datashield.rock.labels" -}}
{{ include "datashield.labels" . }}
app.kubernetes.io/component: rock
{{- end }}

{{- define "datashield.agate.labels" -}}
{{ include "datashield.labels" . }}
app.kubernetes.io/component: agate
{{- end }}

{{- define "datashield.mica.labels" -}}
{{ include "datashield.labels" . }}
app.kubernetes.io/component: mica
{{- end }}

{{/*
Component specific selector labels
*/}}
{{- define "datashield.mongodb.selectorLabels" -}}
{{ include "datashield.selectorLabels" . }}
app.kubernetes.io/component: mongodb
{{- end }}

{{- define "datashield.mysql.selectorLabels" -}}
{{ include "datashield.selectorLabels" . }}
app.kubernetes.io/component: mysql
{{- end }}

{{- define "datashield.opal.selectorLabels" -}}
{{ include "datashield.selectorLabels" . }}
app.kubernetes.io/component: opal
{{- end }}

{{- define "datashield.rock.selectorLabels" -}}
{{ include "datashield.selectorLabels" . }}
app.kubernetes.io/component: rock
{{- end }}

{{- define "datashield.agate.selectorLabels" -}}
{{ include "datashield.selectorLabels" . }}
app.kubernetes.io/component: agate
{{- end }}

{{- define "datashield.mica.selectorLabels" -}}
{{ include "datashield.selectorLabels" . }}
app.kubernetes.io/component: mica
{{- end }}

{{/*
Create the image repository and tag
*/}}
{{- define "datashield.image" -}}
{{- $registry := .Values.global.imageRegistry | default .Values.image.registry -}}
{{- if $registry }}
{{- printf "%s/%s:%s" $registry .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) }}
{{- else }}
{{- printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) }}
{{- end }}
{{- end }}

{{/*
Get the storage class name
*/}}
{{- define "datashield.storageClass" -}}
{{- if .Values.global.storageClass }}
{{- .Values.global.storageClass }}
{{- else if .Values.persistence.storageClass }}
{{- .Values.persistence.storageClass }}
{{- end }}
{{- end }}

{{/*
Generate secrets for components
*/}}
{{- define "datashield.secretName" -}}
{{- printf "%s-secrets" (include "datashield.fullname" .) }}
{{- end }}
