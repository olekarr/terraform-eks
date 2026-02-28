variable "name" {
  description = "Name prefix for EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for EKS cluster networking"
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
  description = "Common tags passed from root"
  type        = map(string)
  default     = {}
}