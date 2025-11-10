# SHARED AND DEFAULTS

data "aws_caller_identity" "current" {}


module "base" {
  source = "./modules/base"
  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
}

# NETWORK
module "networks" {
  source = "./modules/network"

  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  azs                  = var.network.azs
  vpc_cidr             = var.network.vpc_cidr
  enable_nat_gateway   = var.network.enable_nat_gateway
  single_nat_gateway   = var.network.single_nat_gateway
  public_subnets       = var.network.public_subnets
  private_subnets      = var.network.private_subnets
  restricted_subnets   = var.network.restricted_subnets
}

################################################################################
# EKS CLUSTER
################################################################################

module "eks" {
  source = "./modules/cluster"

  # --- Parámetros generales ---
  prefix_resource_name = var.prefix_resource_name
  stack_number         = var.stack_number
  cluster_name         = "final"
  #kms_key_arn          = module.base.key.arn
  vpc_id                  = module.networks.vpc_id
  vpc_cidr             = var.network.vpc_cidr
  # ---Networking---
  cluster_subnet_ids   = [for s in module.networks.private_subnets : s.id]
}