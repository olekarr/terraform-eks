variable "name" {
  description = "Name prefix for EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetes version (e.g., 1.29)"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for EKS cluster networking (typically private subnets)"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "endpoint_public_access" {
  description = "Whether the EKS API endpoint is public"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Whether the EKS API endpoint is private"
  type        = bool
  default     = true
}

variable "enabled_cluster_log_types" {
  description = "Control plane log types to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
}

variable "tags" {
  description = "Extra tags"
  type        = map(string)
  default     = {}
}