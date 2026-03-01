variable "name" {
  description = "Name prefix for node group resources"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets where nodes will be deployed"
  type        = list(string)
}

variable "instance_types" {
  description = "EC2 instance types for the nodes"
  type        = list(string)
  default     = ["t3.small"] # Updated from t3.medium to t3.small
}

variable "desired_size" {
  type    = number
  default = 1 # Updated to 1 to minimize initial costs
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2 # Reduced for lab purposes
}

variable "disk_size" {
  description = "Disk size in GiB"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Common tags passed from root"
  type        = map(string)
  default     = {}
}