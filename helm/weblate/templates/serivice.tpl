apiVersion: v1
kind: Service
metadata:
  name: {{ include "weblate.fullname" . }}
  labels:
{{ include "weblate.labels" . | indent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: {{ include "weblate.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
