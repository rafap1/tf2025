terraform {
  # required_version = "~> 1.12.0"
  required_version = "1.13.4"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "~>5.0"
      version = "6.19.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
  default_tags {
    tags = {
      "${var.company}:environment" = var.environment
      "${var.company}:project"     = var.project
      created_by                   = "terraform"
    }
  }
}
