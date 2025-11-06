terraform {
  required_version = "= 1.13.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.99.1"
    }
  }
  ## Note we cannot use variables here!

  backend "s3" {
    bucket = "terraform-course-761528455679-state"
    ## key refers to the s3 "path" to the state file, not to dynamodb
    ## Note key is application specific
    key            = "mdr/example-01/terraform.tfstate"
    dynamodb_table = "terraform-course-state-locks"
    region         = "eu-south-2"
    encrypt        = true
    profile        = "sso-student"
  }
}

## Working backend config for student-00
  # backend "s3" {
  #   bucket = "terraform-course-761528455679-state"
  #   ## Note key is application specific
  #   key            = "mdr/example-01/terraform.tfstate" ## key refers to the s3 "path" to the state file, not to dynamodb
  #   dynamodb_table = "terraform-course-state-locks"
  #   region         = "eu-south-2"
  #   encrypt        = true
  #   profile        = "sso-student"
  # }


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


