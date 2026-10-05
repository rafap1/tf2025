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
  description = "Project - used for tagging"
}

variable "cost_center" {
  type = string
  description = "Cost Center - potentially used for billing assignment"
}
