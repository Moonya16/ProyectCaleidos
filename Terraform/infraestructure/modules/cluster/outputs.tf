################################################################################
# Outputs del módulo intermedio (cluster)
################################################################################

output "eks_cluster_name" {
  description = "Nombre del cluster EKS creado"
  value       = module.eks_cluster.eks_cluster_name
}

output "eks_cluster_arn" {
  description = "ARN del cluster EKS"
  value       = module.eks_cluster.eks_cluster_arn
}

output "eks_cluster_endpoint" {
  description = "Endpoint público del cluster EKS"
  value       = module.eks_cluster.eks_cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "CA del cluster EKS"
  value       = module.eks_cluster.eks_cluster_certificate_authority_data
}

output "eks_cluster_security_group_id" {
  description = "ID del Security Group asociado al cluster EKS"
  value       = aws_security_group.eks_cluster_sg.id
}
