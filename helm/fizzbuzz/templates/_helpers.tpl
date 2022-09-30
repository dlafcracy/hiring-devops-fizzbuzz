{{/*
Expand the name of the chart.
*/}}
{{- define "fizzbuzz.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Expand specific short app name for 3 instances
*/}}
{{- define "fizzbuzz1.name" -}}
{{- printf "%s-1" (include "fizzbuzz.name" . | trunc 61 | trimSuffix "-") }}
{{- end }}
{{- define "fizzbuzz2.name" -}}
{{- printf "%s-2" (include "fizzbuzz.name" . | trunc 61 | trimSuffix "-") }}
{{- end }}
{{- define "fizzbuzz3.name" -}}
{{- printf "%s-3" (include "fizzbuzz.name" . | trunc 61 | trimSuffix "-") }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fizzbuzz.fullname" -}}
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
Create specific fully qualified app name for 3 instances
*/}}
{{- define "fizzbuzz1.fullname" -}}
{{- printf "%s-1" (include "fizzbuzz.fullname" . | trunc 61 | trimSuffix "-") }}
{{- end }}
{{- define "fizzbuzz2.fullname" -}}
{{- printf "%s-2" (include "fizzbuzz.fullname" . | trunc 61 | trimSuffix "-") }}
{{- end }}
{{- define "fizzbuzz3.fullname" -}}
{{- printf "%s-3" (include "fizzbuzz.fullname" . | trunc 61 | trimSuffix "-") }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fizzbuzz.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fizzbuzz.labels" -}}
helm.sh/chart: {{ include "fizzbuzz.chart" . }}
{{ include "fizzbuzz.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Specific labels for 3 apps
*/}}
{{- define "fizzbuzz1.labels" -}}
{{ include "fizzbuzz.labels" . }}
{{ include "fizzbuzz1.selectorLabels" . }}
{{- end }}
{{- define "fizzbuzz2.labels" -}}
{{ include "fizzbuzz.labels" . }}
{{ include "fizzbuzz2.selectorLabels" . }}
{{- end }}
{{- define "fizzbuzz3.labels" -}}
{{ include "fizzbuzz.labels" . }}
{{ include "fizzbuzz3.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "fizzbuzz.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Specific Selector labels for 3 apps
*/}}
{{- define "fizzbuzz1.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fizzbuzz1.name" . }}
{{- end }}
{{- define "fizzbuzz2.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fizzbuzz2.name" . }}
{{- end }}
{{- define "fizzbuzz3.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fizzbuzz3.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "fizzbuzz.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "fizzbuzz.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
