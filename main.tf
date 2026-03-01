# Creates the shared VPC networking layer used by the EKS cluster and nodegroups
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

# Creates the EKS control plane and OIDC provider (IRSA baseline)
module "eks" {
  source = "./modules/eks"

  name            = local.name_prefix
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  tags            = local.common_tags
}

# Creates the managed worker node group(s) attached to the EKS cluster
module "nodegroups" {
  source = "./modules/nodegroups"

  name         = local.name_prefix
  cluster_name = module.eks.cluster_name
  subnet_ids   = local.node_subnet_ids
  tags         = local.common_tags

  depends_on = [module.eks]
}