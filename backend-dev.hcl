# Stores Terraform state in S3 with DynamoDB locking for safe concurrent runs
bucket         = "project-terraform-eks-tfstate"
key            = "eks/dev/terraform.tfstate"
region         = "ap-south-1"
dynamodb_table = "eks-state-lock"
encrypt        = true