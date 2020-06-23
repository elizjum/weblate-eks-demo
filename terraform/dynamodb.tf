# DynamoDB table to provide locking for concurrent access to the terraform 
# state files kept on S3
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "elizjum-dynamodb-terraform-state-lock" {
    name = "terraform-state-lock"
    hash_key = "LockID"
    read_capacity = 20
    write_capacity = 20

    attribute {
        name = "LockID"
        type = "S"
    }

    tags = {
        Name = "DynamoDB Terraform State Locking Table"
    }
}
