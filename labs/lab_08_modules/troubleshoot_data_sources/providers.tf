terraform {
  required_version = "1.15.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
version = "~>6.0"
    }
  }
}

provider "aws" {
  region  = "eu-south-2"
  profile = "sso-student"

}

