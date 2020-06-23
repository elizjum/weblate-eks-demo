# space-kube demo

Deploys a simple Kubernetes cluster on the Amazon EKS service along with a Helm Weblate deployment available to the public over an Application Load Balancer.

---

## Requirements

* Basic familiariary with Kubernetes, AWS EKS, aws-cli, Terraform and Helm
* Terraform v0.12.26 <https://www.terraform.io/>
* aws-cli v1.17.14 <https://aws.amazon.com/cli/>
* aws-iam-authenticator v0.4.0 <https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html>
* kubectl v1.18.2 <https://kubernetes.io/docs/tasks/tools/install-kubectl/>
* Helm v3.2.2 <https://helm.sh/docs/intro/install/>
* Access to an AWS account with sufficient permissions

---

## Structure

* terraform - direcotry with the Terraform code needed to provisition the infrastructure
* kube - Raw Kubernetes manifests
* celery-docker - Docker image sources for the Weblate Celery worker
* helm - Helm chart directory

## Deploying the infrastructure on AWS

* Configure aws-cli
* Create AWS S3 bucket for holding remote Terraform state (see terraform/init.tf.example)
* Create an EC2 key pair (adjust variable ec2_key_name in terraform/variables.tf)
* Examine the rest of varaibles in terraform/variables.tf
* On the first run of terraform apply you need to add the -lock=false argument as the DynamoDB table that handles locking for the S3 bucket is not yet created
``

---

## Deploying Kubernetes Metrics Server

`kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml`

The metrics server is needed cluster wide statistics.

## Deploying cluster autoscaler

The Cluster Autoscaler <https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html> manages Amazon EC2 Auto Scaling groups from Kubernetes.

To install the Cluster Autoscaler we will use Helm, the de facto standard package manager for Kubernetes that helps us manage Kubernetes applications.

Before deploying the cluster-autoscaler chart please examine the cluster-autoscaler-chart-values yaml file located in kube/cluster-autoscaler and pay attention to the autoDiscovery.clusterName and the AWS Account id in the value of rbac.serviceAccountAnnotations.eks.amazonaws.com/role-arn key. They need to be propery adjusted should you change the default EKS cluster name and for you AWS Account ID.

To deploy the Cluster Autoscaler simply execute

`
helm install cluster-autoscaler --namespace kube-system stable/cluster-autoscaler --values=kube/cluster-autoscaler/cluster-autoscaler-chart-values.yaml
`

TODO:

* These files should be templated and/or moved to Terraform (same as ALB ingress controller)

## Deploying Weblate

Please see helm/weblate/README.MD

## Usefull scripts

* scripts/destroy-cluster.sh - Destroys every resource in the EKS cluster (usefull for cleanup)
