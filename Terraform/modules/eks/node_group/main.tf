locals {

}

################################################################################
# Role
################################################################################
resource "aws_iam_role" "eks_node_role" {
  name = "${var.prefix_resource_name}-eks-nodegroup-${var.node_group_name}-${var.stack_number}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
}

################################################################################
# Node Group
################################################################################
resource "aws_eks_node_group" "eks_nodegroup" {
  cluster_name    = "${var.prefix_resource_name}-eks-cluster-${var.cluster_name}-${var.stack_number}"
  node_group_name = "${var.prefix_resource_name}-${var.node_group_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.cluster_subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  dynamic "launch_template" {
    for_each = var.launch_template_id != "" ? [var.launch_template_id] : []
    content {
      id      = launch_template.value
      version = "$Latest"
    }
  }

  instance_types = var.launch_template_id == "" ? var.node_instance_type : null

  disk_size = var.launch_template_id == "" ? var.node_volume_size : null

  labels = {
    "alpha.eksctl.io/cluster-name"   = var.cluster_name
    "alpha.eksctl.io/nodegroup-name" = "${var.prefix_resource_name}-${var.node_group_name}-node-group"
  }

  tags = {
    "alpha.eksctl.io/nodegroup-name" = "${var.prefix_resource_name}-${var.node_group_name}-node-group"
    "alpha.eksctl.io/nodegroup-type" = "managed"
  }
}
