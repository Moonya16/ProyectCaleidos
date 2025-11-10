output "vpc_id" {
  description = "ID de la VPC"
  value       = module.networks.vpc_id
}

output "private_subnets" {
  description = "IDs de las subredes privadas"
  value       = module.networks.private_subnets
}

