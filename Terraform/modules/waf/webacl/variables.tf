##################################################################
# General variables
##################################################################

variable "stack_number" {
  description = "Número para distinguir múltiples despliegues"
  type        = string
  default     = "00"

  validation {
    condition     = can(regex("^[0-9]{2}$", var.stack_number))
    error_message = "Stack Number solo permite valores de 00 al 99."
  }
}

variable "prefix_resource_name" {
  description = "Prefijo usado para nombrar recursos, como 'applying-000-mimodulo'"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.prefix_resource_name))
    error_message = "El valor debe ser en minúsculas, sin espacios ni caracteres especiales."
  }
}

variable "name" {
  description = "Nombre corto para identificar el recurso WAF"
  type        = string
}

##################################################################
# WAF Configuration
##################################################################

variable "description" {
  description = "Descripción de la Web ACL"
  type        = string
  default     = "Web ACL gestionado por Terraform"
}

variable "scope" {
  description = "Scope de la Web ACL: 'REGIONAL' para ALB/API Gateway o 'CLOUDFRONT' para CDN"
  type        = string

  validation {
    condition     = var.scope == "REGIONAL" || var.scope == "CLOUDFRONT"
    error_message = "El valor de scope debe ser 'REGIONAL' o 'CLOUDFRONT'."
  }
}

variable "rules" {
  description = "Lista de reglas WAF"
  type = list(object({
    name        = string
    priority    = number
    action_type = string
    statement = object({
      managed_rule_group_statement = object({
        name           = string
        vendor_name    = string
        excluded_rules = optional(list(string))
      })
    })
    visibility_config = object({
      cloudwatch_metrics_enabled = bool
      metric_name                = string
      sampled_requests_enabled   = bool
    })
  }))
}


variable "tags" {
  description = "Etiquetas aplicadas a todos los recursos"
  type        = map(string)
  default     = {}
}
