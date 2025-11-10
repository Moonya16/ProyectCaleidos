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
# Node Group Variables
################################################################################
variable "cluster_name" {
  description = "cluster_name"
  type        = string
}

variable "node_group_name" {
  description = "node_group_name"
  type        = string
}

variable "launch_template_id" {
  description = "launch_template_id"
  type        = string
}

variable "desired_capacity" {
  description = "desired_capacity"
  type        = number
}

variable "cluster_subnet_ids" {
  description = "List of subnets Ids for cluster"
  type        = list(string)
  default     = []
}

variable "max_size" {
  description = "max_size"
  type        = number
}

variable "min_size" {
  description = "min_size"
  type        = number
}

variable "node_volume_size" {
  description = "min_size"
  type        = number
}

variable "node_instance_type" {
  description = "node_instance_type"
  type        = list(string)
}
