resource "aws_wafv2_web_acl" "this" {
  name        = "${var.prefix_resource_name}-waf-${var.name}-${var.stack_number}"
  description = var.description
  scope       = var.scope
  tags        = var.tags

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.prefix_resource_name}-waf-${var.name}-${var.stack_number}"
    sampled_requests_enabled   = true
  }

  rule {
    name     = var.rules[0].name
    priority = var.rules[0].priority

    # puedes ajustar a allow {} si tu regla usa ese tipo de acción
    #action {
    #  block {}
    #}

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = var.rules[0].statement.managed_rule_group_statement.name
        vendor_name = var.rules[0].statement.managed_rule_group_statement.vendor_name
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = var.rules[0].visibility_config.cloudwatch_metrics_enabled
      metric_name                = var.rules[0].visibility_config.metric_name
      sampled_requests_enabled   = var.rules[0].visibility_config.sampled_requests_enabled
    }
  }
}