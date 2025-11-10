locals {
  module_name = "base"
  module_tags = {
    "module" = local.module_name
  }
}

data "aws_caller_identity" "current" {}
module "key" {
  source               = "../../../modules/kms/customer-key"
  name                 = local.module_name
  stack_number         = var.stack_number
  prefix_resource_name = var.prefix_resource_name
  tags                 = local.module_tags
}
