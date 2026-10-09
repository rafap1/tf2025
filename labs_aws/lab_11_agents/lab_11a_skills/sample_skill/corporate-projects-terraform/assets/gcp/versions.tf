terraform {
  required_version = "1.15.1" ## In production we pin terraform version to a specific one

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.6.0" ## In production we pin provider to specific version
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "8.6.0" ## In production we pin provider to specific version
    }
  }
}