## We use the "Random provider" to make sure security group names are unique

terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

