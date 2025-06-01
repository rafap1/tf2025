## Data sources to identify the default vpc and its subnets
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
data "aws_vpc" "def_vpc" {
  default = true
}

# Subnet data source
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet
data "aws_subnets" "def_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.def_vpc.id]
  }
}


## Data Source - this is used to get the latest Ubuntu AMI
## It is equivalent to a query to aws with a filter:
## "Give me the ami-id of the latest ubuntu 24.04 image for X86 architecture"
data "aws_ami" "ubuntu_24_04_x86" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/*24.04-amd64-server*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}