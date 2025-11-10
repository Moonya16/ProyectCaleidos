locals {

}

################################################################################
# Role
################################################################################
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.prefix_resource_name}-eks-role-${var.cluster_name}-${var.stack_number}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
  "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"]
}


################################################################################
# Cluster EKS
################################################################################
resource "aws_eks_cluster" "eks_cluster" {
  name = "${var.prefix_resource_name}-eks-cluster-${var.cluster_name}-${var.stack_number}"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids         = var.cluster_subnet_ids
    security_group_ids = var.security_group_ids
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  tags = {
    Name = var.cluster_name
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

}
