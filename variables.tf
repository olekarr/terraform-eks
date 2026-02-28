variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
}

variable "name" {
  description = "Project name prefix"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR list"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR list"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Boolean to enable/disable NAT Gateway"
  type        = bool
  default     = false
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "tags" {
  description = "Additional custom tags"
  type        = map(string)
  default     = {}
}