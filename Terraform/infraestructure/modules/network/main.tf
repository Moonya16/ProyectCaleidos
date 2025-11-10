locals {
  len_public_subnets = length(var.public_subnets)
  len_private_subnets = length(var.private_subnets)
  len_restricted_subnets = length(var.restricted_subnets)

  # local.create_vpc &&
  create_public_subnets     = local.len_public_subnets > 0
  create_private_subnets    = local.len_private_subnets > 0
  create_restricted_subnets = local.len_restricted_subnets > 0

  num_public_route_tables = var.create_multiple_public_route_tables ? local.len_public_subnets : 1

  num_nat_gateway = var.single_nat_gateway ? 1 : local.len_private_subnets

  public_layer_name = "public"
  private_layer_name = "application"
  restricted_layer_name = "data"
}

################################################################################
# Module VPC
################################################################################
module "vpc" {
  source = "../../../modules/vpc/vpc"

  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  cidr                 = var.vpc_cidr
}

################################################################################
# Module Public Subnets
################################################################################
module "public_subnets" {
  source = "../../../modules/vpc/subnet"
  count  = local.create_public_subnets ? local.len_public_subnets : 0

  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  az                   = length(regexall("^[a-z]{2}-", var.azs[count.index])) > 0 ? var.azs[count.index] : null
  type                 = local.public_layer_name
  vpc                  = module.vpc
  cidr                 = concat(var.public_subnets, [""])[count.index]
}

################################################################################
# Module Private Subnets
################################################################################
module "private_subnets" {
  source = "../../../modules/vpc/subnet"
  count  = local.create_private_subnets ? local.len_private_subnets : 0

  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  az                   = length(regexall("^[a-z]{2}-", var.azs[count.index])) > 0 ? var.azs[count.index] : null
  type                 = local.private_layer_name
  vpc                  = module.vpc
  cidr                 = concat(var.private_subnets, [""])[count.index]
}

################################################################################
# Module Restricted Subnets
################################################################################
module "restricted_subnets" {
  source = "../../../modules/vpc/subnet"
  count  = local.create_restricted_subnets ? local.len_restricted_subnets : 0

  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  az                   = length(regexall("^[a-z]{2}-", var.azs[count.index])) > 0 ? var.azs[count.index] : null
  type                 = local.restricted_layer_name
  vpc                  = module.vpc
  cidr                 = concat(var.restricted_subnets, [""])[count.index]
}

################################################################################
# Module Public Route Tables
################################################################################
module "public_route_tables" {
  source = "../../../modules/vpc/route_table"
  count  = local.create_public_subnets ? local.num_public_route_tables : 0

  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  name                 = local.public_layer_name
  vpc                  = module.vpc
}

module "public_association" {
  source = "../../../modules/vpc/subnet_association"
  count  = local.create_public_subnets ? local.len_public_subnets : 0

  subnet      = module.public_subnets[count.index]
  route_table = module.public_route_tables[var.create_multiple_public_route_tables ? count.index : 0]
}

################################################################################
# Module Private Route Tables
################################################################################
module "private_route_tables" {
  source = "../../../modules/vpc/route_table"
  count  = local.create_private_subnets ? 1 : 0

  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  name                 = local.private_layer_name
  vpc                  = module.vpc
}

module "private_association" {
  source = "../../../modules/vpc/subnet_association"
  count  = local.create_private_subnets ? local.len_private_subnets : 0

  subnet      = module.private_subnets[count.index]
  route_table = module.private_route_tables[0]
}

################################################################################
# Module Restricted Route Tables
################################################################################
module "restricted_route_tables" {
  source = "../../../modules/vpc/route_table"
  count  = local.create_restricted_subnets ? 1 : 0

  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  name                 = local.restricted_layer_name
  vpc                  = module.vpc
}

module "restricted_association" {
  source = "../../../modules/vpc/subnet_association"
  count  = local.create_restricted_subnets ? local.len_restricted_subnets : 0

  subnet      = module.restricted_subnets[count.index]
  route_table = module.restricted_route_tables[0]
}

################################################################################
# Module InternetGateway
################################################################################
module "internet_gateways" {
  source = "../../../modules/vpc/internet_gateway"

  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  vpc                  = module.vpc
}

module "route_internet_gateways" {
  source = "../../../modules/vpc/route"
  count  = local.create_public_subnets ? local.num_public_route_tables : 0

  route_table      = module.public_route_tables[count.index]
  destination_cidr = "0.0.0.0/0"
  gateway          = module.internet_gateways
}

################################################################################
# Module NATGateway
################################################################################
module "nat_eips" {
  source = "../../../modules/vpc/eip"
  count  = var.enable_nat_gateway ? local.num_nat_gateway : 0

  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  name                 = (
    length(var.azs[var.single_nat_gateway ? 0 : count.index]) > 0
    ? substr(var.azs[var.single_nat_gateway ? 0 : count.index], length(var.azs[0]) - 2, length(var.azs[0]))
    : "all"
  )
}

module "nat_gateways" {
  source = "../../../modules/vpc/nat_gateway"
  count  = var.enable_nat_gateway ? local.num_nat_gateway : 0

  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  name                 = (
    length(var.azs[var.single_nat_gateway ? 0 : count.index]) > 0
    ? substr(var.azs[var.single_nat_gateway ? 0 : count.index], length(var.azs[0]) - 2, length(var.azs[0]))
    : "all"
  )
  eip    = module.nat_eips[count.index]
  subnet = module.public_subnets[var.single_nat_gateway ? 0 : count.index]
}

module "route_private_nat_gateways" {
  source = "../../../modules/vpc/route"
  count  = local.create_private_subnets && var.enable_nat_gateway ? local.num_nat_gateway : 0

  route_table      = module.private_route_tables[count.index]
  destination_cidr = "0.0.0.0/0"
  nat_gateway          = module.nat_gateways[count.index]
}

# module "route_restricted_nat_gateways" {
#   source = "../../../modules/vpc/route"
#   count = 0 #var.create_vpc && local.create_restricted_subnets && var.enable_nat_gateway ? local.num_nat_gateway : 0
#
#   route_table      = module.restricted_route_tables[count.index]
#   destination_cidr = "0.0.0.0/0"
#   gateway          = module.nat_gateways[*].id[count.index]
# }

################################################################################
# Module Network Access Control List
################################################################################
module "public_nacl" {
  source = "../../../modules/vpc/nacl"
  count  = local.create_public_subnets ? 1 : 0

  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  name                 = local.public_layer_name
  vpc                  = module.vpc
}

module "private_nacl" {
  source = "../../../modules/vpc/nacl"
  count  = local.create_private_subnets ? 1 : 0

  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  name                 = "application"
  vpc                  = module.vpc
}

module "restricted_nacl" {
  source = "../../../modules/vpc/nacl"
  count  = local.create_restricted_subnets ? 1 : 0

  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  name                 = "data"

  vpc = module.vpc
}

module "public_nacl_associations" {
  source = "../../../modules/vpc/nacl_association"
  count  = local.create_public_subnets ? local.len_public_subnets : 0

  network_acl = module.public_nacl[0]
  subnet      = module.public_subnets[count.index]
}

module "private_nacl_associations" {
  source = "../../../modules/vpc/nacl_association"
  count  = local.create_private_subnets ? local.len_private_subnets : 0

  network_acl = module.private_nacl[0]
  subnet      = module.private_subnets[count.index]
}

module "restricted_nacl_associations" {
  source = "../../../modules/vpc/nacl_association"
  count  = local.create_restricted_subnets ? local.len_restricted_subnets : 0

  network_acl = module.restricted_nacl[0]
  subnet      = module.restricted_subnets[count.index]
}
