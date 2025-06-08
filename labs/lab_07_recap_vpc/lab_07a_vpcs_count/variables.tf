## AWS Specific parameters

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "profile" {
  type    = string
  default = "sso-student"
}


## Environment and Project
variable "company" {
  type        = string
  description = "company name - will be used in tags"
  default     = "lumon"
}
variable "environment" {
  type        = string
  description = "e.g. test dev prod"
  default     = "dev"
}

variable "project" {
  type    = string
  default = "mdr"
}

variable "lab_number" {
  type    = string
  default = "put-a-lab-number-here"
}

## VPC and subnet parameters

## VPC parameters
variable "vpc_cidr" {
  type    = string
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr)) && endswith(var.vpc_cidr, "/16")
    error_message = "VPC CIDR must be valid and use a /16 subnet mask."
  }
}

variable "az_count" {
  type    = number
  default = 2
  validation {
    condition     = var.az_count >= 1 && var.az_count <= 3
    error_message = "AZ count must be between 1 and 3."
  }
}
variable "create_nat_gw" {
  type    = bool
  default = false
}


