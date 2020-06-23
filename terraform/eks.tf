provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = var.cluster_name
  subnets      = module.vpc.private_subnets
  cluster_version = var.eks_cluster_version

  vpc_id = module.vpc.vpc_id

  enable_irsa = true

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = var.eks_worker_instance_size
      key_name = var.ec2_key_name
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.eks_worker_access.id]
      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
          "propagate_at_launch" = "false"
          "value"               = "true"
        }
      ]
    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
