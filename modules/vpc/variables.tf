variable "name" {
  description = "Name prefix for VPC resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones to use (e.g., [\"ap-south-1a\", \"ap-south-1b\"])"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets (must match azs length)"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets (must match azs length)"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets (costs money)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Extra tags to apply to resources"
  type        = map(string)
  default     = {}
}