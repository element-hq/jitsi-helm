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
Common labels
*/}}
{{- define "jitsi.labels" -}}
helm.sh/chart: {{ include "jitsi.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Values.managedBy | default .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "jitsi.selectorLabels" -}}
app.kubernetes.io/part-of: jitsi-stack
{{- end -}}

{{- define "jitsi.haproxy.selectorLabels" -}}
{{ include "jitsi.selectorLabels" . }}
app.kubernetes.io/instance: {{ include "jitsi.name" . }}-haproxy
app.kubernetes.io/name: jitsi-haproxy
app.kubernetes.io/component: jitsi-load-balancer
{{- end -}}

{{- define "jitsi.jicofoShard.selectorLabels" -}}
{{ include "jitsi.selectorLabels" . }}
app.kubernetes.io/instance: {{ include "jitsi.name" . }}-jicofo
app.kubernetes.io/name: jitsi-jicofo
app.kubernetes.io/component: jitsi-conference-manager
shard: {{ toYaml .RelativeScope | quote }}
{{- end -}}

{{- define "jitsi.jvbGlobal.selectorLabels" -}}
{{ include "jitsi.selectorLabels" . }}
app.kubernetes.io/instance: {{ include "jitsi.name" . }}-jvb
app.kubernetes.io/name: jitsi-jvb
app.kubernetes.io/component: jitsi-selective-forwarding-unit
{{- end -}}

{{- define "jitsi.jvbShard.selectorLabels" -}}
{{ include "jitsi.jvbGlobal.selectorLabels" . }}
shard: {{ toYaml .RelativeScope.shard | quote }}
{{- end -}}

{{- define "jitsi.jvbReplica.selectorLabels" -}}
{{ include "jitsi.jvbShard.selectorLabels" . }}
replica: {{ toYaml .RelativeScope.replica | quote }}
{{- end -}}

{{- define "jitsi.prosodyGlobal.selectorLabels" -}}
{{ include "jitsi.selectorLabels" . }}
app.kubernetes.io/instance: {{ include "jitsi.name" . }}-prosody
app.kubernetes.io/name: jitsi-prosody
app.kubernetes.io/component: jitsi-coordinator
{{- end -}}

{{- define "jitsi.prosodyShard.selectorLabels" -}}
{{ include "jitsi.prosodyGlobal.selectorLabels" . }}
shard: {{ toYaml .RelativeScope | quote }}
{{- end -}}

{{- define "jitsi.sysctlJvb.selectorLabels" -}}
{{ include "jitsi.selectorLabels" . }}
app.kubernetes.io/instance: {{ include "jitsi.name" . }}-sysctl-jvb
app.kubernetes.io/name: jitsi-sysctl-jvb
app.kubernetes.io/component: jitsi-sysctl-setter
{{- end -}}

{{- define "jitsi.webShard.selectorLabels" -}}
{{ include "jitsi.selectorLabels" . }}
app.kubernetes.io/instance: {{ include "jitsi.name" . }}-web
app.kubernetes.io/name: jitsi-web
app.kubernetes.io/component: jitsi-web-server
shard: {{ toYaml .RelativeScope | quote }}
{{- end -}}

{{- define "jitsi.config.labels" -}}
{{ include "jitsi.selectorLabels" . }}
{{ include "jitsi.labels" . }}
app.kubernetes.io/instance: {{ include "jitsi.name" . }}-config
app.kubernetes.io/name: jitsi-config
app.kubernetes.io/component: jitsi-shared-config
{{- with $.Values.sharedConfigMapExtraLabels }}
{{ toYaml .}}
{{- end }}
{{- end -}}

{{- define "jitsi.haproxy.labels" -}}
{{ include "jitsi.haproxy.selectorLabels" . }}
{{- with $.Values.haproxy.extraLabels }}
{{ toYaml .}}
{{- end }}
{{- end -}}

{{- define "jitsi.ingress.labels" -}}
{{ include "jitsi.selectorLabels" . }}
{{ include "jitsi.labels" . }}
app.kubernetes.io/instance: {{ include "jitsi.name" . }}-ingress
app.kubernetes.io/name: jitsi-ingress
app.kubernetes.io/component: jitsi-ingress
{{- with $.Values.ingress.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "jitsi.jicofoShard.labels" -}}
{{ include "jitsi.jicofoShard.selectorLabels" . }}
{{- with $.Values.jicofo.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "jitsi.jvbGlobal.labels" -}}
{{ include "jitsi.jvbGlobal.selectorLabels" . }}
{{- with $.Values.jvb.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "jitsi.jvbShard.labels" -}}
{{ include "jitsi.jvbShard.selectorLabels" . }}
{{- with $.Values.jvb.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "jitsi.jvbReplica.labels" -}}
{{ include "jitsi.jvbReplica.selectorLabels" . }}
{{- with $.Values.jvb.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "jitsi.jvbReplicaMonitoring.labels" -}}
{{ include "jitsi.jvbReplica.selectorLabels" . }}
{{- with $.Values.jvb.monitoring.service.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "jitsi.prosodyGlobal.labels" -}}
{{ include "jitsi.prosodyGlobal.selectorLabels" . }}
{{- with $.Values.prosody.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "jitsi.prosodyShard.labels" -}}
{{ include "jitsi.prosodyShard.selectorLabels" . }}
{{- with $.Values.prosody.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "jitsi.sysctlJvb.labels" -}}
{{ include "jitsi.sysctlJvb.selectorLabels" . }}
{{- with $.Values.sysctljvb.extraLabels }}
{{ toYaml .}}
{{- end }}
{{- end -}}

{{- define "jitsi.webShard.labels" -}}
{{ include "jitsi.webShard.selectorLabels" . }}
{{- with $.Values.web.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "jitsi.jvb.entryPointConfigMap.name" -}}
{{ $.Values.jvb.entryPointConfigMap.name | default (print (include "jitsi.name" .) "-jvb-entrypoint") }}
{{- end -}}

{{- define "jitsi.jvb.gracefulShutdownConfigMap.name" -}}
{{ $.Values.jvb.gracefulShutdownConfigMap.name | default (print (include "jitsi.name" .) "-jvb-shutdown") }}
{{- end -}}

{{- define "jitsi.sharedConfigMap.name" -}}
{{ $.Values.sharedConfigMapName | default (print (include "jitsi.name" .) "-config") }}
{{- end -}}

{{/*
Define a helper function to output the data of the shared ConfigMap
*/}}
{{- define "jitsi.sharedConfigMap.data" -}}
JVB_STUN_SERVERS: {{ $.Values.JVB_STUN_SERVERS }}
PUBLIC_URL: {{ ((gt (len $.Values.ingress.hosts) 0) | ternary (print "https://" ($.Values.ingress.hosts | first)) $.Values.PUBLIC_URL) | required "One of PUBLIC_URL or ingress.hosts must be provided" }}
TZ: {{ $.Values.TZ }}
{{- end }}

{{/*
Define a helper function to create a hash of the output of the previous function
*/}}
{{- define "jitsi.sharedConfigMap.hash" -}}
{{- $cm := include "jitsi.sharedConfigMap.data" . | sha256sum }}
{{- printf "%s" (trunc 63 $cm) -}}
{{- end }}

{{- define "jitsi.sharedSecret.name" -}}
{{ $.Values.secretName | default (include "jitsi.name" .) }}
{{- end -}}
