terraform {
  required_version = "1.14.9"

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

