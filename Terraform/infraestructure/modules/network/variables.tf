##################################################################
# General variables
##################################################################
variable "global_tags" {
  type    = map(string)
  default = {}
}

variable "stack_number" {
  description = "Use to avoid conflicts when deploying various instances of this instance with the same name."
  type        = string
  default     = "00"

  validation {
    condition     = can(regex("^[0-9]{2}$", var.stack_number))
    error_message = "Stack Number solo permite valores de 00 al 99."
  }
}

variable "prefix_resource_name" {
  description = "Required - the prefix name is used to name the resources {coid}-{assetid}-{appid} or applying-000-terraform"
  type        = string
  default     = "apply-0000-trfm"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.prefix_resource_name))
    error_message = "The prefix_resource_name value must be lowercase!"
  }
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

################################################################################
# VPC Variables
################################################################################
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.69.0.0/20"

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/([0-2][0-9]|3[0-2]|[0-9])$", var.vpc_cidr))
    error_message = "The CIDR must be in valid format (example: 127.0.0.1/23)."
  }
}

################################################################################
# Public Subnet Variables
################################################################################
variable "public_subnets" {
  description = "List of Cidr for public subnets"
  type        = list(string)
  default     = []
}

variable "create_multiple_public_route_tables" {
  description = "Indicates whether to create a separate route table for each public subnet. Default: `false`"
  type        = bool
  default     = false
}

################################################################################
# Private Subnet Variables
################################################################################
variable "private_subnets" {
  description = "List of Cidr for private subnets"
  type        = list(string)
  default     = []
}

################################################################################
# Restricted Subnet Variables
################################################################################
variable "restricted_subnets" {
  description = "List of Cidr for restricted subnets"
  type        = list(string)
  default     = []
}

################################################################################
# NAT gateway Variables
################################################################################
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

