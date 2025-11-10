################################################################################
# Security Group para el Cluster EKS
################################################################################
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.prefix_resource_name}-eks-sg-${var.cluster_name}-${var.stack_number}"
  description = "Security Group para el EKS Cluster ${var.cluster_name}"
  vpc_id      = var.vpc_id

  ingress {
    description = "Permitir trafico desde nodos del cluster"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr != null ? [var.vpc_cidr] : []
  }

  egress {
    description = "Permitir salida a cualquier destino"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix_resource_name}-eks-sg-${var.cluster_name}-${var.stack_number}"
  }
}

################################################################################
# EKS Cluster
################################################################################
module "eks_cluster" {
  source = "../../../modules/eks/cluster_eks"

  prefix_resource_name = var.prefix_resource_name
  cluster_name         = var.cluster_name
  stack_number         = var.stack_number
  eks_version          = "1.34"

  cluster_subnet_ids   = var.cluster_subnet_ids
  security_group_ids   = [aws_security_group.eks_cluster_sg.id]
}

################################################################################
# Launch Template para los nodos
################################################################################
resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "${var.prefix_resource_name}-${var.cluster_name}-lt-"
  instance_type = "t3.medium"

  # Disco raíz (obligatorio cuando usas launch_template en EKS)
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = var.kms_key_arn != "" ? var.kms_key_arn : null
    }
  }

  # Etiquetas que se aplicarán a las instancias EC2
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name                 = "${var.prefix_resource_name}-${var.cluster_name}-node"
      "eks:cluster-name"   = "${var.prefix_resource_name}-eks-cluster-${var.cluster_name}-${var.stack_number}"
      "eks:nodegroup-name" = "${var.prefix_resource_name}-${var.cluster_name}-node-group"
    }
  }

  # Etiquetas para los volúmenes EBS asociados
  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${var.prefix_resource_name}-${var.cluster_name}-volume"
    }
  }

  tags = {
    Name = "${var.prefix_resource_name}-${var.cluster_name}-lt"
  }
}


################################################################################
# Node Group (EKS Managed EC2 Nodes)
################################################################################
module "eks_node_group" {
  source = "../../../modules/eks/node_group"

  prefix_resource_name = var.prefix_resource_name
  stack_number         = var.stack_number
  cluster_name         = var.cluster_name
  node_group_name      = var.cluster_name
  cluster_subnet_ids   = var.cluster_subnet_ids

  node_instance_type = ["t3.micro"]
  node_volume_size   = 20

  desired_capacity = 0
  min_size         = 0
  max_size         = 2

  launch_template_id = aws_launch_template.eks_nodes.id
}
