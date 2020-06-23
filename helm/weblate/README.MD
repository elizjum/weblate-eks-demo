# weblate/redis/rabbitmq/celery-worker helm chart

Deploys Weblate with Redis as Django cache and HA RabbitMQ broker with Celery
workers on a AWS EKS cluster.  Based on <https://github.com/WeblateOrg/helm>

---

## Major changes

* Changing from deployment to statefullset for Weblate. Weblate is a statefull
app and thus should be handled as an Kubernetes statefullset (<https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/>)
* Adding an highly available RabbitMQ cluster as the message broker
* Adding custom Celery docker image that connects to the RabbitMQ cluster

## Installing

* Inspect values.yaml and adjust accordingly (Pay extra attention to the RDS
configuration values)
* Execute helm install on the chart (<https://helm.sh/docs/helm/helm_install/>)

## Autoscaling

Due to the demo like experience of this deployment there is no default
configuration of the Horizontal Pod Autoscaler as it highly depends on the
cluster size and default limits.

To scale any of the services that back up Weblate (RabbitMQ and Celery workers)
simply use kubectl autoscale functionality. For example to autoscale Celery workers
execute

`kubectl autoscale deployment deployment-name-celery --cpu-percent=z --min=x -max=y`

Where:

* deployment-name is the name of your Helm deployment
* z is the target % of CPU utilization of the Celery worker pods
* x is the minimum number of running PODs
* y is the maximum number of running PODs

More on the HPA

* <https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/>
* <https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/>

## Rolling back Helm releases

To roll back to any previous Helm release of the Weblate deployment use the `helm rollback` functionality
<https://helm.sh/docs/helm/helm_rollback/>
