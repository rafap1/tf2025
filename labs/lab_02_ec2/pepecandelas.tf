terraform {
  required_version = "1.12.2"
  # required_version = "~> 1.12.0"
  #  required_version = "~> 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
      # version = "5.96"
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
      "${var.company}:cost-center" = var.cost_center
      created_by                   = "terraform"
    }
  }
}
