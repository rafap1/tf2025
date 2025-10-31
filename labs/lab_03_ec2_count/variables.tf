## AWS Specific parameters

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "profile" {
  description = "AWS Profile for authentication of Terraform"
  type        = string
}

## Company, Environment and Project
variable "company" {
  type        = string
  description = "Company name - will be used in tags"
}

variable "environment" {
  type        = string
  description = "Environment - e.g. dev, stage, prod"
}

variable "project" {
  type        = string
  description = "Project Name - will be used to name resources"
}

variable "cost_center" {
  type        = string
  description = "Cost Center"
}

variable "lab_number" {
  type        = string
  description = "Lab Number - used to name resources"
}

## Lab specific variables

variable "num_instances" {
  type    = number
  default = 0
}


## VPC parameters
variable "vpc_cidr" {
  type    = string
  default = "10.99.0.0/16"
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr)) ## Needs work
    error_message = "Invalid CIDR for VPC."
  }
}

## EC2 Instance Parameters

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "my_ami" {
  description = "ami for EC2 instance"
  type        = string
  default     = "ami-0b752bf1df193a6c4"
}



## Security Groups
variable "sec_allowed_external" {
  description = "CIDRs from which access is allowed"
  type        = list(string)

}

## ECS Parameters
variable "special_port" {
  type        = string
  description = "TCP port where Foobar application listens"
}

