resource "aws_security_group" "eks_worker_access" {
  name_prefix = "eks_worker_access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8"
    ]
  }
}

resource "aws_security_group" "rds_postgress" {
  name_prefix = "rds_security_group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 0
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8"
    ]
  }
}