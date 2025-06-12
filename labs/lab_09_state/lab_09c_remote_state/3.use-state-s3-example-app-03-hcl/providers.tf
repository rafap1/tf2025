terraform {
  required_version = "= 1.12.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.99.1"
    }
  }
  backend "s3" {
    ## Backend configuration almost empty
    ## most of the common config is in file ../backend.hcl
    key = "mdr/example-03/terraform.tfstate"
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
  default_tags {
    tags = {
      environment = var.environment
      project     = var.project
      created_by  = "terraform"
      disposable  = true
    }
  }
}

 