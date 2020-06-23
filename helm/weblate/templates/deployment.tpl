apiVersion: apps/v1
kind: Deployment
metadata:
  name: "{{ include "weblate.fullname" . }}-celery"
  labels:
{{ include "weblate.labels" . | indent 4 }}
spec:
  replicas: 4
  selector:
    matchLabels:
      app.kubernetes.io/name: "{{ include "weblate.name" . }}-celery"
      app.kubernetes.io/instance: "{{ .Release.Name }}-celery"
  template:
    metadata:
      annotations:
        checksum/config: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
        checksum/secret: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
      labels:
        app.kubernetes.io/name: "{{ include "weblate.name" . }}-celery"
        app.kubernetes.io/instance: "{{ .Release.Name }}-celery"
    spec:
    {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
    {{- end }}
      serviceAccountName: {{ template "weblate.serviceAccountName" . }}
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.workerImage.repository }}:{{ .Values.workerImage.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          resources:
            requests:
              memory: "256Mi"
              cpu: "200m"
            limits:
              memory: "256Mi"
              cpu: "400m"
          env:
            - name: REDIS_HOST
              value: {{ .Release.Name }}-redis-master
            - name: REDIS_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: {{ include "weblate.fullname" . }}
                  key: redis-password
            - name: CELERY_TASK_ALWAYS_EAGER
              value: "False"
            - name: CELERY_BROKER_URL
              value: "amqp://{{ index .Values "rabbitmq-ha" "rabbitmqUsername" }}:{{ index .Values "rabbitmq-ha" "rabbitmqPassword" }}@{{ .Release.Name }}-rabbitmq-ha"
            - name: CELERY_RESULT_BACKEND
              value: "amqp://{{ index .Values "rabbitmq-ha" "rabbitmqUsername" }}:{{ index .Values "rabbitmq-ha" "rabbitmqPassword" }}@{{ .Release.Name }}-rabbitmq-ha"