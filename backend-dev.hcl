# Stores Terraform state in S3 with DynamoDB locking for safe concurrent runs
bucket         = "tfstate-ravi-eks-ap-south1"
key            = "eks/dev/terraform.tfstate"
region         = "ap-south-1"
dynamodb_table = "terraform-locks"
encrypt        = true