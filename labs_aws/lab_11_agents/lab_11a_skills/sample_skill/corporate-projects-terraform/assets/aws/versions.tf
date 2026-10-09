terraform {
  required_version = "1.15.1" ## In production we pin terraform version to a specific one

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.68.0"  ## Especially for production we pin version to a fixed one
    }
  }
}
