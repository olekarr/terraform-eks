# Configures the AWS provider for the target deployment region
provider "aws" {
  region = var.aws_region
}