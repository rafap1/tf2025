## AWS Specific parameters

variable "region" {
  type    = string
  default = "eu-south-2"
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
  type = string
}

## VPC and subnet parameters

## VPC parameters
variable "vpc_cidr1" {
  type = string
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr1)) && endswith(var.vpc_cidr1, "/16")
    error_message = "Invalid CIDR for VPC"
  }
}

variable "pub_subnets" {
  type        = list(string)
  description = "list of subnets used for public subnets"
}

variable "priv_subnets" {
  type        = list(string)
  description = "list of subnets used for private subnets"
}

## VPC parameters
variable "vpc_cidr2" {
  type    = string
  default = "10.12.0.0/16"
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr2)) ## Needs work
    error_message = "Invalid CIDR for VPC."
  }
}

variable "other_public_subnets" {
  type        = list(string)
  description = "list of subnets used for public subnets"
  default     = ["10.12.1.0/24", "10.12.2.0/24"]
}

variable "other_private_subnets" {
  type        = list(string)
  description = "list of subnets used for private subnets"
  default     = ["10.12.10.0/23", "10.12.12.0/23"]
}

## EC2 Instance Parameters
variable "num_instances" {
  default = 6
}
variable "instance_type" {
  type    = string
  default = "t3.nano"
}

## Security Groups
variable "sec_allowed_external" {
  description = "CIDRs from which access is allowed"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

## ECS Parameters
variable "special_port" {
  type = string
}

