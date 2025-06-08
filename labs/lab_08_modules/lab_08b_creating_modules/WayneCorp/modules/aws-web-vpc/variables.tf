## Mandatory variables

variable "vpc_name" {
  description = "Name of VPC to be created"
  type    = string
}

variable "vpc_cidr_block" {
  description = "CIDR block VPC"
  type = string
}

variable "subnet_cidr_block" {
  description = "CIDR for Subnet (should be part of VPC CIDR)"
  type    = string
}

variable "subnet_name" {
  description = "Name of Subnet to be created"
  type    = string
}

## Optional variables

variable "aws_az" {
  description = "AZ where subnet will be created"
  type    = string
  default = "eu-west-1a"
}

variable "igw_name" {
  description = "Name of IGW"
  type    = string
  default = "web_server_igw"
}

variable "rt_name" {
  description = "Name of Route Table"
  type    = string
  default = "web_server_rt"
}


