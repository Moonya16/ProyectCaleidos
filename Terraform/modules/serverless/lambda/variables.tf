##################################################################
# Lambda Configuration
##################################################################

variable "stack_number" {
  description = "Stack number para diferenciación de despliegues"
  type        = string
}

variable "name" {
  description = "Nombre"
  type        = string
}

variable "prefix_resource_name" {
  description = "Prefijo común para nombres de recursos"
  type        = string
}

variable "description" {
  description = "Descripción de la función Lambda"
  type        = string
  default     = ""
}

variable "handler" {
  description = "Handler de la función Lambda (por ejemplo, index.handler)"
  type        = string
}

variable "runtime" {
  description = "Runtime de Lambda (por ejemplo, nodejs18.x, python3.11, etc.)"
  type        = string
}

variable "timeout" {
  description = "Tiempo de espera (en segundos)"
  type        = number
  default     = 3
}

variable "memory_size" {
  description = "Memoria asignada (en MB)"
  type        = number
  default     = 128
}

variable "filename" {
  description = "Path to the Lambda zip file"
  type        = string
}

variable "source_code_hash" {
  description = "Base64-encoded SHA256 hash of the Lambda source"
  type        = string
}

##################################################################
# Environment & Permissions
##################################################################

variable "environment" {
  description = "Variables de entorno"
  type        = map(string)
  default     = {}
}

#variable "policy_statements" {
#  description = "Políticas en formato JSON para permisos adicionales (opcional)"
#  type = list(object({
#    effect    = string
#    actions   = list(string)
#    resources = list(string)
#  }))
#  default = []
#}

variable "layers" {
  description = "ARNs de layers opcionales"
  type        = list(string)
  default     = []
}

variable "role_policy_json" {
  description = "Política personalizada en formato JSON (opcional)"
  type        = string
  default     = null
}

##################################################################
# Tags
##################################################################

variable "tags" {
  description = "Etiquetas comunes para los recursos"
  type        = map(string)
  default     = {}
}
