resource "kubernetes_deployment" "alb-ingress-controller" {
    metadata {
        labels = {
            "app.kubernetes.io/name" = "alb-ingress-controller"
        }
        name = "alb-ingress-controller"
        namespace = "kube-system"
    }

    spec {
        selector {
            match_labels = {
                "app.kubernetes.io/name" = "alb-ingress-controller"
            }
        }
        template {
            metadata {
                labels = {
                    "app.kubernetes.io/name" = "alb-ingress-controller"
                }
            }
            spec {
                container {
                    name = "alb-ingress-controller"
                    image = "docker.io/amazon/aws-alb-ingress-controller:v1.1.4"
                    args = ["--ingress-class=alb", "--cluster-name=${module.eks.cluster_id}"]
                }
                service_account_name = "alb-ingress-controller"
                automount_service_account_token = true
            }
        }
    }

    depends_on = [kubernetes_cluster_role.alb-ingress-controller]
}

resource "kubernetes_cluster_role" "alb-ingress-controller" {
    metadata {
        labels = {
            "app.kubernetes.io/name" = "alb-ingress-controller"
        }
        name = "alb-ingress-controller"
    }

    rule {
        api_groups = [
            "",
            "extensions",
        ]

        resources = [
           "configmaps",
            "endpoints",
            "events",
            "ingresses",
            "ingresses/status",
            "services",
        ]

        verbs = [
           "create",
          "get",
            "list",
            "update",
            "watch",
            "patch",
        ]
    }

    rule {
        api_groups = [
            "",
            "extensions",

        ]
        resources = [
            "nodes",
            "pods",
            "secrets",
            "services",
            "namespaces",
        ]

        verbs = [
          "get",
          "list",
          "watch",
        ]
    }
}

resource "kubernetes_cluster_role_binding" "alb-ingress-controller" {
    metadata {
        labels = {
            "app.kubernetes.io/name" = "alb-ingress-controller"
        }
        name = "alb-ingress-controller"
    }

    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind = "ClusterRole"
        name = "alb-ingress-controller"
    }

    subject {
        kind = "ServiceAccount"
        name = "alb-ingress-controller"
        namespace = "kube-system"
    }

    depends_on = [kubernetes_service_account.alb-ingress-controller]
}

resource "kubernetes_service_account" "alb-ingress-controller" {
    metadata {
        labels = {
            "app.kubernetes.io/name" = "alb-ingress-controller"
        }
        name = "alb-ingress-controller"
        namespace = "kube-system"
        annotations = { "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-alb-ingress-controller" }
    }
}
