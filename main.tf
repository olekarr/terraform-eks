# 1. Networking Layer
module "vpc" {
  source = "./modules/vpc"

  name                 = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  tags                 = local.common_tags
}

# 2. EKS Control Plane
module "eks" {
  source = "./modules/eks"

  name            = local.name_prefix
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  tags            = local.common_tags
}

# 3. Managed Worker Nodes
module "nodegroups" {
  source = "./modules/nodegroups"

  name           = local.name_prefix
  cluster_name   = module.eks.cluster_name
  # Uses logic from locals.tf to decide between public or private subnets
  subnet_ids     = local.node_subnet_ids
  tags           = local.common_tags

  # Passing explicit values to fix the "Free Tier" error
  instance_types = var.instance_types
  desired_size   = var.desired_size
  min_size       = var.min_size
  max_size       = var.max_size
  disk_size      = var.disk_size

  depends_on = [module.eks]
}