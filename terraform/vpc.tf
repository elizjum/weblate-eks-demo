# Get availability zones for current region and configure VPC with subnets for
# NAT gateways, EKS cluster and RDS
# -----------------------------------------------------------------------------

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.39.0"

  name                 = "eks-${var.cluster_name}-vpc"
  cidr                 = var.vpc_cidr_block
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.private_subnet_cidr_blocks
  public_subnets       = var.public_subnet_cidr_blocks
  database_subnets     = var.rds_subnet_cidr_blocks
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
