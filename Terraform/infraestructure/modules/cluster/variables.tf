variable "prefix_resource_name" {
  description = "Prefijo del nombre para todos los recursos"
  type        = string
}

variable "cluster_name" {
  description = "Nombre base del cluster"
  type        = string
}

variable "stack_number" {
  description = "Identificador único o número de stack"
  type        = string
}

variable "vpc_id" {
  description = "vpc"
  type        = string
}


variable "kms_key_arn" {
  description = "kms_key_arn"
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.69.0.0/20"

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/([0-2][0-9]|3[0-2]|[0-9])$", var.vpc_cidr))
    error_message = "The CIDR must be in valid format (example: 127.0.0.1/23)."
  }
}

variable "eks_version" {
  description = "Versión de EKS a desplegar"
  type        = string
  default     = "1.31"
}

variable "cluster_subnet_ids" {
  description = "Lista de subnets donde se desplegará el cluster"
  type        = list(string)
}
