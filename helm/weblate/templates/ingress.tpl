{{- if .Values.ingress.enabled -}}
{{- $fullName := include "weblate.fullname" . -}}
{{- $svcPort := .Values.service.port -}}
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: {{ $fullName }}
  labels:
{{ include "weblate.labels" . | indent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  rules:
    - http:
        paths:
          - path: "/*"
            backend:
              serviceName: {{ $fullName }}
              servicePort: {{ $svcPort }}
{{- end }}
