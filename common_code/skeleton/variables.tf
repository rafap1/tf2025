## AWS Specific parameters

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "profile" {
  type = string
}

## Environment and Project
variable "company" {
  type        = string
  description = "company name - will be used in tags"
}
variable "environment" {
  type        = string
  description = "e.g. test dev prod"
}

variable "project" {
  type = string
}

variable "lab_number" {
  type    = string
}

## VPC parameters
variable "vpc_cidr" {
  type    = string
  default = "10.99.0.0/16"
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Invalid CIDR for VPC."
  }
}
