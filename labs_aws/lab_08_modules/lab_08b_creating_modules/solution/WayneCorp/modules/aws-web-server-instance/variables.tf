## Mandatory variables 

variable "ec2_instance_name" {
  description = "Instance name"
  type        = string
}

variable "os" {
  description = "Select OS: Ubuntu or Amazon_linux"
  validation {
    condition     = contains(["ubuntu", "amazon_linux"], var.os)
    error_message = "Valid values for os: unbuntu or amazon_linux."
  }
}

variable "ec2_instance_type" {
  description = "Instance type for EC2 instance"
  type        = string
  validation {
    condition = anytrue([
      var.ec2_instance_type == "t3.nano",
      var.ec2_instance_type == "t3.micro"
    ])
    error_message = "Instance type must be t3.nano or t3.micro "
  }
}


variable "vpc_id" {
  description = "Id of VPC where instance will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Id of subnet where instance will be deployed (belongs to VPC)"
  type        = string
}

variable "sec_group_ids" {
  description = "IDs of Security groups (list)"
  type        = list(string)
  default     = []
}

