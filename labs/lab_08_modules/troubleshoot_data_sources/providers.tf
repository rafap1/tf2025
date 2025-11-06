terraform {
  required_version = "1.13.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }
}

provider "aws" {
  region  = "eu-south-2"
  profile = "sso-student"

}

