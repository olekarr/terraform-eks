# 1. Networking Layer (The Foundation)
module "vpc" {
  source = "./modules/vpc"

  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  
  # Uses the merged tags from locals.tf
  tags = local.common_tags
}

# 2. IAM Layer - Security & Permissions
module "iam" {
  source = "./modules/iam"

  name = var.name
  tags = local.common_tags
  oidc_provider_arn = module.eks.oidc_provider_arn
}

# 3. EKS Layer - Control Plane & Node Groups
module "eks" {
  source = "./modules/eks"

  name            = var.name
  cluster_version = var.cluster_version
  
  # Network Inputs
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids # API Server Subnets
  
  node_subnet_ids = local.node_subnet_ids 

  # IAM Inputs from IAM Module
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn

  # Node Configuration
  instance_types = var.instance_types
  desired_size   = var.desired_size
  min_size       = var.min_size
  max_size       = var.max_size
  disk_size      = var.disk_size

  tags = local.common_tags
}