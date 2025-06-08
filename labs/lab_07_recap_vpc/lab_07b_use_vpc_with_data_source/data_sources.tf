
data "aws_availability_zones" "available" {
  state = "available"
}

## ================Data Source - for Ubuntu AMI ============
## this is used to get the latest Ubuntu 24.04 AMI
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

### ===================  data sources for VPC and subnets ===================
data "aws_vpc" "my_vpc" {
  tags = {
    Name = "vpc-${local.vpc_name_expresion}-*"
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.my_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["private-${local.vpc_name_expresion}-*"]
  }
}
## Note difference between data source "aws_subnets" (above) and "aws_subnet" (below)
## aws subnet returns info for a single subnet.  
## Below we "call it" several times create a map of objects "indexed" by subnet id
/*
map(object({
  id               = string
  cidr_block       = string
  availability_zone = string
  ...
}))
*/
## We use it as auxiliary input in one of the outputs

data "aws_subnet" "private_subnet_info" {
  for_each = toset(data.aws_subnets.private_subnets.ids)
  id       = each.value
}


