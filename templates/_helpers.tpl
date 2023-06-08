{{/*
Expand the name of the chart.
*/}}
{{- define "jitsi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "jitsi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the jicofo cmp name
*/}}
{{- define "jitsi.name-jicofo" -}}
{{- printf "jicofo" | trunc 63 -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "jitsi.labels" -}}
{{/*
k8s-app: {{ .Chart.Name }}
app.kubernetes.io/name: {{ include "jitsi.name" . }}
*/}}
scope: {{ .Chart.Name  }}
helm.sh/chart: {{ include "jitsi.chart" . }}
app.kubernetes.io/instance: {{ .Chart.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Define a helper function to output the data of the shared ConfigMap
*/}}
{{- define "jitsi.sharedconfigmap.data" -}}
JVB_STUN_SERVERS: {{ $.Values.JVB_STUN_SERVERS }}
PUBLIC_URL: {{ ((gt (len $.Values.ingress.hosts) 0) | ternary (print "https://" ($.Values.ingress.hosts | first)) $.Values.PUBLIC_URL) | required "One of PUBLIC_URL or ingress.hosts must be provided" }}
TZ: {{ $.Values.TZ }}
{{- end }}

{{/*
Define a helper function to create a hash of the output of the previous function
*/}}
{{- define "jitsi.sharedconfigmap.hash" -}}
{{- $cm := include "jitsi.sharedconfigmap.data" . | sha256sum }}
{{- printf "%s" (trunc 63 $cm) -}}
{{- end }}
