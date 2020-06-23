# Variables
# -----------------------------------------------------------------------------

variable "cluster_name" {
    default = "elizjum-demo"
}

variable "project_name" {
    default = "spaceos-demo"
}

variable "aws_region" {
    default = "eu-west-1"
}

variable "eks_cluster_version" {
    default = "1.16"
}

variable "eks_worker_instance_size" {
    default = "t2.large"
}

variable "ec2_key_name" {
    default = "elizjum-key"
}

variable "rds_weblate_user" {
    default = "weblate"
}

variable "rds_weblate_pass" {
    default = "weblatedbpass"
}

variable "rds_weblate_dbname" {
    default = "weblate"
}

# Subnetting
# Public - NAT
# Private - EKS subnets
# RDS - RDS subnets
# -----------------------------------------------------------------------------

variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
    type = list(string)
    default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "private_subnet_cidr_blocks" {
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "rds_subnet_cidr_blocks" {
    type = list(string)
    default = ["10.0.50.0/26","10.0.50.64/26","10.0.50.128/26"]
}
