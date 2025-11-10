################################################################################
# Module VPC
################################################################################
output "vpc_id" {
  description = "ID de la VPC principal"
  value       = try(module.vpc.id, null)
}

################################################################################
# Module Public Subnets
################################################################################
output "public_subnets" {
  description = "value"
  value = try(module.public_subnets, null)
}

################################################################################
# Module Private Subnets
################################################################################
output "private_subnets" {
  description = "value"
  value = try(module.private_subnets, null)
}

################################################################################
# Module Restricted Subnets
################################################################################
output "restricted_subnets" {
  description = "value"
  value = try(module.restricted_subnets, null)
}