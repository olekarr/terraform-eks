locals {
  name_prefix = var.name
  
  common_tags = merge(var.tags, {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = var.name
  })

  # SRE Logic: If NAT is disabled, use public subnets so nodes can reach the EKS API
  node_subnet_ids = var.enable_nat_gateway ? module.vpc.private_subnet_ids : module.vpc.public_subnet_ids
}