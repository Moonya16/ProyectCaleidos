# Develop v3
terraform {
  backend "s3" {
    bucket = "PLACEHOLDER_BUCKET"
    key    = "PLACEHOLDER_KEY"
    region = "PLACEHOLDER_REGION"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.81.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = var.global_tags
  }
}