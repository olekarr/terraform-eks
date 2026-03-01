# Exposes the VPC ID created by the networking module
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# Exposes private subnet IDs used for EKS and node workloads
output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# Exposes the EKS cluster name for kubectl and integrations
output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

# Exposes the EKS API server endpoint
output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS Kubernetes API"
  value       = module.eks.cluster_endpoint
}

# Exposes the cluster CA data required for secure API communication
output "eks_cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_ca_base64
  sensitive   = true
}

# Exposes the OIDC provider ARN used for IRSA configuration
output "eks_oidc_issuer_arn" {
  description = "The ARN of the OIDC Provider for IAM Roles for Service Accounts (IRSA)"
  value       = module.eks.oidc_provider_arn
}

# Exposes the managed node group name
output "node_group_name" {
  description = "The name of the EKS managed node group"
  value       = module.nodegroups.node_group_name
}