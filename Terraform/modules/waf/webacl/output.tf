output "id" {
  description = "ID de la Web ACL"
  value       = aws_wafv2_web_acl.this.id
}

output "arn" {
  description = "ARN completo de la Web ACL"
  value       = aws_wafv2_web_acl.this.arn
}

output "name" {
  description = "Nombre asignado a la Web ACL"
  value       = aws_wafv2_web_acl.this.name
}

output "scope" {
  description = "Scope utilizado por la Web ACL (REGIONAL o CLOUDFRONT)"
  value       = aws_wafv2_web_acl.this.scope
}
