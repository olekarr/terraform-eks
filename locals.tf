locals {
  name_prefix = var.name

  common_tags = merge(
    {
      Project   = local.name_prefix
      ManagedBy = "terraform"
      Owner     = "Ravikumar"
    },
    var.tags
  )

  # Logic: Use private subnets for nodes if NAT is enabled, otherwise use public.
  node_subnet_ids = var.enable_nat_gateway ? module.vpc.private_subnet_ids : module.vpc.public_subnet_ids
}