# AWS Provider configuration
# -----------------------------------------------------------------------------

provider "aws" {
    region = var.aws_region
    version = "~> 2.65"
    access_key = var.elizjum_aws_access_key
    secret_key = var.elizjum_aws_secret_key
}