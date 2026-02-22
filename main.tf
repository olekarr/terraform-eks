module "vpc" {
  source = "./modules/vpc"

  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway
  tags               = var.tags
}

module "eks" {
  source = "./modules/eks"

  name            = var.name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids # recommended; you can switch to public for learning

  endpoint_public_access  = true
  endpoint_private_access = true

  tags = var.tags
}

module "nodegroups" {
  source = "./modules/nodegroups"

  name         = var.name
  cluster_name = module.eks.cluster_name

  # For learning & no NAT cost:
  subnet_ids = module.vpc.public_subnet_ids
  # If using private subnets with NAT:
  # subnet_ids = module.vpc.private_subnet_ids

  instance_types = ["t3.medium"]

  desired_size = 2
  min_size     = 1
  max_size     = 3

  tags = var.tags

  depends_on = [module.eks]
}