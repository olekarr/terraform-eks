locals {

  # Defines a reusable name prefix for all resources
  name_prefix = var.name

  # Merges standard organizational tags with environment-specific tags
  common_tags = merge(
    {
      Project   = local.name_prefix
      ManagedBy = "terraform"
      Owner     = "Ravikumar"
    },
    var.tags
  )

  # Selects private subnets for nodes when NAT is enabled, otherwise falls back to public subnets
  node_subnet_ids = var.enable_nat_gateway ? module.vpc.private_subnet_ids : module.vpc.public_subnet_ids
}