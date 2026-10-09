## Azure Specific parameters

variable "subscription_id" {
  type        = string
  description = "Azure subscription id where resources are deployed"
}

variable "location" {
  type    = string
  default = "spaincentral"
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
  type        = string
  description = "Project - used for tagging"
}

variable "cost_center" {
  type        = string
  description = "Cost Center - potentially used for billing assignment"
}
