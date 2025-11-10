##################################################################
# General variables
##################################################################
variable "global_tags" {
  type = map(string)
  default = {}
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1" # o la región que uses
}

variable "aws_profile" {
  description = "AWS profile name"
  type        = string
  default     = "default" # o el nombre de tu perfil en ~/.aws/credentials
}


variable "stack_number" {
  description = "Use to avoid conflicts when deploying various instances of this instance with the same name."
  type        = string
  default     = "00"

  validation {
    condition = can(regex("^[0-9]{2}$", var.stack_number))
    error_message = "Stack Number solo permite valores de 00 al 99."
  }
}

variable "prefix_resource_name" {
  description = "Required - the prefix name is used to name the resources {coid}-{assetid}-{appid} or applying-000-terraform"
  type        = string
  default     = "aply-0001-gen-all"

  validation {
    condition = can(regex("^[a-z0-9-]+$", var.prefix_resource_name))
    error_message = "The prefix_resource_name value must be lowercase!"
  }
}
##################################################################
# Module variables
##################################################################

variable "network" {
  type = object({
    azs = list(string)
    vpc_cidr = string
    enable_nat_gateway = optional(bool, true)
    single_nat_gateway = optional(bool, true)
    public_subnets = list(string)
    private_subnets = list(string)
    restricted_subnets = list(string)
  })
}

variable "is_production" {
  type    = bool
  default = false
}

