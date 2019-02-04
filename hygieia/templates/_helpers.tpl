{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "hygieia.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 50 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}`
{{- define "hygieia.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 50 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 50 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 50 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "api.name" -}}
{{- $name := include "hygieia.fullname" . -}}
{{- printf "%s-%s" $name "api" | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "audit.name" -}}
{{- $name := include "hygieia.fullname" . -}}
{{- printf "%s-%s" $name "audit" | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hygieia.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "generate_env" -}}
{{-   $env := .Values.env -}}
{{-   if not $env.API_HOST -}}
{{-     $api_host := include "api.name" . -}}
{{-     $env := set $env "API_HOST" $api_host -}}
{{-   end -}}
{{-   if not $env.API_PORT -}}
{{-     $api_host := include "api.name" . -}}
{{-     $env := set $env "API_PORT" .Values.api.service.port -}}
{{-   end -}}
{{-   if .Values.mongodb.enabled -}}
{{-     $mongodb_host := printf "%s-%s" .Release.Name "mongodb" -}}
{{-     $mongodb_port := "27017" -}}
{{-     $env := set $env "SPRING_DATA_MONGODB_HOST" $mongodb_host -}}
{{-     $env := set $env "SPRING_DATA_MONGODB_PORT" $mongodb_port -}}
{{-   end -}}
{{-   range $key, $val := $env }}
{{     quote $key | printf "- name: %s" }}
{{     toString $val | quote | printf "  value: %s" }}
{{- end }}
{{- end -}}
