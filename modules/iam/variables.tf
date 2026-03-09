variable "name" {
  description = "Project name prefix for IAM roles"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to IAM resources"
  type        = map(string)
  default     = {}
}

variable "oidc_provider_arn" {
  description = "The OIDC Provider ARN from the EKS module"
  type        = string
}

