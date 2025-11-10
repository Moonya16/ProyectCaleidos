##################################################################
# General variables
##################################################################
variable "stack_number" {
  description = "Use to avoid conflicts when deploying various instances of this instance with the same name."
  default     = "00"
  
  validation {
    condition     = can(regex("^[0-9]{2}$", var.stack_number))
    error_message = "Stack Number solo permite valores de 00 al 99."
  }
}

variable "prefix_resource_name" {
  description = "Required - the prefix name is used to name the resources {coid}-{assetid}-{appid} or applying-000-terraform"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.prefix_resource_name))
    error_message = "The prefix_resource_name value must be lowercase!"
  }
}

################################################################################
# Cluster EKS Variables
################################################################################
variable "cluster_name" {
  description = "cluster_name"
  type        = string
}

variable "eks_version" {
  description = "eks_version"
  type        = string
}

variable "cluster_subnet_ids" {
  description = "List of subnets Ids for cluster"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of SG IDs for cluster"
  type        = list(string)
  default     = []
}