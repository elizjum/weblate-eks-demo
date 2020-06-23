module "rds_postgres_weblate" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "elizjum-postgres"

  engine            = "postgres"
  engine_version    = "11.7"
  instance_class    = "db.t2.small"
  allocated_storage = 5
  storage_encrypted = false
  multi_az = true

  name = var.rds_weblate_dbname

  username = var.rds_weblate_user

  password = var.rds_weblate_pass
  port     = "5432"

  vpc_security_group_ids = [aws_security_group.rds_postgress.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 0

  tags = {
    Owner       = "weblate"
  }

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  subnet_ids = module.vpc.database_subnets

  family = "postgres11"

  major_engine_version = "11"

  final_snapshot_identifier = "elizjum-postgres"

  deletion_protection = false
}