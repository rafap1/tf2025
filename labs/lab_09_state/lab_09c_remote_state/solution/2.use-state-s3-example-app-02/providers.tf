terraform {
  required_version = "= 1.13.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.99.1"
    }
  }

# Note we cannot use variables here!
  backend "s3" {
    bucket = "terraform-course-761528455679-state" ## change the 12 digit number : your account number
    ## Note key is application specific
    key = "mdr/example-02/terraform.tfstate" ## key refers to the s3 "path" to the state file, not to dynamodb
    # dynamodb_table = "terraform-course-state-locks"
    use_lockfile = true
    region       = "eu-south-2"
    encrypt      = true
    profile      = "sso-student"
  }
}

## student00 working example
# backend "s3" {
#   bucket = "acme02-terraform-state-975030449833-dev"
#   ## Note key is application specific
#   key            = "acme02/example-02/terraform.tfstate"
#   dynamodb_table = "acme02-terraform-state-locks-dev"
#   region         = "eu-south-2"
#   encrypt        = true
#   profile        = "sso-student"
#  }

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


